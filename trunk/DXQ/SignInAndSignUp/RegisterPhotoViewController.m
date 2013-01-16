//
//  RegisterPhotoViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "RegisterPhotoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+ColorUtils.h"
#import "CustomNavigationBar.h"
#import "UserCreatePhotoRequest.h"
#import "UserChangeFaceRequest.h"
#import "UploadPhoto.h"
#import "DXQAccount.h"

@interface RegisterPhotoViewController ()<UserChangeFaceRequestDelegate,UploadPhotoDelegate>
{
    BOOL isSetImage;
    UserChangeFaceRequest *userChangeFaceRequest;
//    UserCreatePhotoRequest *userCreatePhotoRequest;
}
@end

@implementation RegisterPhotoViewController

@synthesize headImageView=_headImageView;

-(void)dealloc{

    [_headImageView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isSetImage=NO;
    }
    return self;
}

-(void)loadView{

    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];

    //头像显示
    
    _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 125.f)];
    _headImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    _headImageView.backgroundColor=[UIColor whiteColor];
    _headImageView.contentMode=UIViewContentModeScaleAspectFit;
    NSString *headImgPath=[[NSBundle mainBundle]pathForResource:@"tx_gray" ofType:@"png"];
    _headImageView.image=[UIImage imageWithContentsOfFile:headImgPath];
    
    [self.view addSubview:_headImageView];
    
    // 相册按钮
    
    UIImage *btnImage=[UIImage imageNamed:@"btn_1"];
    UIColor *btnTitleColor=[UIColor colorWithString:@"#687C93"];
    UIFont *btnFont=[UIFont boldSystemFontOfSize:14.f];
    
    UIButton *albumBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    NSString *albumPath=[[NSBundle mainBundle]pathForResource:@"icon_album_btn" ofType:@"png"];
    UIImage *albumImage=[UIImage imageWithContentsOfFile:albumPath];
    [albumBtn setImage:albumImage forState:UIControlStateNormal];
    [albumBtn setTitle:@"相册" forState:UIControlStateNormal];
    [albumBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    albumBtn.titleLabel.font=btnFont;
    albumBtn.frame=CGRectMake(10.f, 140.f, btnImage.size.width, btnImage.size.height);
    [albumBtn addTarget:self action:@selector(albumBtnDone) forControlEvents:UIControlEventTouchUpInside];
    [albumBtn setTitleColor:btnTitleColor forState:UIControlStateNormal];
    albumBtn.contentEdgeInsets=UIEdgeInsetsMake(0.f, 0.f, 0.f, 20.f);
    albumBtn.titleEdgeInsets=UIEdgeInsetsMake(0.f, 20.f, 0.f, 0.f);
    [self.view addSubview:albumBtn];
    
    //照相按钮
    
    UIButton *cameraBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    NSString *cameraPath=[[NSBundle mainBundle]pathForResource:@"icon_cam_btn" ofType:@"png"];
    UIImage *cametaImg=[UIImage imageWithContentsOfFile:cameraPath];
    [cameraBtn setImage:cametaImg forState:UIControlStateNormal];
    [cameraBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [cameraBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    cameraBtn.titleLabel.font=btnFont;
    cameraBtn.frame=CGRectMake(albumBtn.frame.origin.x+albumBtn.frame.size.width+10.f, 140.f, btnImage.size.width, btnImage.size.height);
    [cameraBtn addTarget:self action:@selector(cameraBtnDone) forControlEvents:UIControlEventTouchUpInside];
    [cameraBtn setTitleColor:btnTitleColor forState:UIControlStateNormal];
    cameraBtn.contentEdgeInsets=UIEdgeInsetsMake(0.f, 0.f, 0.f, 20.f);
    cameraBtn.titleEdgeInsets=UIEdgeInsetsMake(0.f, 20.f, 0.f, 0.f);
    [self.view addSubview:cameraBtn];
    
    //下一步
    
    UIImage *nextImg = [UIImage imageNamed:@"signup_btn"];
    CGRect nextBtnRect = CGRectMake(CGRectGetMidX(rect)-nextImg.size.width/2,200.f, nextImg.size.width,nextImg.size.height);
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setBackgroundImage:nextImg forState:UIControlStateNormal];
    [nextBtn setTitle:AppLocalizedString(@"开始上传") forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setFrame:nextBtnRect];
    [self.view addSubview:nextBtn];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavgationTitle:AppLocalizedString(@"完善个人信息") backItemTitle:AppLocalizedString(@"注册")];
    
    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:AppLocalizedString(@"跳过") forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:MiddleBoldDefaultFont];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    [rightItem release];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
}


-(void)skipAction:(UIButton *)btn
{
    [[AppDelegate sharedAppDelegate]dismissLoginViewControl];   
}

-(void)viewDidUnload{

    [_headImageView release];
    _headImageView=nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Button Action

//相册

-(void)albumBtnDone
{
    UIImagePickerController *imgViewController=[[UIImagePickerController alloc]init];
    [imgViewController setValue:[[[CustomNavigationBar alloc]init]autorelease] forKey:@"navigationBar"];
    imgViewController.delegate=self;
    [self presentModalViewController:imgViewController animated:YES];
    [imgViewController release];
}

//拍照

-(void)cameraBtnDone{

    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
    }else
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"该设备无法调用摄像头")];
}

//下一步

-(void)goNext
{
    if (!isSetImage)
    {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"必须设置一个头像")];
        return;
    }
    UploadPhoto *upload = [[UploadPhoto alloc]initWithDelegate:self];
    [upload startUploadImage:_headImageView.image];
}

-(void)uploadPhotoFinished:(UploadPhoto *)up
{
    //通知刷新菜单左边的control
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONCENTER_MENU_LEFTCONTROL_REFRESH object:nil userInfo:nil];
    [up release];
}

#pragma mark -UIImagePickerViewController

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    _headImageView.image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissModalViewControllerAnimated:YES];
    isSetImage=YES;
}


@end
