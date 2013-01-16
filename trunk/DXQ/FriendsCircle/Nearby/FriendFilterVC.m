//
//  FriendFilterVC.m
//  DXQ
//
//  Created by Yuan on 12-10-19.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "FriendFilterVC.h"

@interface FriendFilterVC ()


@end

@implementation FriendFilterVC


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
    
    NSDictionary *config = [[SettingManager sharedSettingManager]getNearByFriendsListFilterConfig];
    NSNumber *sexkeyConfig = [NSNumber numberWithInt:0];
    NSNumber *appearkeyTimeConfig = [NSNumber numberWithInt:0];
    if (config && [config isKindOfClass:[NSDictionary class]])
    {
        if ([config objectForKey:@"sexkey"])sexkeyConfig = [config objectForKey:@"sexkey"];
        if ([config objectForKey:@"timekey"])appearkeyTimeConfig = [config objectForKey:@"timekey"];
    }
    //-1表示所有，0表示女，1表示男
    NSArray *sexSegmentedArray = [[NSArray alloc]initWithObjects:@"不限",@"男",@"女",nil];
    
    UISegmentedControl *sexSegmentedControl = [self createSegmentControl:CGRectMake(10.0,40.0, 300.0, 45.0) withItems:sexSegmentedArray defaultSelected:[sexkeyConfig intValue]];
    sexSegmentedControl.tag = 1;
    [self.view addSubview:sexSegmentedControl];
    [sexSegmentedControl release];
    [sexSegmentedArray release];
    
    UILabel *appearTipLbl = [self createLabel:AppLocalizedString(@"出现的时间") frame:CGRectMake(15,105,280,20)];
    [self.view addSubview:appearTipLbl];
    [appearTipLbl release];
    
    NSArray *appearTimeSegmentedArray = [[NSArray alloc]initWithObjects:@"不限",@"15分钟",@"1小时",@"1天",@"3天",nil];

    UISegmentedControl *appearTimeSegmentedControl = [self createSegmentControl:CGRectMake(10.0,135.0,300.0, 45.0) withItems:appearTimeSegmentedArray defaultSelected:[appearkeyTimeConfig intValue]];
    appearTimeSegmentedControl.tag = 2;
    [self.view addSubview:appearTimeSegmentedControl];
    [appearTimeSegmentedControl release];
    [appearTimeSegmentedArray release];
    
    UIImage *signupImage = [UIImage imageNamed:@"signup_btn"];
    CGRect certainBtnFrame = CGRectMake(CGRectGetMidX(rect)-signupImage.size.width/2,240.f, signupImage.size.width,signupImage.size.height);
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

-(UISegmentedControl *)createSegmentControl:(CGRect)rect_ withItems:(NSArray *)items_ defaultSelected:(NSUInteger)selectedIndex
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:items_];
    segmentedControl.frame = rect_;
    segmentedControl.selectedSegmentIndex = selectedIndex;
    segmentedControl.tintColor = [UIColor clearColor];
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    segmentedControl.momentary = NO;//设置在点击后是否恢复原样
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
    return segmentedControl;
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

-(void)segmentAction:(UISegmentedControl *)seg
{
    NSInteger Index = seg.selectedSegmentIndex;
    NSDictionary *config = [[SettingManager sharedSettingManager]getNearByFriendsListFilterConfig];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:config];
    if (seg.tag == 1)
    {
        [dict setObject:[NSNumber numberWithInt:Index] forKey:@"sexkey"];
        switch (Index)
        {
            case 0:
                [dict setObject:[NSNumber numberWithInt:-1] forKey:@"sex"];
                break;
            case 1:
                [dict setObject:[NSNumber numberWithInt:1] forKey:@"sex"];
                break;
            case 2:
                [dict setObject:[NSNumber numberWithInt:0] forKey:@"sex"];
                break;
            default:
                break;
        }
    }
    else if(seg.tag == 2)
    {
        [dict setObject:[NSNumber numberWithInt:Index] forKey:@"timekey"];
        switch (Index-1)
        {
            case -1:
                [dict setObject:[NSNumber numberWithInt:-1] forKey:@"time"];
                break;
            case 0:
                [dict setObject:[NSNumber numberWithInt:900] forKey:@"time"];
                break;
            case 1:
                [dict setObject:[NSNumber numberWithInt:3600] forKey:@"time"];
                break;
            case 2:
                [dict setObject:[NSNumber numberWithInt:86400] forKey:@"time"];
                break;
            case 3:
                [dict setObject:[NSNumber numberWithInt:259200] forKey:@"time"];
                break;
            case 4:
                [dict setObject:[NSNumber numberWithInt:-1] forKey:@"time"];
                break;
            default:
                break;
        }
    }
    [[SettingManager sharedSettingManager]setNearByFriendsListFilterConfig:dict];
    [dict release];
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
//    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
