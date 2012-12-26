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
#import "BuyViewController.h"

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
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.backgroundView=nil;
    [self.view addSubview:tableView];
    [tableView release];
    
    //下一步
    
    UIView *tempFootView=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, tableView.frame.size.width, 80.f)];
    tempFootView.backgroundColor=[UIColor clearColor];
    
    UIImage *nextImg = [UIImage imageNamed:@"signup_btn"];
    CGRect nextBtnRect = CGRectMake(CGRectGetMidX(rect)-nextImg.size.width/2,160.f, nextImg.size.width,nextImg.size.height);
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:nextImg forState:UIControlStateNormal];
    [nextBtn setTitle:AppLocalizedString(@"下一步") forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setFrame:nextBtnRect];
    [tempFootView addSubview:nextBtn];
    tableView.tableFooterView=tempFootView;
    [tempFootView release];
    nextBtn.center=CGPointMake(tempFootView.frame.size.width/2, tempFootView.frame.size.height/2);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"注册") backItemTitle:AppLocalizedString(@"注册")];
	// Do any additional setup after loading the view.
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

    if (signUpRequest) {
        [signUpRequest cancel];
        [signUpRequest release];
        signUpRequest=nil;
    }
    [_trueNameTextField release];
    [_accountAndPsdInfoDic release];
    [_phoneNumber release];
    [_authCodeTextField release];
    [_pswTextField release];
    [_rePswTextField release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Action

-(void)goNext{

    NSString *authNumber=_authCodeTextField.text;
    if (authNumber.length==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"验证码不能为空")];
        [_authCodeTextField becomeFirstResponder];
        return;
    }
    NSString *name=_trueNameTextField.text;
    if (name.length==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"真实姓名不能为空")];
        [_trueNameTextField becomeFirstResponder];
        return;
    }
    
    NSString *psw=_pswTextField.text;
    NSString *rePsw=_rePswTextField.text;
    
    if (psw.length==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"密码不能为空")];
        [_pswTextField becomeFirstResponder];
        return;
    }
    if (psw.length<6) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"密码不能少于六位")];
        [_pswTextField becomeFirstResponder];
        return;
    }
    
    if (rePsw.length==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"重复密码不能为空")];
        [_rePswTextField becomeFirstResponder];
        return;
    }
    
    if (![psw isEqualToString:rePsw]) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"两次输入的密码不一致")];
        [_rePswTextField becomeFirstResponder];
        return;
    }
    
    [_authCodeTextField resignFirstResponder];
    [_trueNameTextField resignFirstResponder];
    [maleTextField resignFirstResponder];
    [_pswTextField resignFirstResponder];
    [_rePswTextField resignFirstResponder];
    
    //do action go next
    NSString * male=[maleTextField.text isEqualToString:@"男"]?@"1":@"0";
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       _phoneNumber,@"AccountId",
                       [Tool ConMD5:psw],@"Password",
                       @"",@"Email",
                       _phoneNumber,@"Telephone",
                       _trueNameTextField.text,@"MemberName",
                       male,@"Sex",
                       [[GPS gpsManager]getLocation:GPSLocationLatitude],@"WeiDu",
                       [[GPS gpsManager]getLocation:GPSLocationLongitude],@"JingDu",
                       _authCodeTextField.text,@"CheckCode", nil];
//    [_accountAndPsdInfoDic setObject:_trueNameTextField.text forKey:@"MemberName"];
//    NSString * male=[maleTextField.text isEqualToString:@"男"]?@"1":@"0";
//    [_accountAndPsdInfoDic setObject:male forKey:@"Sex"];
    if (signUpRequest) {
        [signUpRequest cancel];
        [signUpRequest release];
        signUpRequest=nil;
    }
    [[ProgressHUD sharedProgressHUD] setText:AppLocalizedString(@"正在处理...")];
    [[ProgressHUD sharedProgressHUD] showInView:[[UIApplication sharedApplication].windows lastObject]];
    
    signUpRequest=[[SignUpRequest alloc]initRequestWithDic:dic];
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

#pragma mark -Get Methond

-(UITextField *)authCodeTextField{
    
    if (!_authCodeTextField) {
        _authCodeTextField=[UITextField creatTextFiledWithFrame:CGRectMake(90.f, 44.f/2-31.f/2+5.f, 200.f, 31.f)];
        _authCodeTextField.tag=0;
        _authCodeTextField.keyboardType=UIKeyboardTypeNumberPad;
        _authCodeTextField.delegate=self;
    }
    return _authCodeTextField;
}

-(UITextField *)trueNameTextField{

    if (!_trueNameTextField) {
        _trueNameTextField=[UITextField creatTextFiledWithFrame:CGRectMake(90.f, 44.f/2-31.f/2+5.f, 200.f, 31.f)];
        _trueNameTextField.tag=1;
        _trueNameTextField.delegate=self;
    }
    return _trueNameTextField;
}

-(UITextField *)pswTextField{

    if (!_pswTextField) {
        _pswTextField=[UITextField creatTextFiledWithFrame:CGRectMake(90.f, 44.f/2-31.f/2+5.f, 200.f, 31.f)];
        _pswTextField.secureTextEntry=YES;
        _pswTextField.keyboardType=UIKeyboardTypeNumberPad;
        _pswTextField.delegate=self;
        _pswTextField.tag=3;
    }
    return _pswTextField;
}

-(UITextField *)rePswTextField{

    if (!_rePswTextField) {
        _rePswTextField=[UITextField creatTextFiledWithFrame:CGRectMake(90.f, 44.f/2-31.f/2+5.f, 200.f, 31.f)];
        _rePswTextField.secureTextEntry=YES;
        _rePswTextField.keyboardType=UIKeyboardTypeNumberPad;
        _rePswTextField.delegate=self;
        _rePswTextField.tag=4;
    }
    return _rePswTextField;
}

-(UITextField *)maleTextField
{
    if (!maleTextField) {
        maleTextField=[UITextField creatTextFiledWithFrame:CGRectMake(60.f, 44./2-31.f/2+5.f, 70.f, 31.f)];
        maleTextField.clearButtonMode=UITextFieldViewModeNever;
        maleTextField.text=AppLocalizedString(@"男");
        GenderSelectView *gender=[[GenderSelectView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 260.f)];
        gender.delegate=self;
        maleTextField.tag=2;
        maleTextField.delegate=self;
        maleTextField.inputView=gender;
        [gender release];
    }
    return maleTextField;
}

-(UITextField *)textFieldForTag:(NSInteger)tag
{
    switch (tag) {
        case 0:
            return _authCodeTextField;
            break;
        case 1:
            return _trueNameTextField;
            break;
        case 2:
            return maleTextField;
            break;
        case 3:
            return _pswTextField;
            break;
        case 4:
            return _rePswTextField;
            break;
        default:
            break;
    }
    return nil;
}
#pragma mark -UITextFiledDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField.tag==3||textField.tag==4) {
        if ((textField.text.length+string.length>6)&&textField.text.length!=0) {
            return NO;
        }
    }

    if (textField.tag==0||textField.tag==3||textField.tag==4) {
        NSString *match=@"^[0-9]*$";
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self matches %@",match];
        return [predicate evaluateWithObject:string];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGRect viewFrame=CGRectZero;
    
    if (textField.tag>1) {
        viewFrame=CGRectMake(0.f, -10.0f-(textField.tag-1)*60.f, self.view.frame.size.width, self.view.frame.size.height);
    }else
        viewFrame=CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView animateWithDuration:0.25f animations:^{
        
        self.view.frame=viewFrame;
    }];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    UITextField *tempTextFiled=[self textFieldForTag:textField.tag+1];
    if (tempTextFiled) {
        [tempTextFiled becomeFirstResponder];
    }else
        [textField resignFirstResponder];
    return YES;
}

-(void)keyBoardHidden:(NSNotification *)not{
    
    [UIView animateWithDuration:0.25f animations:^{
        
        self.view.frame=CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

#pragma mark -UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        default:
            return 0;
            break;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0||section==1) {
        return 30.f;
    }else
        return 0.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellText=@"s";
    
    TextFieldTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellText];
    if (!cell) {
       cell=[[[TextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"s"] autorelease];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NSString *text=nil;
    switch (indexPath.section) {
        case 0:
        {
            text=AppLocalizedString(@"验证码");
            cell.textFiled=self.authCodeTextField;
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    text=AppLocalizedString(@"真实姓名");
                    cell.textFiled=self.trueNameTextField;
                    break;
                case 1:
                    text=AppLocalizedString(@"性别");
                    cell.textFiled=[self maleTextField];
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    text=AppLocalizedString(@"密码");
                    cell.textFiled=self.pswTextField;
                }
                    break;
                case 1:
                {
                    text=AppLocalizedString(@"重复密码");
                    cell.textFiled=self.rePswTextField;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
//    if (indexPath.section==0) {
//        cell.textLabel.text=AppLocalizedString(@"真实姓名");
//        if (!_trueNameTextField) {
//            
//        }
//        [cell.contentView addSubview:_trueNameTextField];
//    }else
//    {
//        cell.textLabel.text=AppLocalizedString(@"性别");
//        if (!maleTextField) {
//           
//        }
//    [cell.contentView addSubview:maleTextField];
//    }
    cell.textLabel.text=text;
    cell.textLabel.textColor=[UIColor colorWithString:@"#C3C3C3"];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, tableView.frame.size.width, 30.f)];
    view.backgroundColor=[UIColor clearColor];
    UILabel *label=[[UILabel alloc]initWithFrame:view.bounds];
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=UITextAlignmentCenter;
    label.textColor=[UIColor colorWithString:@"#868178"];
    label.shadowColor=[UIColor colorWithString:@"#FFFFFF"];
    label.font=[UIFont systemFontOfSize:15.f];
    label.shadowOffset=CGSizeMake(0.f, 2.f);
    [view addSubview:label];
    [label release];
    [view autorelease];
    
    if (section==0) {
        label.text=@"请输入接受到的验证码";
        return view;
    }else if(section==1)
    {
        label.text=@"使用真实名字让人更快的找到你和联系人";
    }else
        view=nil;
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TextFieldTableViewCell *cell=(TextFieldTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.textFiled.isFirstResponder) {
        [cell.textFiled resignFirstResponder];
    }else
        [cell.textFiled becomeFirstResponder];
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
