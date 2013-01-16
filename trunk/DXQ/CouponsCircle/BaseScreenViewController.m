//
//  BaseScreenViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-22.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseScreenViewController.h"

@interface BaseScreenViewController ()

@end

@implementation BaseScreenViewController

-(void)dealloc{

    [_tableView release];
    _screenDelegate=nil;
    [_screenInfo release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=AppLocalizedString(@"筛选");
    }
    return self;
}

-(void)loadView{

    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
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
    
    UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
    [doneBtn sizeToFit];
    [doneBtn.titleLabel setFont:font];
    [doneBtn setTitle:AppLocalizedString(@"确定") forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnDone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItem=[[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem=doneItem;
    [doneItem release];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
//    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)cancelBtnDone:(UIButton *)btn{

    if (_screenDelegate&&[_screenDelegate respondsToSelector:@selector(didCancelScrennViewController:)]) {
        [_screenDelegate didCancelScrennViewController:self];
    }
}

-(void)doneBtnDone:(UIButton *)btn{

    if (_screenDelegate&&[_screenDelegate respondsToSelector:@selector(screenViewController:didDoneScreenWithInfo:)]) {
        [_screenDelegate screenViewController:self didDoneScreenWithInfo:[self screenInfo]];
    }
}

#pragma mark -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 49.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view=[[UIView alloc]initWithFrame:CGRectZero];
    view.backgroundColor=[UIColor clearColor];
    return [view autorelease];
}
@end
