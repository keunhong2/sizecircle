//
//  ImageFilterVC.m
//  DXQ
//
//  Created by Yuan on 12-11-26.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ImageFilterVC.h"
#import "UIImage+FiltrrCompositions.h"
#import "UIImage+Scale.h"
#import "ProgressHUD.h"
#import "UploadPhoto.h"
#import "UploadPhotoVC.h"

@interface ImageFilterVC ()<UploadPhotoDelegate>
{
    UIImageView *imageView;
    UIImage *originImage;
    UIView *selectView;
    NSMutableArray *arrEffects;
    NSInteger currentStyle;
    NSString *photoType;
}
@property(nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain)UIImage *originImage;
@property(nonatomic,retain)UIView *selectView;
@property(nonatomic,retain)NSMutableArray *arrEffects;
@end

@implementation ImageFilterVC
@synthesize imageView = _imageView;
@synthesize originImage = _originImage;
@synthesize selectView = _selectView;
@synthesize arrEffects = _arrEffects;

-(void)dealloc
{
    [_arrEffects release];_arrEffects = nil;
    [_selectView release];_selectView = nil;
    [_originImage release];_originImage = nil;
    [_imageView release];_imageView = nil;
    [_productID release];_productID=nil;
    [super dealloc];
}

- (id)initWithImage:(UIImage *)image type:(NSString *)type
{
    self = [super init];
    if (self)
    {
        photoType = type;
        
        currentStyle = 0;
        
        _originImage = [image retain];
        
        _arrEffects = [[NSMutableArray alloc] initWithObjects:
                       [NSDictionary dictionaryWithObjectsAndKeys:@"Original",@"title",@"",@"method", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"E3",@"title",@"e3",@"method", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"E1",@"title",@"e1",@"method", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"E2",@"title",@"e2",@"method", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"E10",@"title",@"e10",@"method", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"E8",@"title",@"e8",@"method", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"E5",@"title",@"e5",@"method", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"E4",@"title",@"e4",@"method", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"E7",@"title",@"e7",@"method", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"E11",@"title",@"e11",@"method", nil],
                       [NSDictionary dictionaryWithObjectsAndKeys:@"E9",@"title",@"e9",@"method", nil],
                       nil];
    }
    return self;
}

-(void)loadView
{
    CGRect rect =  [UIScreen mainScreen ].applicationFrame;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,rect.size.width,rect.size.width)];
    [_imageView setImage:_originImage];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,rect.size.height-44-96, rect.size.width, 96)];
    [self.view addSubview:scrollView];
    
    
    for (int i = 0 ; i < 11; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn setFrame:CGRectMake(14+90*i, 10, 76, 76)];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"filter%d.jpg",i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"filter%d.jpg",i]] forState:UIControlStateHighlighted];
        btn.layer.cornerRadius = 6.0f;
        btn.layer.masksToBounds = YES;
        btn.tag = i;
        [btn addTarget:self action:@selector(changeStyle:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
        if (i == 0 ) _selectView.frame = btn.frame;
    }
    _selectView = [[UIView alloc]initWithFrame:CGRectZero];
    [scrollView addSubview:_selectView];
    _selectView.layer.masksToBounds = YES;
    _selectView.layer.cornerRadius = 6.0f;
    _selectView.layer.borderColor = [UIColor whiteColor].CGColor;
    _selectView.layer.borderWidth = 4.0f;
    
    [scrollView setContentSize:CGSizeMake(14+90*11, 0)];
}


-(void)changeStyle:(UIButton *)btn
{
    if(currentStyle == btn.tag)return;
    
    currentStyle = btn.tag;
    
    _selectView.frame = btn.frame;
    
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理")];
    [[ProgressHUD sharedProgressHUD]showInView:self.navigationController.view];
    [self performSelector:@selector(handleImage:) withObject:[NSNumber numberWithInt:currentStyle] afterDelay:0.3];
}

-(void)handleImage:(NSNumber *)index
{
    if ([[[_arrEffects objectAtIndex:[index intValue]] valueForKey:@"method"] length] > 0)
    {
        SEL _selector = NSSelectorFromString([[_arrEffects objectAtIndex:[index intValue]] valueForKey:@"method"]);
        [_imageView setImage:[_originImage performSelector:_selector]];
    }
    else
    {
        [_imageView setImage:_originImage];
    }
    [[ProgressHUD sharedProgressHUD]done];
}

- (void)viewDidLoad
{
    [self setNavgationTitle:AppLocalizedString(@"滤镜") backItemTitle:AppLocalizedString(@"返回")];
    
    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIImage *btnFitImg=[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:btnFitImg forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    rightBtn.frame=CGRectMake(rightBtn.frame.origin.x, rightBtn.frame.origin.y, rightBtn.frame.size.width+10.f,bgImage.size.height);
    [rightBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:AppLocalizedString(@"下一步") forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:MiddleBoldDefaultFont];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    [rightItem release];
    
    rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:AppLocalizedString(@"取消") forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:MiddleBoldDefaultFont];
    rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.leftBarButtonItem=rightItem;
    [rightItem release];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)cancelBtn:(UIButton*)btn
{
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(didCancelViewViewController)])
    {
        [self.vDelegate didCancelViewViewController];
    }
}

-(void)nextAction:(UIButton *)btn
{
    if ([photoType isEqualToString:@"1"])//修改头像
    {
        UploadPhoto *upload = [[UploadPhoto alloc]initWithDelegate:self];
        [upload startUploadImage:_imageView.image];
    }
    else if ([photoType isEqualToString:@"2"])
    {
        UploadPhotoVC *vc = [[UploadPhotoVC alloc]initWithImage:_imageView.image];
        vc.productID=[self productID];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

-(void)uploadPhotoFinished:(UploadPhoto *)up
{
    //通知刷新菜单左边的control
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONCENTER_MENU_LEFTCONTROL_REFRESH object:nil userInfo:nil];
    
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(didFinishedAction:)])
    {
        [self.vDelegate didFinishedAction:self];
    }
    [up release];
}

- (void)didReceiveMemoryWarning
{
    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
