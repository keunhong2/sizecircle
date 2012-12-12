//
//  BlackFriendViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-8.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BlackFriendViewController.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "UserLoadBlackList.h"    
#import "NearByListCell.h"
#import "UserDetailInfoVC.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface BlackFriendViewController ()<BusessRequestDelegate>{

    UserLoadBlackList *blackListRequest;
}

@end

@implementation BlackFriendViewController


-(void)dealloc{

    [_tableView release];
    [_blackList release];
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
    [tableView setSeparatorColor:TABLEVIEW_SEPARATORCOLOR];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [tableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"黑名单") backItemTitle:AppLocalizedString(@"返回")];
}

-(void)viewDidUnload{

    self.tableView=nil;
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self cancelAllRequest];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    if (!_blackList) {
        [self.tableView pullToRefresh];
    }
}

#pragma mark -UITableViewDataSource And Delegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 72.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.blackList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier=@"NearByListCell";
    NearByListCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[NearByListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *item = [_blackList objectAtIndex:indexPath.row];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserDetailInfoVC *vc=[[UserDetailInfoVC alloc]initwithUserInfo:[_blackList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
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
    [_tableView setPullToRefreshHandler:^{
    
        [self requestBlackList];
    }];
}

-(void)setBlackList:(NSArray *)blackList{

    if ([blackList isEqualToArray:_blackList]) {
        return;
    }
    [_blackList release];
    _blackList=[blackList retain];
    [self.tableView reloadData];
}

#pragma mark -Request

-(void)cancelAllRequest{

    [self cancelGetBlackRequest];
}

-(void)cancelGetBlackRequest{

    if (blackListRequest) {
        [blackListRequest cancel];
        [blackListRequest release];
        blackListRequest=nil;
    }
}

-(void)requestBlackList{

    [self cancelGetBlackRequest];
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSString *sex=@"-1";
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accountID,@"AccountId",sex,@"Sex", nil];
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"获取黑名单中...")];
    blackListRequest=[[UserLoadBlackList alloc]initWithRequestWithDic:dic];
    blackListRequest.delegate=self;
    [blackListRequest startAsynchronous];
}

#pragma mark -

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [self.tableView refreshFinished];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    [[ProgressHUD sharedProgressHUD]done:YES];
    
    [self.tableView refreshFinished];
    
    if (request==blackListRequest) {
        self.blackList=data;
    }
}
@end
