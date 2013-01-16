//
//  VerifyOrderViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-28.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "VerifyOrderViewController.h"

@interface VerifyOrderViewController (){

    UIButton *payBtn;
}

@end

@implementation VerifyOrderViewController

-(void)dealloc{

    [_tableView release];
    [_orderInfoDic release];
    [_productInfoDic release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    tableView.backgroundView=nil;
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    
    UIImage *btnImg=[UIImage imageNamed:@"btn_red"];
    
    UIButton *buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtn) forControlEvents:UIControlEventTouchUpInside];
    [buyBtn sizeToFit];
    [buyBtn setTitle:AppLocalizedString(@"付款") forState:UIControlStateNormal];
    [buyBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20.f]];
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0.f, self.view.frame.size.height-btnImg.size.height-10.f, self.view.frame.size.width, btnImg.size.height+10.f)];
    footView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    footView.backgroundColor=[UIColor clearColor];
    buyBtn.center=CGPointMake(footView.frame.size.width/2, footView.frame.size.height/2);
    footView.tag=20;
    [footView addSubview:buyBtn];
    [self.tableView setTableFooterView:footView];
    [footView release];
    payBtn=buyBtn;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"确认订单") backItemTitle:AppLocalizedString(@"返回")];
}

- (void)didReceiveMemoryWarning
{
    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buyBtn{

//    [[UIApplication sharedApplication]openURL:<#(NSURL *)#>]
}
#pragma mark -UITableViewDataSource And Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (_needAddress) {
        return 3;
    }else
        return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            if (_needAddress) {
                return 3;
            }else
                return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return AppLocalizedString(@"商品信息");
            break;
        case 1:
        {
            if (_needAddress) {
                return AppLocalizedString(@"收货信息");
            }else
                return AppLocalizedString(@"支付方式");
        }
            break;
        case 2:
        {
            return AppLocalizedString(@"支付方式");
        }
        default:
            return nil;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *vertyString=@"ver";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:vertyString];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:vertyString] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }

    cell.accessoryType=UITableViewCellAccessoryNone;
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text=[NSString stringWithFormat:AppLocalizedString(@"名称:  %@"),[_productInfoDic objectForKey:@"ProductTitle"]];
                    break;
                case 1:
                    cell.textLabel.text=[NSString stringWithFormat:AppLocalizedString(@"数量:  %@"),[_orderInfoDic objectForKey:@"ProductCount"]];
                    break;
                case 2:
                {
//                    float price=[[_productInfoDic objectForKey:@"MarketPrice"]floatValue]*[[_productInfoDic objectForKey:@"Discount"] floatValue]/10.f;
                    cell.textLabel.text=[NSString stringWithFormat:@"单价:  %@",[_productInfoDic objectForKey:@"MemberPrice"]];
                }
                    break;
                case 3:
                {
                    float price=[[_productInfoDic objectForKey:@"MemberPrice"]floatValue]*[[_orderInfoDic objectForKey:@"ProductCount"] integerValue];
                    cell.textLabel.text=[NSString stringWithFormat:AppLocalizedString(@"总价:  %.2f"),price];
                    [payBtn setTitle:[NSString stringWithFormat:@"付款 ￥:%.2f",price] forState:UIControlStateNormal];
                }
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            if (_needAddress) {
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text=[NSString stringWithFormat:AppLocalizedString(@"收货地址:  %@"),[_orderInfoDic objectForKey:@"ReceiverAddress"]];
                        break;
                    case 1:
                        cell.textLabel.text=[NSString stringWithFormat:AppLocalizedString(@"收货人:  %@"),[_orderInfoDic objectForKey:@"ReceiverName"]];
                        break;
                    case 2:
                        cell.textLabel.text=[NSString stringWithFormat:AppLocalizedString(@"联系电话:  %@"),[_orderInfoDic objectForKey:@"ReceiverPhone"]];
                        break;
                    default:
                        break;
                }
                break;
            }
        }
        case 2:
        {
            cell.textLabel.text=AppLocalizedString(@"支付宝快捷支付");
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
            break;
        default:
            break;
    }
    return cell;
}
@end
