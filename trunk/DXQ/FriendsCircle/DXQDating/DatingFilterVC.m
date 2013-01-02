//
//  DatingFilterVC.m
//  DXQ
//
//  Created by Yuan on 12-11-9.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DatingFilterVC.h"

@interface DatingFilterVC ()

@end

@implementation DatingFilterVC

- (id)initWithDelegate:(id)delegate_
{
    self = [super init];
    if (self)
    {
        self.vDelegate = delegate_;
    }
    return self;
}

-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
}

- (void)viewDidLoad
{
    self.navigationItem.title = AppLocalizedString(@"筛选");
    
    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:AppLocalizedString(@"取消") forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:MiddleBoldDefaultFont];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.leftBarButtonItem=rightItem;
    [rightItem release];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)finishedAction:(UIButton*)btn
{
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(didFinishedAction:)])
    {
        [self.vDelegate didFinishedAction:self];
    }
}

-(void)cancelBtn:(UIButton*)btn
{
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(didCancelViewViewController)])
    {
        [self.vDelegate didCancelViewViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
