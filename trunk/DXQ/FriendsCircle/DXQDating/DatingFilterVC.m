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
    
    UILabel *sexTipLbl = [self createLabel:AppLocalizedString(@"您想看到的用户") frame:CGRectMake(15,10,280,20)];
    [self.view addSubview:sexTipLbl];
    [sexTipLbl release];
    
    NSString *loginDate=@"-1";
    NSString *maxAge=@"-1";
    NSString *minAge=@"-1";
    NSString *sex=@"-1";
    NSDictionary *configDic=[[SettingManager sharedSettingManager]getHiddenLoveSettingDic];
    if (configDic) {
        loginDate=[configDic objectForKey:@"LogInDate"];
        maxAge=[configDic objectForKey:@"MaxAge"];
        minAge=[configDic objectForKey:@"MinAge"];
        sex=[configDic objectForKey:@"Sex"];
    }
    
    NSInteger sexSelectIndex=[sex integerValue];
    sexSelectIndex++;
    //-1表示所有，0表示女，1表示男
    NSArray *sexSegmentedArray = [[NSArray alloc]initWithObjects:@"不限",@"女",@"男",nil];
    
    UISegmentedControl *sexSegmentedControl = [self createSegmentControl:CGRectMake(10.0,40.0, 300.0, 45.0) withItems:sexSegmentedArray defaultSelected:sexSelectIndex];
    sexSegmentedControl.tag = 1;
    [self.view addSubview:sexSegmentedControl];
    [sexSegmentedControl release];
    [sexSegmentedArray release];
    
    NSInteger loginDateSelectIndex=0;
    long lastLoginSecound=[loginDate longLongValue];
    switch (lastLoginSecound) {
        case 15*60:
            loginDateSelectIndex=1;
            break;
        case 60*60:
            loginDateSelectIndex=2;
            break;
        case 24*60*60:
            loginDateSelectIndex=3;
            break;
        case 3*24*60*60:
            loginDateSelectIndex=4;
            break;
        default:
            loginDateSelectIndex=0;
            break;
    }
    UILabel *appearTipLbl = [self createLabel:AppLocalizedString(@"出现的时间") frame:CGRectMake(15,105,280,20)];
    [self.view addSubview:appearTipLbl];
    [appearTipLbl release];
    
    NSArray *appearTimeSegmentedArray = [[NSArray alloc]initWithObjects:@"不限",@"15分钟",@"1小时",@"1天",@"3天",nil];
    
    UISegmentedControl *appearTimeSegmentedControl = [self createSegmentControl:CGRectMake(10.0,135.0,300.0, 45.0) withItems:appearTimeSegmentedArray defaultSelected:loginDateSelectIndex];
    appearTimeSegmentedControl.tag = 2;
    [self.view addSubview:appearTimeSegmentedControl];
    [appearTimeSegmentedControl release];
    [appearTimeSegmentedArray release];
    
    NSInteger ageSelectIndex=0;
    NSInteger minAgeInt=[minAge integerValue];
    switch (minAgeInt) {
        case -1:
            ageSelectIndex=0;
            break;
        case 18:
            ageSelectIndex=1;
            break;
        case 23:
            ageSelectIndex=2;
            break;
        case 26:
            ageSelectIndex=3;
            break;
        case 35:
            ageSelectIndex=4;
            break;
            
        default:
            ageSelectIndex=0;
            break;
    }
    UILabel *ageLabel = [self createLabel:AppLocalizedString(@"年龄") frame:CGRectMake(15,205,280,20)];
    [self.view addSubview:ageLabel];
    [ageLabel release];
    
    NSArray *ageArray = [[NSArray alloc]initWithObjects:@"不限",@"18-22",@"23-25",@"26-35",@"35+",nil];
    
    UISegmentedControl *ageSegment = [self createSegmentControl:CGRectMake(10.0,235.0,300.0, 45.0) withItems:ageArray defaultSelected:ageSelectIndex];
    ageSegment.tag = 3;
    [self.view addSubview:ageSegment];
    [ageSegment release];
    [ageArray release];

    

    UIImage *signupImage = [UIImage imageNamed:@"signup_btn"];
    CGRect certainBtnFrame = CGRectMake(CGRectGetMidX(rect)-signupImage.size.width/2,330.f, signupImage.size.width,signupImage.size.height);
    UIButton *certainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [certainBtn setBackgroundImage:signupImage forState:UIControlStateNormal];
    [certainBtn setTitle:AppLocalizedString(@"确定") forState:UIControlStateNormal];
    [certainBtn addTarget:self action:@selector(finishedAction:) forControlEvents:UIControlEventTouchUpInside];
    [certainBtn setFrame:certainBtnFrame];
    [self.view addSubview:certainBtn];
    
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
    UISegmentedControl * tempSegment=(UISegmentedControl *)[self.view viewWithTag:1];
    NSString *sexText=[NSString stringWithFormat:@"%d",tempSegment.selectedSegmentIndex-1];
    tempSegment=(UISegmentedControl *)[self.view viewWithTag:2];
    NSString *loginDateText=@"-1";
    switch (tempSegment.selectedSegmentIndex) {
        case 0:
            loginDateText=@"-1";
            break;
        case 1:
            loginDateText=@"900";
            break;
        case 2:
            loginDateText=@"3600";
            break;
        case 3:
            loginDateText=@"86400";
            break;
        case 4:
            loginDateText=@"259200";
            break;
        default:
            loginDateText=@"-1";
            break;
    }

    NSString *maxAge=@"-1";
    NSString *minAge=@"-1";
    tempSegment=(UISegmentedControl *)[self.view viewWithTag:3];
    switch (tempSegment.selectedSegmentIndex) {
        case 0:
            maxAge=@"-1";
            minAge=@"-1";
            break;
        case 1:
            maxAge=@"22";
            minAge=@"18";
            break;
        case 2:
            maxAge=@"25";
            minAge=@"23";
            break;
        case 3:
            maxAge=@"35";
            minAge=@"26";
            break;
        case 4:
            maxAge=@"-1";
            minAge=@"35";
            break;
        default:
            maxAge=@"-1";
            minAge=@"-1";
            break;
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:loginDateText,@"LogInDate",
                       maxAge,@"MaxAge",minAge,@"MinAge",sexText,@"Sex", nil];
    [[SettingManager sharedSettingManager]setHiddenLoveSettingDic:dic];
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

-(UISegmentedControl *)createSegmentControl:(CGRect)rect_ withItems:(NSArray *)items_ defaultSelected:(NSUInteger)selectedIndex
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:items_];
    segmentedControl.frame = rect_;
    segmentedControl.selectedSegmentIndex = selectedIndex;
    segmentedControl.tintColor = [UIColor clearColor];
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    segmentedControl.momentary = NO;//设置在点击后是否恢复原样
//    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    return segmentedControl;
}

- (void)didReceiveMemoryWarning
{
//    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UILabel *)createLabel:(NSString *)title frame:(CGRect)rect
{
    UILabel *lbl = [[UILabel alloc]initWithFrame:rect];
    [lbl setText:title];
    [lbl setTextAlignment:UITextAlignmentLeft];
    [lbl setTextColor:[UIColor darkGrayColor]];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setFont:NormalDefaultFont];
    
    return lbl;
}

@end
