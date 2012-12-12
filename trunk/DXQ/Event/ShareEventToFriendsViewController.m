//
//  ShareEventToFriendsViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-29.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ShareEventToFriendsViewController.h"
#import "UserLoadFriendList.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "UIImageView+WebCache.h"
#import "UserInviteFriend.h"

@interface ShareEventToFriendsViewController ()<BusessRequestDelegate>{

    UserLoadFriendList *friendsRequest;
    UserInviteFriend *inviteRequest;
}

@end

@implementation ShareEventToFriendsViewController

-(void)dealloc{

    [_friendList release];
    [_selectFriendList release];
    [_tableView release];
    [_eventInfoDic release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectFriendList=[NSMutableArray new];
    }
    return self;
}

-(void)loadView{

    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [self.tableView setPullToRefreshHandler:^{
    
        [self getFriendList];
    }];
    [self.tableView setPullToRefreshViewLoadingText:AppLocalizedString(@"正在获取好友列表")];
    [self.tableView setPullToRefreshViewPullingText:AppLocalizedString(@"下拉获取好友列表")];
    [tableView release];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self cancelAllRequest];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    if (_friendList==nil) {
        [self.tableView pullToRefresh];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"邀请好友") backItemTitle:AppLocalizedString(@"返回")];
    
    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [doneBtn setTitle:AppLocalizedString(@"确定") forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnDone) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn sizeToFit];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem=item;
    [item release];
}

-(void)doneBtnDone{

    if (_selectFriendList.count==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"您至少需要选择一个人才能邀请.")];
        return;
    }
    [self inviteFriends];
}

#pragma mark -Request

-(void)cancelAllRequest{

    [self cancelGetFriendList];
    [self cancelInviteRequest];
}

-(void)cancelGetFriendList
{
    if (friendsRequest) {
        [friendsRequest cancel];
        [friendsRequest release];
        friendsRequest=nil;
    }
}

-(void)getFriendList{

    [self cancelGetFriendList];
 
    NSDictionary *pager=[NSDictionary dictionaryWithObjectsAndKeys:
                         @"1",@"PageIndex",
                         @"9999",@"ReturnCount", nil];
    NSString *accoundId=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:pager,@"Pager",accoundId,@"AccountId",@"0",@"FriendType", nil];
    friendsRequest=[[UserLoadFriendList alloc]initWithRequestWithDic:dic];
    friendsRequest.delegate=self;
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在获取好友列表")];
    [friendsRequest startAsynchronous];
}

-(void)cancelInviteRequest{

    if (inviteRequest) {
        [inviteRequest cancel];
        [inviteRequest release];
        inviteRequest=nil;
    }
}

-(void)inviteFriends{

    [self cancelInviteRequest];
    
     NSString *accoundId=[[SettingManager sharedSettingManager]loggedInAccount];
    NSMutableArray *tempList=[NSMutableArray new];
    for (NSDictionary *dic in _selectFriendList) {
        [tempList addObject:[dic objectForKey:@"AccountId"]];
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       accoundId,@"AccountFrom",
                       tempList,@"FriendAccounts",
                       [_eventInfoDic objectForKey:@"ProductCode"],@"ProductCode", nil];
    inviteRequest=[[UserInviteFriend alloc]initWithRequestWithDic:dic];
    inviteRequest.delegate=self;
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在邀请中...")];
    [inviteRequest startAsynchronous];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg
{
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [self.tableView refreshFinished];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    [self.tableView refreshFinished];
    
    if (request==friendsRequest) {
        self.friendList=data;
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"获取好友列表成功")];
        [self.tableView reloadData];
    }else if (request==inviteRequest){
    
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"邀请成功")];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[ProgressHUD sharedProgressHUD]done:YES];
}

#pragma mark -UITableViewDataSource And Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _friendList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *shareIdenti=@"share";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:shareIdenti];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:shareIdenti] autorelease];
    }
    NSDictionary *dic=[_friendList objectAtIndex:indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"MemberName"];
    cell.detailTextLabel.text=[dic objectForKey:@"Introduction"];
    NSString *url=[[dic objectForKey:@"PhotoUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_header"]];
    if ([_selectFriendList containsObject:dic]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else
        cell.accessoryType=UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic=[_friendList objectAtIndex:indexPath.row];
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    if ([_selectFriendList containsObject:dic]) {
        [_selectFriendList removeObject:dic];
        cell.accessoryType=UITableViewCellAccessoryNone;
    }else
    {
        [_selectFriendList addObject:dic];
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
}
@end
