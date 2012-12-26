//
//  UserRegisterVC.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UserRegisterVC.h"
#import "UITextField+InputTextFiled.h"
#import "UIColor+ColorUtils.h"
#import "RegisterPhotoViewController.h"
#import "UserInforViewController.h"
#import "CustomUIView.h"
#import "Tool.h"
#import "ProgressHUD.h"
#import "Definitions.h"
#import "NSString+MD5Addition.h"
#import "GPS.h"
#import "DXQWebSocket.h"
#import "CheckAccountExisted.h"
#import "GetPhoneCheckCodeRequest.h"

@interface UserRegisterVC ()<BusessRequestDelegate>{

    SignUpRequest *signUpRequest;
    UITextField *maleTextField;
    UITableView *inputTableView;
    CheckAccountExisted *checkAccount;
    GetPhoneCheckCodeRequest *phoneRequest;
}


-(UITextField *)inputTextFieldWithFrame:(CGRect)frame;

@end

@implementation UserRegisterVC

@synthesize accountTextField=_accountTextField;
@synthesize pswTextFiled=_pswTextFiled;
@synthesize rePswTextFiled=_rePswTextFiled;


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
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.0f, self.view.frame.size.width, 300.f) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.backgroundView=nil;
    tableView.scrollEnabled=NO;
    [self.view addSubview:tableView];
    inputTableView=tableView;
    [tableView release];

    //下一步
    
    UIImage *nextImg = [UIImage imageNamed:@"signup_btn"];
    CGRect nextBtnRect = CGRectMake(CGRectGetMidX(rect)-nextImg.size.width/2,90.f, nextImg.size.width,nextImg.size.height);
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

    [self setNavgationTitle:AppLocalizedString(@"验证手机") backItemTitle:AppLocalizedString(@"登陆")];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void)dealloc{

    [signUpRequest cancel];
    [signUpRequest release];
    [_accountTextField release];
    [_pswTextFiled release];
    [_rePswTextFiled release];
    [_maleAndNameDic release];
    [checkAccount cancel];
    [checkAccount release];checkAccount=nil;
    [phoneRequest cancel];
    [phoneRequest release];
    phoneRequest=nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- Private

-(UITextField *)inputTextFieldWithFrame:(CGRect)frame{
    
    UITextField *textFiled=[UITextField creatTextFiledWithFrame:frame];
    textFiled.delegate=self;
    return textFiled;
}

#pragma mark -Action

-(void)goNext{

    NSString *acctoun=_accountTextField.text;
    NSString *psw=_pswTextFiled.text;
    NSString *rePsw=_rePswTextFiled.text;
    
    if (acctoun.length==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"手机不能为空")];
        [_accountTextField becomeFirstResponder];
        return;
    }
    
    [_accountTextField resignFirstResponder];
    [self requestPhoneCheckCodeByPhoneNumber:_accountTextField.text];
    return;
//    NSString *name=_trueNameTextField.text;
//    if (name.length==0) {
//        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"真实姓名不能为空")];
//        [_trueNameTextField becomeFirstResponder];
//        return;
//    }
//    
    if (psw.length==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"密码不能为空")];
        [_pswTextFiled becomeFirstResponder];
        return;
    }
    if (psw.length<6) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"密码不能少于六位")];
        [_pswTextFiled becomeFirstResponder];
        return;
    }
    
    if (rePsw.length==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"重复密码不能为空")];
        [_rePswTextFiled becomeFirstResponder];
        return;
    }
    
    if (![psw isEqualToString:rePsw]) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"两次输入的密码不一致")];
        [_pswTextFiled becomeFirstResponder];
        return;
    }
    
    [_accountTextField resignFirstResponder];
    [_pswTextFiled resignFirstResponder];
    [_rePswTextFiled resignFirstResponder];
//    [_trueNameTextField resignFirstResponder];
    //do register action
    
//    NSString * male=[maleTextField.text isEqualToString:@"男"]?@"1":@"0";
  
    
    if (checkAccount) {
        [checkAccount cancel];
        [checkAccount release];
        checkAccount=nil;
    }
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:acctoun,@"AccountId", nil];
    checkAccount=[[CheckAccountExisted alloc]initWithRequestWithDic:dic];
    checkAccount.delegate=self;
    [[ProgressHUD sharedProgressHUD] setText:AppLocalizedString(@"正在检测帐号...")];
    [[ProgressHUD sharedProgressHUD] showInView:[[UIApplication sharedApplication].windows lastObject]];
    checkAccount.delegate=self;
    [checkAccount startAsynchronous];
    /*
    if (_maleAndNameDic) {
        [dic addEntriesFromDictionary:_maleAndNameDic];
        [[ProgressHUD sharedProgressHUD] setText:AppLocalizedString(@"正在处理...")];
        [[ProgressHUD sharedProgressHUD] showInView:[[UIApplication sharedApplication].windows lastObject]];
        if (signUpRequest) {
            [signUpRequest cancel];
            [signUpRequest release];
            signUpRequest=nil;
        }
        signUpRequest=[[SignUpRequest alloc]initRequestWithDic:dic];
        signUpRequest.delegate=self;
        [signUpRequest startAsynchronous];
        return;
    }
    UserInforViewController *userInfo=[[UserInforViewController alloc]init];
    userInfo.accountAndPsdInfoDic=dic;
    [self.navigationController pushViewController:userInfo animated:YES];
    [userInfo release];*/
}


-(void)requestPhoneCheckCodeByPhoneNumber:(NSString *)phone
{
    if (phoneRequest) {
        [phoneRequest cancel];
        [phoneRequest release];
        phoneRequest=nil;
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:phone,@"Phone", nil];
    phoneRequest=[[GetPhoneCheckCodeRequest alloc]initWithRequestWithDic:dic];
    phoneRequest.delegate=self;
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在获取验证码...")];
    [phoneRequest startAsynchronous];
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
        [[AppDelegate sharedAppDelegate] saveAccountInfoToCoreData:dict withPassword:[Tool ConMD5:_pswTextFiled.text] dismissViewController:NO];
    }
    
    //通知刷新菜单左边的control
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONCENTER_MENU_LEFTCONTROL_REFRESH object:nil userInfo:nil];
    
    [[SettingManager sharedSettingManager]setTempAccountID:[dict objectForKey:@"AccountId"]];
    [[SettingManager sharedSettingManager]setTempAccountPassword:_pswTextFiled.text];
   
    //断开socket重新连接
    [[DXQWebSocket sharedWebSocket]closeWebSocket];
    [[DXQWebSocket sharedWebSocket]reconnetWebSocket];
    
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


-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

//    if ([data integerValue]!=0) {
//        [[ProgressHUD sharedProgressHUD]showInView:self.view];
//        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"帐号已被注册")];
//        [[ProgressHUD sharedProgressHUD]done:NO];
//        return;
//    }
    [[ProgressHUD sharedProgressHUD]done:YES];
    
    
//    NSString *acctoun=_accountTextField.text;
//    NSString *psw=_pswTextFiled.text;
//    NSString *lat = [[GPS gpsManager]getLocation:GPSLocationLatitude];
//    NSString *lon = [[GPS gpsManager]getLocation:GPSLocationLongitude];
//    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                              acctoun,@"AccountId",
//                              [Tool ConMD5:psw],@"Password",
//                              acctoun,@"Email",
//                              //                       name,@"MemberName",
//                              //                       male,@"Sex",
//                              lat,@"WeiDu",
//                              lon,@"JingDu",
//                              nil];
    UserInforViewController *userInfo=[[UserInforViewController alloc]init];
//    userInfo.accountAndPsdInfoDic=dic;
    userInfo.phoneNumber=_accountTextField.text;
    [self.navigationController pushViewController:userInfo animated:YES];
    [userInfo release];
}


#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier=@"Register";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    NSString *text=nil;
    
    float orgin_y=44.f/2-31.f/2+5.f;
    
    switch (indexPath.row) {
        case 0:
        {
            text=AppLocalizedString(@"手机");
            if (!_accountTextField) {
                _accountTextField=[self inputTextFieldWithFrame:CGRectMake(110.f, orgin_y, 180.f, 31.f)];
                _accountTextField.tag=indexPath.row;
                _accountTextField.keyboardType=UIKeyboardTypeNumberPad;
            }
            [cell.contentView addSubview:_accountTextField];
        }
            break;
//        case 1:
//        {
//            text=AppLocalizedString(@"真实姓名");
//            if (!_trueNameTextField) {
//                _trueNameTextField=[UITextField creatTextFiledWithFrame:CGRectMake(90.f, 44.f/2-31.f/2+5.f, 200.f, 31.f)];
//                _trueNameTextField.delegate=self;
//                _trueNameTextField.tag=indexPath.row;
//            }
//            [cell.contentView addSubview:_trueNameTextField];
//        }
//            break;
//        case 2:
//        {
//            text=AppLocalizedString(@"性别");
//            if (!maleTextField)
//            {
//                maleTextField=[UITextField creatTextFiledWithFrame:CGRectMake(60.f, 44./2-31.f/2+5.f, 70.f, 31.f)];
//                maleTextField.clearButtonMode=UITextFieldViewModeNever;
//                maleTextField.text=AppLocalizedString(@"男");
//                GenderSelectView *gender=[[GenderSelectView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 260.f)];
//                gender.delegate=self;
//                maleTextField.inputView=gender;
//                maleTextField.delegate=self;
//                maleTextField.tag=indexPath.row;
//                [gender release];
//            }
//            [cell.contentView addSubview:maleTextField];
//        }
//            break;
        case 1:
        {
             text=AppLocalizedString(@"密码");
            if (!_pswTextFiled) {
                _pswTextFiled=[self inputTextFieldWithFrame:CGRectMake(60.f, orgin_y, 230.f, 31.f)];
                _pswTextFiled.secureTextEntry=YES;
                _pswTextFiled.keyboardType=UIKeyboardTypeNumberPad;
                _pswTextFiled.tag=indexPath.row;
            }
            [cell.contentView addSubview:_pswTextFiled];
        }
            break;
        case 2:
        {
            text=AppLocalizedString(@"重复密码");
            if (!_rePswTextFiled) {
                _rePswTextFiled=[self inputTextFieldWithFrame:CGRectMake(90.f, orgin_y, 200.f, 31.f)];
                _rePswTextFiled.secureTextEntry=YES;
                _rePswTextFiled.keyboardType=UIKeyboardTypeNumberPad;
                _rePswTextFiled.returnKeyType=UIReturnKeyDone;
                _rePswTextFiled.tag=indexPath.row;
            }
            [cell.contentView addSubview:_rePswTextFiled];
        }
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text=text;
    cell.textLabel.textColor=[UIColor colorWithString:@"#C3C3C3"];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITextField *textFiled=nil;
    if (indexPath.row==0) {
        textFiled=_accountTextField;
//    }else if(indexPath.row==1)
//    {
//        textFiled=_trueNameTextField;
//    }else if(indexPath.row==2)
//    {
//        textFiled=maleTextField;
    }else if (indexPath.row==1)
    {
        textFiled=_pswTextFiled;
    }else
        textFiled=_rePswTextFiled;
    
    if (textFiled.isFirstResponder==YES) {
        [textFiled resignFirstResponder];
    }else
        [textFiled becomeFirstResponder];
}

#pragma mark -UITextFiledDelegate

//hidden keyborad

-(void)keyBoardHidden:(NSNotification *)not{

    [UIView animateWithDuration:0.25f animations:^{
    
        self.view.frame=CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if ([textField isEqual:_pswTextFiled]||[textField isEqual:_rePswTextFiled]||[textField isEqual:_accountTextField])
    {
        if (string.length!=0) {
            if (textField!=_accountTextField&&textField.text.length+string.length>6) {
                return NO;
            }
            NSString *match=@"^[0-9]*$";
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self matches %@",match];
            return [predicate evaluateWithObject:string];
        }else
            return YES;
    }
    else
        return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect viewFrame=CGRectZero;
    
    if (textField.tag>1) {
        viewFrame=CGRectMake(0.f, -10.0f-(textField.tag-1)*40.f, self.view.frame.size.width, self.view.frame.size.height);
    }else
        viewFrame=CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView animateWithDuration:0.25f animations:^{
    
        self.view.frame=viewFrame;
    }];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    return YES;
//    if (textField==_accountTextField) {
//        [_trueNameTextField becomeFirstResponder];
//    }else if (textField==_trueNameTextField){
//        [maleTextField becomeFirstResponder];
//    }else if (maleTextField==textField){
//        [_pswTextFiled becomeFirstResponder];
//    }else if (textField==_pswTextFiled){
//        [_rePswTextFiled becomeFirstResponder];
//    }else {
//        [textField resignFirstResponder];
//    }
//    return YES;
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
