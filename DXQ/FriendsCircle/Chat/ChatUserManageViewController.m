//
//  ChatUserManageViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-16.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ChatUserManageViewController.h"
#import "NearByListCell.h"
#import "Users.h"
#import "UIImageView+WebCache.h"
#import "DXQCoreDataEntityBuilder.h"
#import "UIButton+WebCache.h"

@interface ChatUserManageViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ChatUserManageViewController

-(void)dealloc{

    [_tableView release];
    [_userArray release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{

    [super loadView];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [tableView release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
//    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Set

-(void)setTableView:(UITableView *)tableView{

    if ([tableView isEqual:_tableView]) {
        return;
    }
    [_tableView removeFromSuperview];
    [_tableView release];
    _tableView=[tableView retain];
    [self.view addSubview:_tableView];
}

-(void)setUserArray:(NSArray *)userArray{

    if ([userArray isEqualToArray:_userArray]) {
        return;
    }
    [_userArray release];
    _userArray=[userArray retain];
    [self.tableView reloadData];
}

#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _userArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier=@"NearByListCell";
    NearByListCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[NearByListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    Users *user=[_userArray objectAtIndex:indexPath.row];
    NSDictionary *item = [[DXQCoreDataEntityBuilder sharedCoreDataEntityBuilder]DXQAccountToNSDictionary:(DXQAccount *)user];
    NSString *picurl = [NSString stringWithFormat:@"%@%@",[item objectForKey:@"PhotoUrl"],THUMB_IMAGE_SUFFIX];
    if (!picurl)picurl = @"";
    [cell.avatarImg setImageWithURL:[NSURL URLWithString:[picurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]placeholderImage:[UIImage imageNamed:@"tx_gray.png"]];
    cell.usernameLbl.text = [item objectForKey:@"MemberName"];
    NSString  *ageImgName = ([[item objectForKey:@"Sex"] intValue]==0)?@"pyq_girl.png":@"pyq_boy.png";
    cell.ageImg.image = [UIImage imageNamed:ageImgName];
    cell.ageLbl.text = [[item objectForKey:@"Age"] stringValue];
    cell.distanceLbl.text = [NSString stringWithFormat:@"%@  |  当前在线",[[GPS gpsManager] getDistanceFromLat:[item objectForKey:@"WeiDu"] Lon:[item objectForKey:@"JingDu"]]];
    NSString *statusString = [item objectForKey:@"Introduction"];
    if (!statusString || [statusString isEqual:[NSNull null]]  || [statusString length]<1 )
    {
        statusString = AppLocalizedString(@"这家伙很懒...");
    }
    else
    {
        statusString = [Tool decodeBase64:statusString];
    }
    cell.statusLbl.text = statusString;
    
    return cell;

}
@end
