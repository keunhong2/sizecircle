//
//  SignInVC.m
//  DXQ
//
//  Created by Yuan on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "SignInVC.h"
#import "SignUpVC.h"
#import "UIColor+ColorUtils.h"
#import "UnderLineButton.h"
#import "ProgressHUD.h"
#import "UITextField+InputTextFiled.h"
#import "UserRegisterVC.h"
#import "ForgorPswViewController.h"
#import "SignInRequest.h"
#import "NSString+MD5Addition.h"
#import "GPS.h"
#import "DXQWebSocket.h"

@interface SignInVC ()<SignInRequestDelegate>
{
    SignInRequest *signInRequest;
}

-(UITextField *)inputTextField;

@end

@implementation SignInVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInFinished:) name:NOTIFICATIONCENTER_SIGNIN object:nil];
        _autoLoginAfterLoadView=YES;
        self.title = AppLocalizedString(@"登陆");
    }
    return self;
}


-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    //登陆输入框
    
    UITableView *loginTableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.0f, self.view.frame.size.width, 120.f) style:UITableViewStyleGrouped];
    loginTableView.delegate=self;
    loginTableView.dataSource=self;
    loginTableView.scrollEnabled=NO;
    loginTableView.backgroundColor=[UIColor clearColor];
    loginTableView.backgroundView=nil;
    loginTableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:loginTableView];
    [loginTableView release];
    
    // 是否自动登陆
    
    UILabel *autoLoginTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(20.f, 120.f,0.f, 0.f)];
    autoLoginTitleLabel.backgroundColor=[UIColor clearColor];
    autoLoginTitleLabel.text=@"自动登陆";
    autoLoginTitleLabel.font=[UIFont boldSystemFontOfSize:17.f];
    [autoLoginTitleLabel sizeToFit];
    [self.view addSubview:autoLoginTitleLabel];
    [autoLoginTitleLabel release];
    
    _isAutoLogin=[[UISwitch alloc]initWithFrame:CGRectMake(autoLoginTitleLabel.frame.origin.x+autoLoginTitleLabel.frame.size.width+10.f, autoLoginTitleLabel.frame.origin.y-3.f, 0.f, 0.f)];
    _isAutoLogin.on=[[SettingManager sharedSettingManager]isAutoLogin];
    [self.view addSubview:_isAutoLogin];
    
    //密码遗忘
    
    UnderLineButton *forgotPswBtn=[[UnderLineButton alloc]initWithFrame:CGRectZero];
    forgotPswBtn.title=@"忘记密码";
    [forgotPswBtn sizeToFit];
    forgotPswBtn.frame=CGRectMake(self.view.frame.size.width-20.f-forgotPswBtn.frame.size.width, autoLoginTitleLabel.frame.origin.y, forgotPswBtn.frame.size.width, forgotPswBtn.frame.size.height);
    [forgotPswBtn addTarget:self action:@selector(forgotPsw) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotPswBtn];
    
    //
    
    UIImage *signinImage = [UIImage imageNamed:@"signin_btn"];
    CGRect signinBtnFrame = CGRectMake(CGRectGetMidX(rect)-signinImage.size.width/2, 170.f, signinImage.size.width,signinImage.size.height);
    UIButton *signinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signinBtn setBackgroundImage:signinImage forState:UIControlStateNormal];
    [signinBtn setTitle:AppLocalizedString(@"登陆") forState:UIControlStateNormal];
    [signinBtn setTitleColor:[UIColor colorWithString:@"#535353"] forState:UIControlStateNormal];
    [signinBtn setFrame:signinBtnFrame];
    [signinBtn addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signinBtn];
    
    UIImage *signupImage = [UIImage imageNamed:@"signup_btn"];
    CGRect signupBtnFrame = CGRectMake(CGRectGetMidX(rect)-signupImage.size.width/2,230.f, signupImage.size.width,signupImage.size.height);
    UIButton *signupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [signupBtn setBackgroundImage:signupImage forState:UIControlStateNormal];
    [signupBtn setTitle:AppLocalizedString(@"注册") forState:UIControlStateNormal];
    [signupBtn addTarget:self action:@selector(signUp:) forControlEvents:UIControlEventTouchUpInside];
    [signupBtn setFrame:signupBtnFrame];
    [self.view addSubview:signupBtn];

}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //要加入判断账号和密码是否存在，保证在logout后正常
    NSString *loggedInAccount = [[SettingManager sharedSettingManager]loggedInAccount];
    NSString *loggedInAccountPwd = [[SettingManager sharedSettingManager]loggedInAccountPwd];
    if (_autoLoginAfterLoadView&&[[SettingManager sharedSettingManager]isAutoLogin]&&loggedInAccount&&[loggedInAccount length]>0&&loggedInAccountPwd &&[loggedInAccountPwd length]>0)
    {
        [self performSelector:@selector(autoSignIn) withObject:nil afterDelay:0.5f];
    }
}

-(void)autoSignIn
{
    if ([[DXQWebSocket sharedWebSocket]isOpen])
    {
        [self signIn:nil];
    }
}

-(void)viewDidUnload{

    [super viewDidUnload];
    
    [_isAutoLogin release];
    _isAutoLogin=nil;
}

-(void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATIONCENTER_SIGNIN object:nil];

    [_isAutoLogin release];
    [_accuntTextField release];
    [_pswTextField release];
    [super dealloc];
}

//
-(void)signUp:(UIButton*)btn
{
    UserRegisterVC *vc = [[UserRegisterVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

// sign in
-(void)signIn:(UIButton *)btn
{
    NSString *account=_accuntTextField.text;
    NSString *psw=_pswTextField.text;
    if (account.length==0)
    {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"帐号不能为空")];
        return;
    }
    
    if (psw.length==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"密码不能为空")];
        return;
    }
    
    if (![[DXQWebSocket sharedWebSocket]isOpen])
    {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"连接服务器异常，请稍后再试...")];
        return;
    }
    [_accuntTextField resignFirstResponder];
    [_pswTextField resignFirstResponder];
    
    [[ProgressHUD sharedProgressHUD]setText:@"正在登陆..."];
    [[ProgressHUD sharedProgressHUD] showInView:[[UIApplication sharedApplication].windows lastObject]];
    
    [[AppDelegate sharedAppDelegate] signInWithAccount:account password:psw];
    
    /*
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
    [parametersDic setObject:_accuntTextField.text forKey:@"Account"];
    [parametersDic setObject:[Tool ConMD5:_pswTextField.text] forKey:@"Password"];
    NSString *lat = [[GPS gpsManager]getLocation:GPSLocationLatitude];
    NSString *lon = [[GPS gpsManager]getLocation:GPSLocationLongitude];
    [parametersDic setObject:lon forKey:@"JingDu"];
    [parametersDic setObject:lat forKey:@"WeiDu"];
    [parametersDic setObject:@"0" forKey:@"AccountType"];
    [parametersDic setObject:@"1" forKey:@"DeviceInfo"];
    [parametersDic setObject:[[GPS gpsManager]getLocation:GPSLocationLatitude] forKey:@"WeiDu"];
    [parametersDic setObject:[[GPS gpsManager]getLocation:GPSLocationLongitude] forKey:@"JingDu"];
    
    [[ProgressHUD sharedProgressHUD]setText:@"正在登陆..."];
    [[ProgressHUD sharedProgressHUD] showInView:[[UIApplication sharedApplication].windows lastObject]];

    signInRequest = [[SignInRequest alloc] initRequestWithDic:parametersDic];
    signInRequest.delegate = self;
    [signInRequest startAsynchronous];
     */
}


//websocket登陆后的回调
-(void)signInFinished:(NSNotification *)info
{
    HYLog(@"%@",info);
   id result = info.object;

    if (result && [result isKindOfClass:[NSDictionary class]])
    {
        [self signInRequestDidFinishedWithParamters:result];
    }
    else if(result && [result isKindOfClass:[NSString class]])
    {
        [self signInRequestDidFinishedWithErrorMessage:result];
    }
}

-(void)finishLoginInRequest:(BOOL)isSuccessed withMessage:(NSString *)msg
{
    if (isSuccessed)
    {
        [[ProgressHUD sharedProgressHUD]hide];
    }
    else
    {
        [[ProgressHUD sharedProgressHUD]setText:msg];
        [[ProgressHUD sharedProgressHUD]done:NO];
    }
//    signInRequest.delegate = nil,
//    [signInRequest release];
//    signInRequest=nil;
}

#pragma mark -
#pragma 登陆成功回调
- (void)signInRequestDidFinishedWithParamters:(NSDictionary *)dict
{
    NSString *accountID = [dict objectForKey:@"AccountId"];
    
    NSString *accountPwd = (_pswTextField && [_pswTextField.text length]>0)?_pswTextField.text:@"";
    
    //完成请求
    [self finishLoginInRequest:YES withMessage:nil];
    
    //通知刷新菜单左边的control
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONCENTER_MENU_LEFTCONTROL_REFRESH object:nil userInfo:nil];

    //记录是否自动登陆
    [[SettingManager sharedSettingManager] setIsAutoLogin:_isAutoLogin.on];

    //如果自动登陆则记录密码否则要不记录或删除密码
    [[SettingManager sharedSettingManager]setLoggedInAccountPwd:_isAutoLogin.on?accountPwd:nil];
    
    //websocket终端后重连
    [[SettingManager sharedSettingManager]setTempAccountID:accountID];
    
    [[SettingManager sharedSettingManager]setTempAccountPassword:accountPwd];
    
    //保存用户登陆信息到数据库
    if (dict && [dict isKindOfClass:[NSDictionary class]])
    {
        //保存登陆账号
        [[SettingManager sharedSettingManager]setLoggedInAccount:[dict objectForKey:@"AccountId"]];

        [[AppDelegate sharedAppDelegate] saveAccountInfoToCoreData:dict withPassword:[Tool ConMD5:accountPwd]
                                             dismissViewController:YES];
   }
}
#pragma 登陆失败回调
- (void)signInRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    HYLog(@"error %@",errorMsg);
    [self finishLoginInRequest:NO withMessage:errorMsg];
}

-(void)forgotPsw
{
    ForgorPswViewController *forgot=[[ForgorPswViewController alloc]init];
    [self.navigationController pushViewController:forgot animated:YES];
    [forgot release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Private

-(UITextField *)inputTextField{

    UITextField *textFiled=[UITextField creatTextFiledWithFrame:CGRectMake(60.f, 44.f/2-31.f/2+4.f, 200.f, 31.f)];
    textFiled.delegate=self;
    return textFiled;
}


#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier=@"Login";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text=indexPath.row==0?AppLocalizedString(@"帐号"):AppLocalizedString(@"密码");
    switch (indexPath.row) {
        case 0:
        {
            if (!_accuntTextField) {
                _accuntTextField=[self inputTextField];
                _accuntTextField.text=[[SettingManager sharedSettingManager]loggedInAccount];
            }
            [cell.contentView addSubview:_accuntTextField];
        }
            break;
        case 1:
        {
            if (!_pswTextField) {
                _pswTextField=[self inputTextField];
                _pswTextField.secureTextEntry=YES;
                _pswTextField.returnKeyType=UIReturnKeyDone;
                _pswTextField.text=[[SettingManager sharedSettingManager]loggedInAccountPwd];
                _pswTextField.keyboardType=UIKeyboardTypeNumberPad;
            }
             [cell.contentView addSubview:_pswTextField];
        }
            break;
        default:
            break;
    }
    
    cell.textLabel.textColor=[UIColor colorWithString:@"#C3C3C3"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITextField *textFiled=nil;
    if (indexPath.row==0) {
        textFiled=_accuntTextField;
    }else
        textFiled=_pswTextField;
    
    if (textFiled.isFirstResponder==YES) {
        [textFiled resignFirstResponder];
    }else
        [textFiled becomeFirstResponder];
}

#pragma mark -UITextFiledDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    if ([textField isEqual:_accuntTextField]) {
        [_pswTextField becomeFirstResponder];
    }else
        [_pswTextField resignFirstResponder];
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField==_pswTextField) {
        if (string.length!=0) {
            if (textField.text.length+string.length>6) {
                return NO;
            }
            NSString *match=@"^[0-9]*$";
            NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self matches %@",match];
            return [predicate evaluateWithObject:string];
        }else
            return YES;
    }else
        return YES;
}
@end
