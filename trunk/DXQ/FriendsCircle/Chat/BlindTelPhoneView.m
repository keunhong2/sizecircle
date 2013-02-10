//
//  BlindTelPhoneView.m
//  DXQ
//
//  Created by 黄修勇 on 13-2-10.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "BlindTelPhoneView.h"
#import "SendCodeToPhone.h"

@interface BlindTelPhoneView ()<UITextFieldDelegate,BusessRequestDelegate>
{
    UILabel *promptLabel;
    UITextField *phoneTextFailed;
    SendCodeToPhone *sendPhoneRequest;
}

@end
@implementation BlindTelPhoneView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor whiteColor];
        promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(10.f, 10.f, self.frame.size.width-20   , 0.f)];
        promptLabel.backgroundColor=[UIColor clearColor];
        promptLabel.font=[UIFont systemFontOfSize:15.f];
        promptLabel.text=@"要使用通讯录首先要绑定手机号码,绑定手机号码能让您找到通讯录中大小圈的朋友。绑定的好吗会保密";
        promptLabel.numberOfLines=0;
        [promptLabel sizeToFit];
        promptLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self addSubview:promptLabel];
        
        phoneTextFailed=[[UITextField alloc]initWithFrame:CGRectMake(10.f, promptLabel.frame.origin.y+promptLabel.frame.size.height+10.f, self.frame.size.width-20.f, 31.f)];
        phoneTextFailed.placeholder=@"手机号码";
        phoneTextFailed.clearButtonMode=UITextFieldViewModeWhileEditing;
        phoneTextFailed.keyboardType=UIKeyboardTypeNumberPad;
        phoneTextFailed.delegate=self;
        phoneTextFailed.borderStyle=UITextBorderStyleRoundedRect;
        [self addSubview:phoneTextFailed];
        
        UIImage *nextImg = [UIImage imageNamed:@"signup_btn"];
        CGRect nextBtnRect = CGRectMake(CGRectGetMidX(frame)-nextImg.size.width/2,phoneTextFailed.frame.origin.y+phoneTextFailed.frame.size.height+15.f, nextImg.size.width,nextImg.size.height);
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn setBackgroundImage:nextImg forState:UIControlStateNormal];
        [nextBtn setTitle:AppLocalizedString(@"下一步") forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
        [nextBtn setFrame:nextBtnRect];
        [self addSubview:nextBtn];
    }
    return self;
}

-(void)dealloc
{
    [phoneTextFailed release];
    [promptLabel release];
    [self cancelSendPhone];
    [super dealloc];
}

-(void)goNext
{
 
    if (phoneTextFailed.text.length==0) {
        [Tool showAlertWithTitle:@"提示" msg:@"短信号码不能为空!"];
        return;
    }
    [phoneTextFailed resignFirstResponder];
    [self sendPhone:phoneTextFailed.text];
}

#pragma mark - UITextFailedDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *match=@"^[0-9]*$";
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self matches %@",match];
    return [predicate evaluateWithObject:string];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return  [textField resignFirstResponder];
}

#pragma mark -request

-(void)sendPhone:(NSString *)phone
{
    [self cancelSendPhone];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[[SettingManager sharedSettingManager]loggedInAccount],@"AccountId",phone,@"Phone", nil];
    sendPhoneRequest=[[SendCodeToPhone alloc]initWithRequestWithDic:dic];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
    [sendPhoneRequest setDelegate:self];
    [sendPhoneRequest startAsynchronous];
}

-(void)cancelSendPhone
{
    if (sendPhoneRequest) {
        [sendPhoneRequest cancel];
        [sendPhoneRequest release];
        sendPhoneRequest=nil;
    }
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg
{
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [self busessRequest:nil didFinishWithData:nil];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data
{
    [[ProgressHUD sharedProgressHUD]done:YES];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(binldTelPhoneView:didFinishSendPhone:)]) {
        [self.delegate binldTelPhoneView:self didFinishSendPhone:phoneTextFailed.text];
    }
}
@end
