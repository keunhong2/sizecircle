//
//  AboutViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-9.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

-(id)init{

    return [self initWithNibName:@"AboutViewController" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title=AppLocalizedString(@"关于");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)didReceiveMemoryWarning
{
//    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goSite:(id)sender {

    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:HomeWebSite]];
}

- (IBAction)goCall:(id)sender {
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ServiceTel]];
}

- (void)dealloc {
    [_bgImageView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBgImageView:nil];
    [super viewDidUnload];
}
@end
