//
//  WebViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-9.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
{
    UIActivityIndicatorView *activity;
}

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void)dealloc{

    [_webView release];
    [activity release];
    [super dealloc];
}

-(void)loadView{

    [super loadView];
    
    UIWebView *webView=[[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    webView.delegate=self;
    webView.scalesPageToFit=YES;
    self.webView=webView;
    [webView release];
    
    if (!activity) {
        activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activity setHidesWhenStopped:YES];
        [activity stopAnimating];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:activity];
    self.navigationItem.rightBarButtonItem=item;
    [item release];
    
    UIImage *btnImg=[UIImage imageNamed:@"btn_round"];
    UIFont *font=[UIFont boldSystemFontOfSize:14.f];
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
    [cancelBtn sizeToFit];
    [cancelBtn.titleLabel setFont:font];
    [cancelBtn setTitle:AppLocalizedString(@"返回") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnDone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem=cancelItem;
    [cancelItem release];
}

-(void)cancelBtnDone:(id)sender{

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setWebView:(UIWebView *)webView{

    if ([webView isEqual:_webView]) {
        return;
    }
    [_webView removeFromSuperview];
    [_webView release];
    _webView=[webView retain];
    [self.view addSubview:_webView];
}

#pragma mark -UIWebViewDelegate

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    [activity stopAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    [activity stopAnimating];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{

    [activity startAnimating];
}
@end
