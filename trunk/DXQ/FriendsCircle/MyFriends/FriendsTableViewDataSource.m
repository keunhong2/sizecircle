//
//  FriendsTableViewDataSource.m
//  DXQ
//
//  Created by Yuan on 12-10-24.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "FriendsTableViewDataSource.h"
#import "FriendsListCell.h"
#import "MyFriendsVC.h"

@interface FriendsTableViewDataSource()
{
    UITableView *listTableView;
}
@property (nonatomic,assign)UIViewController *viewControl;
@property (retain, nonatomic)NSMutableArray  *data;
@end

@implementation FriendsTableViewDataSource
@synthesize data = _data;
@synthesize viewControl = _viewControl;

- (void)dealloc
{
    [_viewControl release];_viewControl = nil;
    [_data release];_data = nil;
    [super dealloc];
}

-(id)initWithViewControl:(UIViewController *)viewControl;
{
    if(self = [super init])
    {
        _viewControl = viewControl;
        
        _data = [[NSMutableArray alloc]init];
        
    }
    return self;
}

-(void)reloadData:(NSArray *)arr tableView:(UITableView *)tableview
{
    listTableView = tableview;
    [_data removeAllObjects];
    [_data addObjectsFromArray:arr];
    [listTableView reloadData];
}

#pragma mark -UITableViewDataSourceAndDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //for test
    return [_data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self ListCellForIndexPath:indexPath withTableView:tableView];
}

-(UITableViewCell *)ListCellForIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView
{
    static NSString *cellIdentifier=@"NearByListCell";
    FriendsListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[FriendsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *item = [_data objectAtIndex:indexPath.row];
    NSString *picurl = [NSString stringWithFormat:@"%@%@",[item objectForKey:@"PhotoUrl"],THUMB_IMAGE_SUFFIX];
    if (!picurl)picurl = @"";
    [cell.avatarImg setImageWithURL:[NSURL URLWithString:[picurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]placeholderImage:[UIImage imageNamed:@"tx_gray.png"]];
    [cell.avatarImg addTarget:self action:@selector(viewUserDetailInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.usernameLbl.text = [item objectForKey:@"MemberName"];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = [_data objectAtIndex:indexPath.row];
    [(MyFriendsVC *)_viewControl chatWithUserInfo:item];
}

-(void)viewUserDetailInfoAction:(UIButton *)btn
{
    FriendsListCell *cell = (FriendsListCell *)([[btn superview]superview]);
    NSIndexPath *indexPath =  [listTableView indexPathForCell:cell];
    NSDictionary *item = [_data objectAtIndex:indexPath.row];
    [(MyFriendsVC *)_viewControl viewUserDetailInfo:item];
}

@end

