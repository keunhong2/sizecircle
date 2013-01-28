//
//  SendGiftViewController.m
//  DXQ
//
//  Created by 黄修勇 on 13-1-27.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "SendGiftViewController.h"
#import "UserLoadFriendList.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "UserSendGift.h"
#import "FriendsListCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"


@interface SendGiftViewController ()<BusessRequestDelegate>{

    UserLoadFriendList *friendRequest;
    UserSendGift *sendGiftRequest;
}

@property (nonatomic,retain)NSArray *list;
@property (nonatomic,retain)UITableView *tableView;

@end

@implementation SendGiftViewController


-(id)initWithProductDic:(NSDictionary *)productDic{

    self=[super init];
    if (self) {
        self.productDic=productDic;
    }
    return self;
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
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView=tableView;
    [tableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavgationTitle:@"送礼" backItemTitle:@"返回"];
    
    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"确认" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:MiddleBoldDefaultFont];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    [rightItem release];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    if (self.list==nil) {
        [self.tableView pullToRefresh];
    }
}
-(void)dealloc{

    [self cancelAllRequest];
    [_list release];
    [_productDic release];
    [super dealloc];
}

-(void)editAction:(id)sender{

    if (_selectIndexPath==nil) {
        [Tool showAlertWithTitle:@"提示" msg:@"请选择送礼的对象"];
        return;
    }
    
    NSDictionary *sendUser=[_list objectAtIndex:_selectIndexPath.row];
    [self sendGiftToUserID:[sendUser objectForKey:@"AccountId"]];
}

#pragma mark -Set

-(void)setList:(NSArray *)list{

    if ([list isEqualToArray:_list]) {
        return;
    }
    [_list release];
    _list=[list retain];
    [self.tableView reloadData];
}

-(void)setSelectIndexPath:(NSIndexPath *)selectIndexPath{
    
    if ([selectIndexPath isEqual:_selectIndexPath]) {
        return;
    }
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:_selectIndexPath];
    cell.accessoryType=UITableViewCellAccessoryNone;
    [_selectIndexPath release];
    _selectIndexPath=[selectIndexPath retain];
    cell=[self.tableView cellForRowAtIndexPath:selectIndexPath];
    cell.accessoryType=UITableViewCellAccessoryCheckmark;
}

-(void)setTableView:(UITableView *)tableView{

    if ([tableView isEqual:_tableView]) {
        return;
    }
    [_tableView removeFromSuperview];
    [_tableView release];
    _tableView=[tableView retain];
    [self.view addSubview:_tableView];
    
    [_tableView setPullToRefreshHandler:^{
    
        [self requestAllFriends];
    }];
}

#pragma mark -TableViewDataSource And Delegata

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *friendList=@"friend list";
    FriendsListCell *cell=[tableView dequeueReusableCellWithIdentifier:friendList];
    if (!cell) {
        cell=[[[FriendsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:friendList] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    }
    NSDictionary *item = [_list objectAtIndex:indexPath.row];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndexPath=indexPath;
}

#pragma mark -Request

-(void)cancelAllRequest{

    [self cancelRequestFriendList];
    [self cancelSendGiftRequest];
}

-(void)cancelRequestFriendList{

    if (friendRequest) {
        [friendRequest cancel];
        [friendRequest release];
        friendRequest=nil;
    }
}

-(void)requestAllFriends{

    [self cancelRequestFriendList];
    
    NSDictionary *pageDic=[NSDictionary dictionaryWithObjectsAndKeys:
                           [NSString stringWithFormat:@"%d",1],@"PageIndex",
                           [NSString stringWithFormat:@"%d",9999],@"ReturnCount", nil];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:pageDic,@"Pager",[[SettingManager sharedSettingManager]loggedInAccount],@"AccountId",@"0",@"FriendType", nil];
    friendRequest=[[UserLoadFriendList alloc]initWithRequestWithDic:dic];
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:@"获取好友列表"];
    friendRequest.delegate=self;
    [friendRequest startAsynchronous];
}


-(void)cancelSendGiftRequest
{
    if (sendGiftRequest) {
        [sendGiftRequest cancel];
        [sendGiftRequest release];
        sendGiftRequest=nil;
    }
}

-(void)sendGiftToUserID:(NSString *)userID{

    [self cancelSendGiftRequest];
    
    NSArray *itemList=[_productDic objectForKey:@"Items"];
    if (itemList.count==0) {
        return;
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[[SettingManager sharedSettingManager]loggedInAccount],@"AccountFrom",userID,@"AccountTo",[itemList objectAtIndex:0],@"OrderProductCode", nil];
    sendGiftRequest=[[UserSendGift alloc]initWithRequestWithDic:dic];
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
    [[ProgressHUD sharedProgressHUD]setText:@"送礼中..."];
    sendGiftRequest.delegate=self;
    [sendGiftRequest startAsynchronous];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg
{
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    if (request==friendRequest) {
        [[ProgressHUD sharedProgressHUD]done:YES];
        self.list=data;
        [self.tableView refreshFinished];
    }else if (request==sendGiftRequest){
    
        [[ProgressHUD sharedProgressHUD]setText:@"送礼成功"];
        [[ProgressHUD sharedProgressHUD]done:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
