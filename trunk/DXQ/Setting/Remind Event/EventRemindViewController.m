//
//  EventRemindViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "EventRemindViewController.h"
#import "UserSetAlertDay.h"

@interface EventRemindViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,BusessRequestDelegate>{

    UserSetAlertDay *alertRequest;
    NSArray *remindDataSource;
}

@end

@implementation EventRemindViewController

-(void)dealloc{

    [_pickerView release];
    [alertRequest cancel];
    [alertRequest release];
    [remindDataSource release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.selectDay=5;
        self.maxDays=3;
        remindDataSource=[[NSArray alloc]initWithObjects:
                          @"          当天",
                          @"          提前一天",
                          @"          提前两天", nil];
    }
    return self;
}

-(void)loadView{
    
    [super loadView];
    
    UIPickerView *pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 300.f)];
    pickerView.delegate=self;
    pickerView.dataSource=self;
    pickerView.showsSelectionIndicator=YES;
    self.pickerView=pickerView;
    [pickerView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"活动时间提醒") backItemTitle:AppLocalizedString(@"返回")];
    
    UIImage *btnImg=[UIImage imageNamed:@"btn_round"];
    UIFont *font=[UIFont boldSystemFontOfSize:14.f];
    
    UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
    [doneBtn sizeToFit];
    [doneBtn.titleLabel setFont:font];
    [doneBtn setTitle:AppLocalizedString(@"保存") forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnDone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItem=[[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem=doneItem;
    [doneItem release];
}

- (void)didReceiveMemoryWarning
{
//    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneBtnDone:(id)sender{

    if (alertRequest) {
        [alertRequest cancel];
        [alertRequest release];
        alertRequest=nil;
    }
    NSString *accoundID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSString *dayText=[NSString stringWithFormat:@"%d",[self.pickerView selectedRowInComponent:0]];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accoundID,@"AccountId",dayText,@"AlertDay", nil];
    [[ProgressHUD sharedProgressHUD]showInView:[[[UIApplication sharedApplication]windows]objectAtIndex:0]];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在保存设置")];
    alertRequest=[[UserSetAlertDay alloc]initWithRequestWithDic:dic];
    alertRequest.delegate=self;
    [alertRequest startAsynchronous];
}

#pragma mark -

-(void)setPickerView:(UIPickerView *)pickerView{

    if([pickerView isEqual:_pickerView]){
        
        return;
    }
    [_pickerView removeFromSuperview];
    [_pickerView release];
    _pickerView=[pickerView retain];
    [self.view addSubview:_pickerView];
    [_pickerView selectRow:_selectDay-1 inComponent:0 animated:YES];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"设置成功")];
    [[ProgressHUD sharedProgressHUD]done:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return remindDataSource.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return [remindDataSource objectAtIndex:row];
}

@end
