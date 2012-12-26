//
//  ChangePswViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-26.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ChangePswViewController.h"
#import "BuyViewController.h"
#import "UITextField+InputTextFiled.h"
#import "UIColor+ColorUtils.h"
#import "ForgotPswRequest.h"

@interface ChangePswViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ForgotPswRequestDelegate>{

    ForgotPswRequest *request;
}
@property (nonatomic,retain)UIView *tableFootView;
@end

@implementation ChangePswViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{

    [super loadView];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.backgroundView=nil;
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [tableView release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"重置密码") backItemTitle:@"验证手机"];
	// Do any additional setup after loading the view.
}

-(void)dealloc{

    [request cancel];
    [request release];
    request=nil;
    [_phoneNumber release];
    [_tableView release];
    [_tableFootView release];
    [_authCodeTextField release];
    [_pswTextField release];
    [_rePswTextField release];
    [super dealloc];
}

#pragma mark -Action

-(void)goNext{

    NSString *authCode=self.authCodeTextField.text;
    if (authCode.length==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:@"验证码不能为空"];
        [self.authCodeTextField becomeFirstResponder];
        return;
    }
    
    NSString *psw=self.pswTextField.text;
    if (psw.length==0) {
        [Tool showAlertWithTitle:@"提示" msg:@"密码不能为空"];
        [self.pswTextField becomeFirstResponder];
        return;
    }
    
    if (psw.length<6) {
        [Tool showAlertWithTitle:@"提示" msg:@"密码不能少于六位"];
        [self.pswTextField becomeFirstResponder];
        return;
    }
    
    NSString *rePsw=self.rePswTextField.text;
    
    if (psw.length==0) {
        [Tool showAlertWithTitle:@"提示" msg:@"密码不能为空"];
        [self.rePswTextField becomeFirstResponder];
        return;
    }
    
    if (psw.length<6) {
        [Tool showAlertWithTitle:@"提示" msg:@"密码不能少于六位"];
        [self.rePswTextField becomeFirstResponder];
        return;
    }
    
    if (![psw isEqualToString:rePsw]) {
        [Tool showAlertWithTitle:@"提示" msg:@"两次输入的密码不一致"];
        [self.rePswTextField becomeFirstResponder];
        return;
    }
    
    [self.authCodeTextField resignFirstResponder];
    [self.pswTextField resignFirstResponder];
    [self.rePswTextField resignFirstResponder];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:_phoneNumber,@"AccountId",authCode,@"CheckCode",[Tool ConMD5:psw],@"Password", nil];
    if (request) {
        [request cancel];
        [request release];
        request=nil;
    }
    
    request=[[ForgotPswRequest alloc]initRequestWithDic:dic];
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在提交")];
    request.delegate=self;
    [request startAsynchronous];
}
#pragma mark -Set method And get method

-(void)setTableView:(UITableView *)tableView{

    if ([_tableView isEqual:tableView]) {
        return;
    }
    [_tableView removeFromSuperview];
    [_tableView release];
    [self.view addSubview:tableView];
    _tableView=[tableView retain];
    _tableView.tableFooterView=self.tableFootView;
}

-(UIView *)tableFootView{

    if (!_tableFootView) {
        _tableFootView=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 80.f)];
        _tableFootView.backgroundColor=[UIColor clearColor];
        
        UIImage *nextImg = [UIImage imageNamed:@"signup_btn"];
        CGRect nextBtnRect = CGRectMake(CGRectGetMidX([[UIScreen mainScreen]bounds])-nextImg.size.width/2,160.f, nextImg.size.width,nextImg.size.height);
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn setBackgroundImage:nextImg forState:UIControlStateNormal];
        [nextBtn setTitle:AppLocalizedString(@"重置密码") forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
        [nextBtn setFrame:nextBtnRect];
        [_tableFootView addSubview:nextBtn];
        nextBtn.center=CGPointMake(_tableFootView.frame.size.width/2, _tableFootView.frame.size.height/2);
    }

    return _tableFootView;
}

-(UITextField *)authCodeTextField{

    if (!_authCodeTextField) {
        _authCodeTextField=[UITextField creatTextFiledWithFrame:CGRectMake(90.f, 44.f/2-31.f/2+5.f, 200.f, 31.f)];
        _authCodeTextField.tag=0;
        _authCodeTextField.keyboardType=UIKeyboardTypeNumberPad;
        _authCodeTextField.delegate=self;
    }
    return _authCodeTextField;
}

-(UITextField *)pswTextField{
    
    if (!_pswTextField) {
        _pswTextField=[UITextField creatTextFiledWithFrame:CGRectMake(90.f, 44.f/2-31.f/2+5.f, 200.f, 31.f)];
        _pswTextField.secureTextEntry=YES;
        _pswTextField.keyboardType=UIKeyboardTypeNumberPad;
        _pswTextField.delegate=self;
        _pswTextField.tag=1;
    }
    return _pswTextField;
}

-(UITextField *)rePswTextField{
    
    if (!_rePswTextField) {
        _rePswTextField=[UITextField creatTextFiledWithFrame:CGRectMake(90.f, 44.f/2-31.f/2+5.f, 200.f, 31.f)];
        _rePswTextField.secureTextEntry=YES;
        _rePswTextField.keyboardType=UIKeyboardTypeNumberPad;
        _rePswTextField.delegate=self;
        _rePswTextField.tag=2;
    }
    return _rePswTextField;
}

#pragma mark -UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return section==0?1:2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellText=@"ss";
    TextFieldTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellText];
    if (!cell) {
        cell=[[[TextFieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellText] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
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
                    text=AppLocalizedString(@"密码");
                    cell.textFiled=self.pswTextField;
                    break;
                case 1:
                    text=AppLocalizedString(@"重复密码");
                    cell.textFiled=self.rePswTextField;
                default:
                    break;
            }
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

    TextFieldTableViewCell *cell=(TextFieldTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textFiled isFirstResponder]) {
        [cell.textFiled resignFirstResponder];
    }else
        [cell.textFiled becomeFirstResponder];
}

#pragma mark -UITextFieldDelegate

#pragma mark -UITextFiledDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag==1||textField.tag==2) {
        if ((textField.text.length+string.length>6)&&textField.text.length!=0) {
            return NO;
        }
    }
    
    NSString *match=@"^[0-9]*$";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self matches %@",match];
    return [predicate evaluateWithObject:string];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    if (textField==_authCodeTextField) {
        [_pswTextField becomeFirstResponder];
    }else if (textField==_pswTextField)
    {
        [_rePswTextField becomeFirstResponder];
    }else
        [textField resignFirstResponder];
    return YES;
}
#pragma mark -RequestDelegate

- (void)forgotPswRequestDidFinishedWithParamters:(NSDictionary *)dic{
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"密码修改成功,请使用新的密码进行登录.")];
    [[ProgressHUD sharedProgressHUD]done:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)forgotPswRequestDidFinishedWithErrorMessage:(NSString *)errorMsg{
    [[ProgressHUD sharedProgressHUD]setText:errorMsg];
    [[ProgressHUD sharedProgressHUD]done:NO];
}

@end
