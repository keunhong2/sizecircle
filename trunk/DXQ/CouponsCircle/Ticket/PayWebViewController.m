//
//  PayWebViewController.m
//  DXQ
//
//  Created by 黄修勇 on 13-2-19.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "PayWebViewController.h"

#define ALIPAY_PID              @"2088901121509141"
#define ALIPAY_SIGN             @"5g96ms37lw1kiuoh7dujndl3um2qh181"
#define ALIPAY_ACCOUNT          @"service@daxiaoquan.com"

@interface PayWebViewController ()<UIWebViewDelegate>{

    NSString *requestID;
}

@end

@implementation PayWebViewController

-(void)dealloc{

    [_webView release];
    [requestID release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        requestID=[[NSString stringWithFormat:@"%d",rand()] retain];
    }
    return self;
}

-(void)loadView{

    [super loadView];
    
    UIWebView *webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    webView.delegate=self;
    webView.scalesPageToFit=YES;
    self.webView=webView;
    [webView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:@"支付宝支付" backItemTitle:@"返回"];
}

- (void)didReceiveMemoryWarning
{
//    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setWebView:(UIWebView *)webView{

    if ([webView isEqual:_webView]) {
        return;
    }
    [_webView removeFromSuperview];
    [_webView release];
    _webView=[webView retain];
    [self.view addSubview:webView];
}


-(void)payProductName:(NSString *)name order:(NSString *)order money:(float)money
{
    NSString *url=[NSString stringWithFormat:@"http://wappaygw.alipay.com/service/rest.htm?req_data=<direct_trade_create_req><subject>%@</subject><out_trade_no>%@</out_trade_no><total_fee>%f</tot al_fee><seller_account_name>%@</seller_account_name><call_back_url>http://www.daxiaoquan.com</call_back_url></direct_trade_create_req>&service=alipay.wap.trade.create.direct&sec_id=0001&partner=%@&req_id=%@&sign=%@&format=xml&v=2.0",name,order,money,ALIPAY_ACCOUNT,ALIPAY_PID, requestID,ALIPAY_SIGN,nil];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
//    NSString *url=[NSString stringWithFormat:@"http://wappaygw.alipay.com/service/rest.htm?req_data=<auth_and_execute_re q><request_token>201008309e298cf01c58146274208eda1e4cdf2b</request_token> </auth_and_execute_req>&service=alipay.wap.auth.authAndExecute&sec_id=000 1&partner=2088101000137799&sign=LdXbwMLug8E4UjfJMuYv2KoD5X5F3vHGQsQbZ/rdE Q3eaN4FPal7rhsbZZ/+ZUL1kAKzTQSDdMk87MEWtWO1Yq6rhnt2Tv8Hh6Hb16211VXKgbBCpq 861+LopRwegPbGStcwBuAyE4pi6fYlJ6gxzL4tMyeLe+T5XZ0RKRUk00U=&format=xml&v=2 .0"]
}
@end
