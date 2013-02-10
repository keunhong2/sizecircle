//
//  VerCodeInputView.m
//  DXQ
//
//  Created by 黄修勇 on 13-2-10.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "VerCodeInputView.h"
#import "UserBindPhone.h"

@interface VerCodeInputView ()<UITextFieldDelegate,BusessRequestDelegate>
{
    UILabel *phoneLabel;
    UITextField *checkCodeTextField;
    UserBindPhone *bindRequest;
}

@end
@implementation VerCodeInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        UILabel *verLabel=[[UILabel alloc]initWithFrame:CGRectMake(10.f, 10.f, self.frame.size.width-20.f, 0.f)];
        verLabel.text=@"验证码已经发送到";
        [verLabel sizeToFit];
        verLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:verLabel];
        [verLabel release];
        
        phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(10.f, 5.+verLabel.frame.size.height+verLabel.frame.origin.y, self.frame.size.width-20.f, verLabel.frame.size.height)];
        phoneLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:phoneLabel];
        
        UILabel *inputLabel=[[UILabel alloc]initWithFrame:CGRectMake(10.f, phoneLabel.frame.origin.y+phoneLabel.frame.size.height+5.f, self.frame.size.width-20.f, 0.f)];
        inputLabel.backgroundColor=[UIColor clearColor];
        inputLabel.text=@"请将短信中的数字作为验证码填下到下面";
        [inputLabel sizeToFit];
        [self addSubview:inputLabel];
        [inputLabel release];
        
        checkCodeTextField=[[UITextField alloc]initWithFrame:CGRectMake(10.f, inputLabel.frame.origin.y+10.f+inputLabel.frame.size.height, self.frame.size.width-20.f, 31.f)];
        checkCodeTextField.placeholder=@"验证码";
        checkCodeTextField.keyboardType=UIKeyboardTypeNumberPad;
        checkCodeTextField.delegate=self;
        checkCodeTextField.borderStyle=UITextBorderStyleRoundedRect;
        [self addSubview:checkCodeTextField];
        
        float weidth=(self.frame.size.width-30.f)/2;
        
        UIImage *nextImg = [UIImage imageNamed:@"signup_btn"];
        CGRect nextBtnRect = CGRectMake(10.f,checkCodeTextField.frame.origin.y+checkCodeTextField.frame.size.height+15.f, weidth,nextImg.size.height);
        UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextBtn setBackgroundImage:nextImg forState:UIControlStateNormal];
        [nextBtn setTitle:AppLocalizedString(@"取 消") forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(goCancel) forControlEvents:UIControlEventTouchUpInside];
        [nextBtn setFrame:nextBtnRect];
        [self addSubview:nextBtn];
        
        CGRect cancenRect= CGRectMake(20.f+weidth,checkCodeTextField.frame.origin.y+checkCodeTextField.frame.size.height+15.f, weidth,nextImg.size.height);
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setBackgroundImage:nextImg forState:UIControlStateNormal];
        [cancelBtn setTitle:AppLocalizedString(@"确 定") forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setFrame:cancenRect];
        [self addSubview:cancelBtn];
    }
    return self;
}

-(void)dealloc{

    [checkCodeTextField release];
    [phoneLabel release];
    [self cancelVerCode];
    [super dealloc];
}

-(void)setPhone:(NSString *)phone
{
    phoneLabel.text=phone;
}

-(NSString *)phone
{
    return phoneLabel.text;
}

-(void)goCancel
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(cancelVerCodeInputView:)]) {
        [self.delegate cancelVerCodeInputView:self];
    }
}

-(void)goNext
{
    if (checkCodeTextField.text.length==0) {
        [Tool showAlertWithTitle:@"提示" msg:@"验证码不能为空!"];
        return;
    }
    [self verCode];
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

#pragma mark -requet

-(void)verCode
{
    [self cancelVerCode];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[SettingManager sharedSettingManager].loggedInAccount,@"AccountId",self.phone,@"Phone",checkCodeTextField.text,@"CheckCode", nil];
    bindRequest=[[UserBindPhone alloc]initWithRequestWithDic:dic];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
    bindRequest.delegate=self;
    [bindRequest startAsynchronous];
}

-(void)cancelVerCode
{
    if (bindRequest) {
        [bindRequest cancel];
        [bindRequest release];
        bindRequest=nil;
    }
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg
{
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(finishVerCodeInputView:)]) {
        [self.delegate finishVerCodeInputView:self];
    }
}
@end
