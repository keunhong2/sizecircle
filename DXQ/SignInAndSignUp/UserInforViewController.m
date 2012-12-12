//
//  UserInforViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UserInforViewController.h"
#import "UITextField+InputTextFiled.h"
#import "UIColor+ColorUtils.h"
#import "RegisterPhotoViewController.h"
#import "SignUpRequest.h"
#import "AppDelegate.h"
#import "UserRegisterVC.h"

@interface UserInforViewController ()<SignUpRequestDelegate>
{
    UITextField *maleTextField;
    SignUpRequest *signUpRequest;
}
@end

@implementation UserInforViewController

@synthesize trueNameTextField=_trueNameTextField;
@synthesize male=_male;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView{
    
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    //注册信息 输入框
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.0f, self.view.frame.size.width, 165.f) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.backgroundView=nil;
    tableView.scrollEnabled=NO;
    [self.view addSubview:tableView];
    [tableView release];
    
    //下一步
    
    UIImage *nextImg = [UIImage imageNamed:@"signup_btn"];
    CGRect nextBtnRect = CGRectMake(CGRectGetMidX(rect)-nextImg.size.width/2,160.f, nextImg.size.width,nextImg.size.height);
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:nextImg forState:UIControlStateNormal];
    [nextBtn setTitle:AppLocalizedString(@"下一步") forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setFrame:nextBtnRect];
    [self.view addSubview:nextBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"注册") backItemTitle:AppLocalizedString(@"注册")];
	// Do any additional setup after loading the view.
}

-(void)dealloc{

    if (signUpRequest) {
        [signUpRequest cancel];
        [signUpRequest release];
        signUpRequest=nil;
    }
    [_trueNameTextField release];
    [_accountAndPsdInfoDic release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Action

-(void)goNext{

    NSString *name=_trueNameTextField.text;
    if (name.length==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"真实姓名不能为空")];
        return;
    }
    
    [_trueNameTextField resignFirstResponder];
    [maleTextField resignFirstResponder];
    
    //do action go next
    [_accountAndPsdInfoDic setObject:_trueNameTextField.text forKey:@"MemberName"];
    NSString * male=[maleTextField.text isEqualToString:@"男"]?@"1":@"0";
    [_accountAndPsdInfoDic setObject:male forKey:@"Sex"];
    if (signUpRequest) {
        [signUpRequest cancel];
        [signUpRequest release];
        signUpRequest=nil;
    }
    [[ProgressHUD sharedProgressHUD] setText:AppLocalizedString(@"正在处理...")];
    [[ProgressHUD sharedProgressHUD] showInView:[[UIApplication sharedApplication].windows lastObject]];
    
    signUpRequest=[[SignUpRequest alloc]initRequestWithDic:_accountAndPsdInfoDic];
    signUpRequest.delegate=self;
    [signUpRequest startAsynchronous];
}


-(void)goNextFialed{

}

-(void)goNextSuccess{

    RegisterPhotoViewController *photo=[[RegisterPhotoViewController alloc]init];
    [self.navigationController pushViewController:photo animated:YES];
    [photo release];
}

#pragma mark -UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==0) {
        return 30.f;
    }else
        return 0.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"s"] autorelease];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
        cell.textLabel.text=AppLocalizedString(@"真实姓名");
        if (!_trueNameTextField) {
            _trueNameTextField=[UITextField creatTextFiledWithFrame:CGRectMake(90.f, 44.f/2-31.f/2+5.f, 200.f, 31.f)];
            _trueNameTextField.delegate=self;
        }
        [cell.contentView addSubview:_trueNameTextField];
    }else
    {
        cell.textLabel.text=AppLocalizedString(@"性别");
        if (!maleTextField) {
            maleTextField=[UITextField creatTextFiledWithFrame:CGRectMake(60.f, 44./2-31.f/2+5.f, 70.f, 31.f)];
            maleTextField.clearButtonMode=UITextFieldViewModeNever;
            maleTextField.text=AppLocalizedString(@"男");
            GenderSelectView *gender=[[GenderSelectView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 260.f)];
            gender.delegate=self;
            maleTextField.inputView=gender;
            [gender release];
        }
    [cell.contentView addSubview:maleTextField];
    }
    cell.textLabel.textColor=[UIColor colorWithString:@"#C3C3C3"];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0) {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, tableView.frame.size.width, 30.f)];
        view.backgroundColor=[UIColor clearColor];
        UILabel *label=[[UILabel alloc]initWithFrame:view.bounds];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=UITextAlignmentCenter;
        label.textColor=[UIColor colorWithString:@"#868178"];
        label.shadowColor=[UIColor colorWithString:@"#FFFFFF"];
        label.text=@"使用真实名字让人更快的找到你和联系人";
        label.font=[UIFont systemFontOfSize:15.f];
        label.shadowOffset=CGSizeMake(0.f, 2.f);
        [view addSubview:label];
        [label release];
        return [view autorelease];
    }else
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITextField *textFiled=nil;
    if (indexPath.section==0) {
        textFiled=_trueNameTextField;
    }else
    {
        textFiled=maleTextField;
    }
    
    if (textFiled.isFirstResponder==YES) {
        [textFiled resignFirstResponder];
    }else
        [textFiled becomeFirstResponder];
}

#pragma mark -SigupRequestDelegate
- (void)signUpRequestDidFinishedWithParamters:(NSDictionary *)dict
{
    signUpRequest.delegate = nil,
    [signUpRequest release];
    signUpRequest=nil;
    
    HYLog(@"%@",dict);//对注册返回信息进行处理
    
    //保存登陆账号
    [[SettingManager sharedSettingManager]setLoggedInAccount:[dict objectForKey:@"AccountId"]];
    [[ProgressHUD sharedProgressHUD] setText:AppLocalizedString(@"注册成功!")];
    [[ProgressHUD sharedProgressHUD]done];
    
    //保存用户信息到数据库
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        [[AppDelegate sharedAppDelegate] saveAccountInfoToCoreData:dict withPassword:[_accountAndPsdInfoDic objectForKey:@"Password"] dismissViewController:NO];
    }
    
    RegisterPhotoViewController *controller=[[RegisterPhotoViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)signUpRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    signUpRequest.delegate = nil,
    [signUpRequest release];
    signUpRequest=nil;
    [[ProgressHUD sharedProgressHUD] setText:errorMsg];
    [[ProgressHUD sharedProgressHUD]done:NO];
}

#pragma mark -GenderSelectViewDelegate

-(void)genderSelectViewDidCancel:(GenderSelectView *)genderSelectView{

    [maleTextField resignFirstResponder];
}

-(void)genderSelectViewDidDone:(GenderSelectView *)genderSelectView{

    [maleTextField resignFirstResponder];
}

-(void)genderSelectView:(GenderSelectView *)genderSelectView genderChanageMale:(BOOL)isMale{

    maleTextField.text=isMale==YES?@"男":@"女";
}
@end
