//
//  ForPswGetPhoneNumberViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-26.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ForPswGetPhoneNumberViewController.h"
#import "GetPhoneCheckCodeForFindPsw.h"
#import "ChangePswViewController.h"

@interface ForPswGetPhoneNumberViewController ()<BusessRequestDelegate>{

    GetPhoneCheckCodeForFindPsw *phoneCheckCodeRequest;
}

@end

@implementation ForPswGetPhoneNumberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)dealloc{

    [phoneCheckCodeRequest cancel];
    [phoneCheckCodeRequest release];
    phoneCheckCodeRequest=nil;
    [super dealloc];
}

-(void)goNext{

     NSString *acctoun=self.accountTextField.text;
    if (acctoun.length==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"手机不能为空")];
        [self.accountTextField becomeFirstResponder];
        return;
    }
    
    [self.accountTextField resignFirstResponder];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:self.accountTextField.text,@"Phone", nil];
    if (phoneCheckCodeRequest) {
        [phoneCheckCodeRequest cancel];
        [phoneCheckCodeRequest release];
        phoneCheckCodeRequest=nil;
    }
    phoneCheckCodeRequest=[[GetPhoneCheckCodeForFindPsw alloc]initWithRequestWithDic:dic];
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"获取手机验证码中...")];
    phoneCheckCodeRequest.delegate=self;
    [phoneCheckCodeRequest startAsynchronous];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    if (request==phoneCheckCodeRequest) {
        [[ProgressHUD sharedProgressHUD]done:YES];
        ChangePswViewController *changePsw=[[ChangePswViewController alloc]init];
        [self.navigationController pushViewController:changePsw animated:YES];
        changePsw.phoneNumber=self.accountTextField.text;
        [changePsw release];
    }else
        [super busessRequest:request didFinishWithData:data];
}
@end
