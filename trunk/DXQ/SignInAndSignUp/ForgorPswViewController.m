//
//  ForgorPswViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ForgorPswViewController.h"
#import "UIColor+ColorUtils.h"
#import "UITextField+InputTextFiled.h"

@interface ForgorPswViewController ()
{
    ForgotPswRequest *request;
}
@end

@implementation ForgorPswViewController

@synthesize emailTextFiled=_emailTextFiled;

-(void)dealloc{

    [request cancel];
    [request release];
    [_emailTextFiled release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


-(void)loadView{

    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    //Email 输入框
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 60.f) style:UITableViewStyleGrouped];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.backgroundView=nil;
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.scrollEnabled=NO;
    [self.view addSubview:tableView];
    [tableView release];
    
    //重置密码
    
    UIImage *nextImg = [UIImage imageNamed:@"signup_btn"];
    CGRect nextBtnRect = CGRectMake(CGRectGetMidX(rect)-nextImg.size.width/2,80.f, nextImg.size.width,nextImg.size.height);
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:nextImg forState:UIControlStateNormal];
    [nextBtn setTitle:AppLocalizedString(@"重置密码") forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setFrame:nextBtnRect];
    [self.view addSubview:nextBtn];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavgationTitle:AppLocalizedString(@"重置密码") backItemTitle:AppLocalizedString(@"登陆")];

	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)goNext{

    NSString *email=[_emailTextFiled text];
    if (email.length==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"帐号不能为空")];
        return;
    }
    
    [_emailTextFiled resignFirstResponder];
    
    if (request) {
        [request cancel];
        [request release];
        request=nil;
    }
    
    ProgressHUD *hud=[ProgressHUD sharedProgressHUD];
    [hud showInView:self.view];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:email,@"Email", nil];
    request=[[ForgotPswRequest alloc]initRequestWithDic:dic];
    request.delegate=self;
    [request startAsynchronous];
}

-(void)back{

    [request cancel];
    [super back];
}

-(void)goNextFailedWithErrorMsg:(NSString *)msg{

    ProgressHUD *hud=[ProgressHUD sharedProgressHUD];
    hud.text=msg;
    [hud done:NO];
}

-(void)goNextSuccess{
    ProgressHUD *hud=[ProgressHUD sharedProgressHUD];
    [hud done:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""] autorelease];
    cell.textLabel.text=AppLocalizedString(@"邮箱:");
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (!_emailTextFiled) {
        _emailTextFiled=[UITextField creatTextFiledWithFrame:CGRectMake(60.f, 44.f/2-31.f/2+4.f, 200.f, 31.f)];
        _emailTextFiled.returnKeyType=UIReturnKeyDone;
        _emailTextFiled.delegate=self;
    }
    [cell.contentView addSubview:_emailTextFiled];
    
    cell.textLabel.textColor=[UIColor colorWithString:@"#C3C3C3"];
    cell.textLabel.backgroundColor=[UIColor clearColor];
    return cell;
}

#pragma mark -UITextFiledDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

#pragma mark -RequestDelegate

- (void)forgotPswRequestDidFinishedWithParamters:(NSDictionary *)dic{
    
    [self goNextSuccess];

        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"我们已经发送了一封重置密码的连接到您的邮箱,请注意查收")];

}

- (void)forgotPswRequestDidFinishedWithErrorMessage:(NSString *)errorMsg{
    [self goNextFailedWithErrorMsg:errorMsg];
}
@end
