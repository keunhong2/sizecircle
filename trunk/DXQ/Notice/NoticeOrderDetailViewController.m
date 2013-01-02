//
//  NoticeOrderDetailViewController.m
//  DXQ
//
//  Created by 黄修勇 on 13-1-2.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "NoticeOrderDetailViewController.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "UserLoadOrderDetail.h"

@interface NoticeOrderDetailViewController ()<BusessRequestDelegate>{

    UserLoadOrderDetail *detailRequest;
}
@end

@implementation NoticeOrderDetailViewController

-(void)dealloc{

    [self cancelAllRequest];
    [_tableView release];
    [_simpleDic release];
    [_detailDic release];
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
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleRightMargin;
    tableView.backgroundView=nil;
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [tableView release];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavgationTitle:AppLocalizedString(@"订单详情") backItemTitle:AppLocalizedString(@"通知中心")];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_detailDic) {
        [self.tableView pullToRefresh];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self cancelAllRequest];
}
#pragma mark -Set And Get Method

-(void)setTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_tableView]) {
        return;
    }
    [_tableView removeFromSuperview];
    [_tableView release];
    _tableView=[tableView retain];
    [self.view addSubview:_tableView];
    [_tableView setPullToRefreshHandler:^{
    
        [self requestOrderDetail];
    }];
}

-(void)setDetailDic:(NSDictionary *)detailDic{

    if ([detailDic isEqualToDictionary:_detailDic]) {
        return;
    }
    [_detailDic release];
    _detailDic=[detailDic retain];
    [self.tableView reloadData];
}

#pragma mark -Private

-(BOOL)checkIsHadRevoceerInfo{

    if (!_detailDic) {
        return NO;
    }
    if ([[_detailDic objectForKey:@"ReceiverAddress"] length]==0
        &&[[_detailDic objectForKey:@"ReceiverEmail"] length]==0
        &&[[_detailDic objectForKey:@"ReceiverName"] length]==0
        &&[[_detailDic objectForKey:@"ReceiverPhone"] length]==0
        &&[[_detailDic objectForKey:@"ReceiverPostalCode"] length]==0) {
        return NO;
    }else
        return YES;
}
#pragma mark -TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (_detailDic) {
        if ([self checkIsHadRevoceerInfo]) {
            return 3;
        }else
            return 2;
    }else
        return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (!_detailDic) {
        return 0;
    }else
    {
        switch (section) {
            case 0:
                return 4;
                break;
            case 1:
                return YES==[self checkIsHadRevoceerInfo]?5:2;
                break;
            case 2:
                return 2;
                break;
            default:
                return 0;
                break;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger allNumber=[self numberOfSectionsInTableView:tableView];
    if ((allNumber==2&&indexPath.section==1)||(allNumber==3&&indexPath.section==2)) {
    
        return [self otherInfoCellForIndexPath:indexPath];
    }
    
    static NSString *cellText=@"order";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellText];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellText] autorelease];
    }
    NSString *tempTitle=nil;
    NSString *tempDetail=nil;
    
    if (indexPath.section==0) {
        tempTitle=[self titleForOrderInfoWithIndexPath:indexPath];
        tempDetail=[self detailForOrderInfoWithIndexPath:indexPath];
    }else
    {
        tempTitle=[self titleForReceiverWithIndexPath:indexPath];
        tempDetail=[self detailForOrderInfoWithIndexPath:indexPath];
    }
    cell.textLabel.text=tempTitle;
    cell.detailTextLabel.text=tempDetail;
    cell.detailTextLabel.numberOfLines=0;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60.f;
}

-(NSString *)titleForOrderInfoWithIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
            return @"名称";
        case 1:
            return @"单价";
        case 2:
            return @"数量";
        case 3:
            return @"总价";
        default:
            return nil;
            break;
    }
}

-(NSString *)detailForOrderInfoWithIndexPath:(NSIndexPath *)indexPath{

    
    switch (indexPath.row) {
        case 0:
            return [_detailDic objectForKey:@"ProductTitle"];
        case 1:
        {
            float totalPrice=[[_detailDic objectForKey:@"TotalPrice"] floatValue];
            NSInteger number=[[_detailDic objectForKey:@"ProductCount"] integerValue];
            float unitPrice=totalPrice/number;
            return [NSString stringWithFormat:@"￥ %2.f",unitPrice];
        }
            break;
        case 2:
            return [NSString stringWithFormat:@"%@",[_detailDic objectForKey:@"ProductCount"]];
        case 3:
            return [NSString stringWithFormat:@"%@",[_detailDic objectForKey:@"TotalPrice"]];
        default:
            return nil;
            break;
    }
}

-(NSString *)titleForReceiverWithIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return @"收货人:";
        case 1:
            return @"地 址:";
        case 2:
            return @"电 话:";
        case 3:
            return @"邮 编:";
        case 4:
            return @"邮 箱:";
        default:
            return nil;
            break;
    }
}

-(NSString *)detailForReceiverWithIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:
            return [_detailDic objectForKey:@"ReceiverName"];
            break;
        case 1:
            return [_detailDic objectForKey:@"ReceiverAddress"];
        case 2:
            return [_detailDic objectForKey:@"ReceiverPhone"];
        case 3:
            return [_detailDic objectForKey:@"ReceiverPostalCode"];
        case 4:
            return [_detailDic objectForKey:@"ReceiverEmail"];
        default:
            return nil;
            break;
    }
}

-(UITableViewCell *)otherInfoCellForIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""] autorelease];
    UILabel *label=[[UILabel alloc]initWithFrame:cell.contentView.bounds];
    label.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=UITextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:17.f];
    switch (indexPath.row) {
        case 0:
        {
            if ([[_detailDic objectForKey:@"PayStatus"] integerValue]==1) {
                label.text=AppLocalizedString(@"已支付");
            }else
                label.text=AppLocalizedString(@"未支付");
        }
            break;
        case 1:
        {
            NSArray *proList=[_detailDic objectForKey:@"OrderProductList"];
            if (proList.count==0) {
                label.text=@"已使用";
            }else
            {
                NSDictionary *firstDic=[proList objectAtIndex:0];
                if ([[firstDic objectForKey:@"IsUsed"] integerValue]==1) {
                    label.text=@"已使用";
                }else
                    label.text=@"未使用";
            }
        }
            break;
        default:
            break;
    }
    [cell.contentView addSubview:label];
    [label release];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark -Request

-(void)cancelAllRequest
{
    [self cancelOrderDetailRequest];
}

-(void)cancelOrderDetailRequest
{
    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release];
        detailRequest=nil;
    }
}

-(void)requestOrderDetail{

    [self cancelOrderDetailRequest];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[SettingManager sharedSettingManager]loggedInAccount],@"AccountId",
                       [_simpleDic objectForKey:@"ObjectNo"],@"OrderCode", nil];
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在请求订单详情...")];
    detailRequest=[[UserLoadOrderDetail alloc]initWithRequestWithDic:dic];
    [detailRequest setDelegate:self];
    [detailRequest startAsynchronous];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data
{
    if (request==detailRequest) {
        [[ProgressHUD sharedProgressHUD]done:YES];
        [self.tableView refreshFinished];
        self.detailDic=data;
    }
}
@end
