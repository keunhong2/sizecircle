//
//  WriteSignatureVC.m
//  DXQ
//
//  Created by Yuan on 12-11-14.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "WriteSignatureVC.h"
#import "HYEmojiView.h"
#import "UpdateSignatureRequest.h"
#import "DXQAccount.h"

@interface WriteSignatureVC ()<HYEmojiViewDelegate,UpdateSignatureRequestDelegate,UITextViewDelegate>
{    
    UIView *toolView;
    
    BOOL isUpdateSignatureRequesting;
    
    UpdateSignatureRequest *updateSignatureRequest;
    
}

@property(nonatomic,retain)UIView *toolView;

@end

@implementation WriteSignatureVC

@synthesize txtView = _txtView;
@synthesize countLbl = _countLbl;
@synthesize toolView = _toolView;
@synthesize CHARACTER_MAXNUMBERS;

-(void)dealloc
{
    [self removeNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_txtView release];_txtView = nil;
    [_countLbl release];_countLbl = nil;
    [_toolView release];_toolView = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        CHARACTER_MAXNUMBERS = 140;
    }
    return self;
}


-(void)loadView
{
    CGRect rect =  [UIScreen mainScreen ].applicationFrame;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    _txtView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0,rect.size.width,156)];
    _txtView.backgroundColor = [UIColor clearColor];
    _txtView.delegate = self;
    _txtView.font = [UIFont systemFontOfSize:18.0];
    [self.view addSubview:_txtView];
    
    _toolView = [[UIView alloc]initWithFrame:CGRectMake(0,156 ,rect.size.width, 44.0f)];
    _toolView.backgroundColor = [UIColor colorWithWhite:0.916 alpha:1.000];
    [self.view addSubview:_toolView];
    
    UIButton *smileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *smileImg = [UIImage imageNamed:@"e057.png"];
    [smileBtn setFrame:CGRectMake(rect.size.width - smileImg.size.width - 20 ,5, 35, 35)];
    [smileBtn setImage:smileImg forState:UIControlStateNormal];
    [smileBtn addTarget:self action:@selector(emojiKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    [_toolView addSubview:smileBtn];
    
     _countLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 44)];
    [_countLbl setTextColor:[UIColor darkGrayColor]];
    [_countLbl setBackgroundColor:[UIColor clearColor]];
    NSLog(@"%d",CHARACTER_MAXNUMBERS);

    [_countLbl setText:[NSString stringWithFormat:@"0/%d",CHARACTER_MAXNUMBERS]];
    [_toolView addSubview:_countLbl];
    
    HYEmojiView *emoji = [[HYEmojiView alloc]initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height) superViewHeight:rect.size.height - self.navigationController.navigationBar.frame.size.height delegate:self];
    [self.view addSubview:emoji];
    [emoji release];
    
    [_txtView becomeFirstResponder];

    [self textInputChanged:nil];
    
    [self registerForKeyboardNotifications];
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeNotifications
{
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:_toolView name:@"HiddenKeybord" object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey
                      ];
    CGSize keyboardSize = [value CGRectValue].size;    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.30];
    _toolView.frame=CGRectMake(0, self.view.bounds.size.height-keyboardSize.height-44.0f,
                             _toolView.frame.size.width,
                             _toolView.frame.size.height);
    _txtView.frame = CGRectMake(0,0, _txtView.frame.size.width, _toolView.frame.origin.y);

	[UIView commitAnimations];
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.30];
	_toolView.frame=CGRectMake(0,156,
                             _toolView.frame.size.width,
                             _toolView.frame.size.height);
    _txtView.frame = CGRectMake(0,0, _txtView.frame.size.width, _toolView.frame.origin.y);
	[UIView commitAnimations];
}


#pragma 
#pragma mark HYEmojiViewDelegate Methord
-(void)didSelectEmojiImage:(UIImage *)image EmojiString:(NSString *)emoji
{
    [self textInputChanged:nil];
    _txtView.text = [NSString stringWithFormat:@"%@%@",_txtView.text ,emoji];
}

-(void)showKeyBoard:(HYEmojiView *)emojiView
{
    [_txtView becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationItem.title = AppLocalizedString(@"修改签名");
    
    DXQAccount *account = [[DXQCoreDataManager sharedCoreDataManager]getCurrentLoggedInAccount];
    NSString *statusString = account.dxq_Introduction;
    if (!statusString || [statusString isEqual:[NSNull null]]  || [statusString length]<1 )
    {
        statusString = @"";
    }
    else
    {
        statusString = [Tool decodeBase64:statusString];
    }
    [_txtView setText:statusString];
    
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [self setNavgationTitle:AppLocalizedString(@"") backItemTitle:AppLocalizedString(@"返回")];

    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:AppLocalizedString(@"更新") forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:MiddleBoldDefaultFont];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    [rightItem release];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textInputChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (isUpdateSignatureRequesting)
    {
        updateSignatureRequest.delegate = nil;
        [updateSignatureRequest cancel];
    }
    [super viewWillDisappear:animated];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textInputChanged:(NSNotification *)notif
{
    NSString *txtString = [Tool trimmingWhiteSpaceCharacter:_txtView.text];
    NSInteger count = [txtString length];
    if (count > CHARACTER_MAXNUMBERS)
    {
        count = CHARACTER_MAXNUMBERS;
        _txtView.text = [txtString substringToIndex:count];
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"亲，超过字数限制了!")];
        [[ProgressHUD sharedProgressHUD]showInView:[[[UIApplication sharedApplication] windows] lastObject]];
        [[ProgressHUD sharedProgressHUD]done:NO];        
    }
    _countLbl.text = [NSString stringWithFormat:@"%d/%d",count,CHARACTER_MAXNUMBERS];
}


-(void)emojiKeyBoard:(UIButton*)btn
{
    [_txtView resignFirstResponder];
}

-(void)updateAction:(UIButton*)btn
{
    [self startUpdateSignatureRequest];
}

-(NSString *)convertString:(NSString *)str
{
    NSString *result_ =	(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                            (CFStringRef)str,
                                                                            NULL,
                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                            kCFStringEncodingUTF8 );
    return result_;
}


-(void)startUpdateSignatureRequest
{
    if (isUpdateSignatureRequesting)return;

    [_txtView resignFirstResponder];

    NSString *txtString = [Tool trimmingWhiteSpaceCharacter:_txtView.text];

  /*
    if ([txtString length] < 1)
    {
        [Tool showAlertWithTitle:AppLocalizedString(@"签名内容不能为空") msg:nil];
        return;
    }
*/
    if ([txtString length] > CHARACTER_MAXNUMBERS)
    {
        NSString *TipString = [NSString stringWithFormat:@"输入的内容不能超过%d字",CHARACTER_MAXNUMBERS];
        [Tool showAlertWithTitle:AppLocalizedString(TipString) msg:nil];
        return;
    }
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
    [parametersDic setObject:[Tool encodeBase64:txtString] forKey:@"Introduction"];
    [parametersDic setObject:[[SettingManager sharedSettingManager]loggedInAccount] forKey:@"AccountId"];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理...")];
    [[ProgressHUD sharedProgressHUD] showInView:self.view];
    updateSignatureRequest = [[UpdateSignatureRequest alloc] initRequestWithDic:parametersDic];
    updateSignatureRequest.delegate = self;
    [updateSignatureRequest startAsynchronous];
}

-(void)finishedUpdateSignature
{
    isUpdateSignatureRequesting = NO;
    updateSignatureRequest.delegate = nil,
    [updateSignatureRequest release];
    updateSignatureRequest=nil;
}

-(void)updateSignatureRequestDidFinishedWithParamters:(NSDictionary *)dic
{    
    [[ProgressHUD sharedProgressHUD]setText:@"更新成功!"];
    [[ProgressHUD sharedProgressHUD]done];
    [self finishedUpdateSignature];
    [self saveSignature];
    
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(didFinishedAction:)])
    {
        [self.vDelegate didFinishedAction:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateSignatureRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    [[ProgressHUD sharedProgressHUD]setText:errorMsg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [self finishedUpdateSignature];
}

-(void)saveSignature
{
    DXQAccount *account = [[DXQCoreDataManager sharedCoreDataManager]getCurrentLoggedInAccount];
    NSString *txtString = [Tool trimmingWhiteSpaceCharacter:_txtView.text];
    account.dxq_Introduction = [Tool encodeBase64:txtString];
    [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
}

- (void)didReceiveMemoryWarning
{
    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
