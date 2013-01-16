//
//  InPutPageVC.m
//  DXQ
//
//  Created by Yuan on 12-11-20.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "InPutPageVC.h"

@interface InPutPageVC ()
{
    NSString *titleString;
    NSString *contentString;
}
@end

@implementation InPutPageVC

- (id)initWithTitle:(NSString *)title content:(NSString *)content_ delegate:(id)delegate_
{
    self = [super init];
    if (self)
    {
        CHARACTER_MAXNUMBERS = 100;
        
        titleString = title;
        
        contentString = content_;
        
        self.vDelegate = delegate_;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.countLbl setText:[NSString stringWithFormat:@"0/%d",CHARACTER_MAXNUMBERS]];

    [self.txtView setText:contentString];

    self.navigationItem.title = titleString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:AppLocalizedString(@"确定") forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:MiddleBoldDefaultFont];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    [rightItem release];
    
	// Do any additional setup after loading the view.
}

-(void)doneAction:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];

    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(didFinishedAction:witfhInfo:)])
    {
        [self.vDelegate didFinishedAction:self witfhInfo:self.txtView.text];
    }
}

- (void)didReceiveMemoryWarning
{
    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
