//
//  OrderDetailViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-3.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "ProductDetailRequest.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "HotEventDetailViewController.h"
#import "MemberDetailViewController.h"

@interface OrderDetailViewController ()<BusessRequestDelegate>{

     ProductDetailRequest *detailRequest;
}

@end

@implementation OrderDetailViewController

-(void)dealloc{

    [self cancelAllRequest];
    [_tableView release];
    [_orderDic release];
    [_productDic release];
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

    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView=tableView;
    [tableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"订单详情") backItemTitle:AppLocalizedString(@"返回")];
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self cancelAllRequest];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    if (!_productDic) {
        [self.tableView pullToRefresh];
    }
}


#pragma mark -Request

-(void)cancelAllRequest{

    [self cancelDetail];
}

-(void)cancelDetail{

    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release];
        detailRequest=nil;
    }
}
-(void)requestProductDetail{
    
    [self cancelDetail];
    
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    
    NSString *idText=[_orderDic objectForKey:@"ProductCode"];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:idText,@"ProductCode",[[SettingManager sharedSettingManager]loggedInAccount],@"AccountId", nil];
    detailRequest=[[ProductDetailRequest alloc]initWithRequestWithDic:dic];
    detailRequest.delegate=self;
    [detailRequest startAsynchronous];
}

#pragma mark -

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [self.tableView refreshFinished];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    [self.tableView refreshFinished];
    [[ProgressHUD sharedProgressHUD]done:YES];
    self.productDic=data;
    [self.tableView reloadData];
}

#pragma mark -Set Method

-(void)setTableView:(UITableView *)tableView{

    if ([tableView isEqual:_tableView]) {
        return;
    }
    [_tableView removeFromSuperview];
    [_tableView release];
    _tableView=[tableView retain];
    [self.view addSubview:_tableView];
    [_tableView setPullToRefreshHandler:^{
        [self requestProductDetail];
    }];
}

-(void)setOrderDic:(NSDictionary *)orderDic{

    if ([orderDic isEqualToDictionary:_orderDic]) {
        return;
    }
    [_orderDic release];
    _orderDic=[orderDic retain];
    [self.tableView reloadData];
}

#pragma mark -UITableViewDataSource And Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 55.f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (!_productDic) {
        return 0;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return 6;
            break;
        case 1:
            return 3;
            break;
        default:
            return 0;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"S"] autorelease];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text=AppLocalizedString(@"名称");
                    cell.detailTextLabel.text=[_orderDic objectForKey:@"Name"];
                }
                    break;
                case 1:
                {
                    cell.textLabel.text=AppLocalizedString(@"单价");
                    float prise=[[_productDic objectForKey:@"MarketPrice"] floatValue]*[[_productDic objectForKey:@"Discount"] floatValue];
                    cell.detailTextLabel.text=[NSString stringWithFormat:@"￥%.2f",prise];
                }
                    break;
                case 2:
                {
                    cell.textLabel.text=AppLocalizedString(@"数量");
                    cell.detailTextLabel.text=@"1";
                }
                    break;
                case 3:
                {
                    cell.textLabel.text=AppLocalizedString(@"有效期");
                    NSString *start=[Tool convertTimestampToNSDate:[[_productDic objectForKey:@"ExpiredBeginDate"] integerValue]];
                    NSString *end=[Tool convertTimestampToNSDate:[[_productDic objectForKey:@"ExpiredDate"] integerValue]];
                    cell.detailTextLabel.text=[NSString stringWithFormat:@" %@\n-%@",start,end];
                }
                    break;
                case 4:
                {
                    cell.textLabel.text=AppLocalizedString(@"商家地址");
                    cell.detailTextLabel.text=[_productDic objectForKey:@"CompanyAddress"];
                }
                    break;
                case 5:
                {
                    cell.textLabel.text=AppLocalizedString(@"联系电话");
                    cell.detailTextLabel.text=[_productDic objectForKey:@"CompanyTelephone"];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            UILabel *label=[[UILabel alloc]initWithFrame:cell.bounds];
            label.backgroundColor=[UIColor clearColor];
            label.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            label.textColor=[UIColor blackColor];
            label.textAlignment=UITextAlignmentCenter;
            label.font=[UIFont boldSystemFontOfSize:18.f];
            switch (indexPath.row) {
                case 0:
                {
                    if ([[_orderDic objectForKey:@"IsPayed"] integerValue]==1) {
                        label.text=AppLocalizedString(@"已完成付款");
                    }else
                        label.text=AppLocalizedString(@"未支付,点击继续支付");
                }
                    break;
                case 1:
                {
                    if ([[_orderDic objectForKey:@"IsUsed"] integerValue]==1) {
                        label.text=AppLocalizedString(@"已使用");
                    }else
                        label.text=AppLocalizedString(@"未使用");
                }
                    break;
                case 2:
                {
                    label.text=AppLocalizedString(@"查看商品详情");
                }
                    break;
                default:
                    break;
            }
            [cell.contentView addSubview:label];
            [label release];
        }
        default:
            break;
    }
    cell.detailTextLabel.numberOfLines=2;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1&&indexPath.row==2) {
        //go to detail
        
        NSString *productType=[_orderDic objectForKey:@"ProductType"];
        if ([productType isEqualToString:@"A"]) {
            HotEventDetailViewController *detail=[[HotEventDetailViewController alloc]init];
            [self.navigationController pushViewController:detail animated:YES];
            detail.simpleDic=_orderDic;
            [detail release];
        }else
        {
            NSString *controllClass=nil;
            if ([productType isEqualToString:@"Y"]) {
                controllClass=@"TicketDetailViewController";
            }else if ([productType isEqualToString:@"H"]){
                controllClass=@"MemberDetailViewController";
            }else if ([productType isEqualToString:@"T"]){
                controllClass=@"TuanDetailViewController";
            }
            MemberDetailViewController *detail=[[NSClassFromString(controllClass) alloc]init];
            detail.simpleInfoDic=_orderDic;
            [self.navigationController pushViewController:detail animated:YES];
            [detail release];
        }
    }
}

@end
