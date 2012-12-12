//
//  CitySelectedViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "CitySelectedViewController.h"

@interface CitySelectedViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation CitySelectedViewController


-(void)dealloc{

    [_defaultCity release];
    [_pickerView release];
    [_cityArray release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.defaultCity=AppLocalizedString(@"广州");
        self.cityArray=[NSArray arrayWithObject:AppLocalizedString(@"广州")];
    }
    return self;
}

-(void)loadView{

    [super loadView];
    
    UIPickerView *pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 300.f)];
    pickerView.delegate=self;
    pickerView.dataSource=self;
    [self.view addSubview:pickerView];
    pickerView.showsSelectionIndicator=YES;
    self.pickerView=pickerView;
    [pickerView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavgationTitle:AppLocalizedString(@"城市选择") backItemTitle:AppLocalizedString(@"返回")];
    
    
    UIImage *btnImg=[UIImage imageNamed:@"btn_round"];
    UIFont *font=[UIFont boldSystemFontOfSize:14.f];
    
    UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
    [doneBtn sizeToFit];
    [doneBtn.titleLabel setFont:font];
    [doneBtn setTitle:AppLocalizedString(@"确定") forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnDone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItem=[[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem=doneItem;
    [doneItem release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneBtnDone:(UIButton *)btn{

    [[ProgressHUD sharedProgressHUD]showInView:[[[UIApplication sharedApplication]windows]objectAtIndex:0]];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"城市设置成功")];
    [[ProgressHUD sharedProgressHUD]done:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UIPickViewDataSource And Delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return _cityArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return [_cityArray objectAtIndex:row];
}

@end
