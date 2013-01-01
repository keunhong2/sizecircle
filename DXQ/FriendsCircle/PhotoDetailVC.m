//
//  PhotoDetailVC.m
//  DXQ
//
//  Created by Yuan on 12-11-29.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "PhotoDetailVC.h"
#import "UserRemovePhoto.h"
#import "UserLoadPhotoRequest.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ZoomImageView.h"
#import "UserActionToolBar.h"
#import "InPutPageVC.h"
#import "UserAddPraiseRequest.h"
#import "UserAddCommentRequest.h"
#import "PhotoCommentCell.h"
#import "TecentWeiBoShare.h"
#import "SinaWeiBoShare.h"
#import "ImageFilterVC.h"
#import "SDImageCache.h"

@interface PhotoDetailVC ()< UserLoadPhotoRequestDelegate,FriendsCircleRequestDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,SinaWeiBoShareDelegate,TecentWeiBoShareDelegate>
{

    NSString *photoDes;
    NSString *photoid;
    
    BOOL isUserLoadPhotoRequesting;
    BOOL UserLoadCommentListRequesting;

    UserAddCommentRequest *userAddCommentRequest;
    
    UserAddPraiseRequest *userAddPraiseRequest;
    
    UserLoadPhotoRequest *userLoadPhotoRequest;

    UserRemovePhoto *userRemovePhotoRequest;

    NSMutableDictionary *userInfo;
    
    NSMutableArray *dataArr;
    
    UIImageView *avatarImageView;
    UILabel *nameLbl;
    
    UIScrollView *contentScrollView;
    UIScrollView *tagScrollView;
    
    UILabel *dateLbl;
    
    UIImageView *contentImageView;
    
    UIButton *goodButton;
    UIButton *commentButton;
    
    UILabel *deviceInfoLbl;
    UILabel *viewCountLbl;
    
    UITableView *commentTableView;
    
    BOOL isUserSelf;
    
    UITextView *calculateTxtView;
    
    BOOL isPraised;
    BOOL isCommented;
    
    BOOL isUserAccount;
    
    UITextView *desTxtView;
}

@property(nonatomic,retain)NSMutableDictionary *userInfo;
@property(nonatomic,retain)UIImageView *avatarImageView;
@property(nonatomic,retain)UILabel *nameLbl;

@property(nonatomic,retain)UIScrollView *contentScrollView;
@property(nonatomic,retain)UIScrollView *tagScrollView;

@property(nonatomic,retain)UILabel *dateLbl;

@property(nonatomic,retain)UIImageView *contentImageView;

@property(nonatomic,retain)UIButton *goodButton;
@property(nonatomic,retain)UIButton *commentButton;

@property(nonatomic,retain)UILabel *deviceInfoLbl;
@property(nonatomic,retain)UILabel *viewCountLbl;

@property(nonatomic,retain)UITableView *commentTableView;
@property(nonatomic,retain)NSMutableArray *dataArr;
@property(nonatomic,retain)UITextView *desTxtView;

@end

@implementation PhotoDetailVC
@synthesize userInfo = _userInfo;
@synthesize avatarImageView = _avatarImageView;
@synthesize nameLbl = _nameLbl;
@synthesize contentScrollView = _contentScrollView;
@synthesize tagScrollView=_tagScrollView;
@synthesize dateLbl=_dateLbl;
@synthesize contentImageView=_contentImageView;
@synthesize goodButton=_goodButton;
@synthesize commentButton=_commentButton;
@synthesize deviceInfoLbl=_deviceInfoLbl;
@synthesize viewCountLbl=_viewCountLbl;
@synthesize commentTableView=_commentTableView;
@synthesize dataArr = _dataArr;
@synthesize desTxtView = _desTxtView;

-(void)dealloc
{
    [_desTxtView release];_desTxtView = nil;
    [_dataArr release];_dataArr = nil;
    [_userInfo release];_userInfo = nil;
    [_avatarImageView release];_avatarImageView = nil;
    [_nameLbl release];_nameLbl = nil;
    [_contentImageView release];_contentImageView = nil;
    [_tagScrollView release];_tagScrollView = nil;
    [_dateLbl release];_dateLbl = nil;
    [_contentScrollView release];_contentScrollView = nil;
    [_deviceInfoLbl release];_deviceInfoLbl = nil;
    [_viewCountLbl release];_viewCountLbl = nil;
    [_commentTableView release];_commentTableView = nil;
    [super dealloc];
}

-(void)viewDidUnload
{
    self.desTxtView = nil;
    self.avatarImageView = nil;
    self.nameLbl = nil;
    self.contentScrollView = nil;
    self.contentImageView = nil;
    self.tagScrollView = nil;
    self.dateLbl = nil;
    self.goodButton = nil;
    self.commentButton = nil;
    self.deviceInfoLbl = nil;
    self.viewCountLbl = nil;
    self.commentTableView = nil;
    [super viewDidUnload];
}

- (id)initWithUserInfo:(NSDictionary *)info
{
    self = [super init];
    if (self)
    {
        _userInfo = [[NSMutableDictionary alloc]initWithDictionary:info
                     ];
        
        
        NSDictionary *item ;
        if ([_userInfo.allKeys containsObject:@"uploadphotourl"]) {
            
            item= [_userInfo objectForKey:@"uploadphotourl"];
        }else
            item=_userInfo;
        photoid = [item objectForKey:@"Id"];
        photoDes = [item objectForKey:@"FileDesc"];
        
        _dataArr = [[NSMutableArray alloc]initWithArray:nil];
        
        [self getPhotoDetailInfo:photoid];
        
        calculateTxtView = [[UITextView alloc] initWithFrame:CGRectMake(52.0f,30.0f,260.0f,80.0f)];
        [calculateTxtView setHidden:YES];
        [calculateTxtView setFont:[UIFont systemFontOfSize:14.0]];
        [self.view addSubview:calculateTxtView];
        
        isUserAccount =  ([[_userInfo objectForKey:@"AccountId"] isEqualToString:[[SettingManager sharedSettingManager] loggedInAccount]]);

    }
    return self;
}

-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 366)];
    [self.view addSubview:_contentScrollView];
    
    _avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = 6.0f;
    [_contentScrollView addSubview:_avatarImageView];
    
    _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(70,10,200,25)];
    _nameLbl.textColor = [UIColor blackColor];
    _nameLbl.backgroundColor = [UIColor clearColor];
    _nameLbl.font = [UIFont boldSystemFontOfSize:16.0];
    [_contentScrollView addSubview:_nameLbl];
    
    _dateLbl = [[UILabel alloc]initWithFrame:CGRectMake(235,10,75,25)];
    _dateLbl.textColor = [UIColor grayColor];
    [_dateLbl setTextAlignment:UITextAlignmentRight];
    [_dateLbl setBackgroundColor:[UIColor clearColor]];
    _dateLbl.font = [UIFont systemFontOfSize:10.0];
    [_contentScrollView addSubview:_dateLbl];
    
    _tagScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(70,40, 240,25)];
    _tagScrollView.showsHorizontalScrollIndicator = NO;
    [_contentScrollView addSubview:_tagScrollView];
    
    _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20,70,280,280)];
    _contentImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _contentImageView.layer.borderWidth = 6.0f;
    _contentImageView.image=[UIImage imageNamed:@"Info_icon_default.jpg"];
    _contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    _contentImageView.clipsToBounds = YES;
    _contentImageView.userInteractionEnabled = YES;
    [_contentScrollView addSubview:_contentImageView];    
    
    CGRect desFrame = CGRectMake(20, 200, 280, 100);
    _desTxtView = [[UITextView alloc]initWithFrame:desFrame];
    _desTxtView.textColor = [UIColor whiteColor];
    [_desTxtView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
    _desTxtView.text = photoDes;
    [_desTxtView sizeToFit];
    _desTxtView.userInteractionEnabled = NO;
    desFrame.size.height = _desTxtView.contentSize.height;
    desFrame.origin.y = 350 - _desTxtView.contentSize.height;
    _desTxtView.frame  = desFrame;
    [_contentScrollView addSubview:_desTxtView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImage:)];
    [_contentImageView addGestureRecognizer:tap];
    [tap release];
    
    UIImage *bgImage=[UIImage imageNamed:@"weibo_follow"];
    UIImage *likeImage =  [Tool scaleFromImage:[UIImage imageNamed:@"TopicLikeIcon@2x"] toSize:CGSizeMake(26,26)];
    UIImage *commentImage=[Tool scaleFromImage:[UIImage imageNamed:@"TopicReviewIcon@2x"] toSize:CGSizeMake(26,23)];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:0];
    UIColor *titleColor = [UIColor colorWithRed:0.092 green:0.359 blue:0.566 alpha:1.000];

    _goodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goodButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    [_goodButton setImage:likeImage forState:UIControlStateNormal];
    [_goodButton setTitle:@"0人" forState:UIControlStateNormal];
    [_goodButton setFrame:CGRectMake(20, 365, 130, 35)];
    [_goodButton setTitleColor:titleColor forState:UIControlStateHighlighted];
    [_goodButton setTitleColor:titleColor forState:UIControlStateNormal];
    _goodButton.titleLabel.textColor = titleColor;
    _goodButton.titleLabel.font = NormalBoldDefaultFont;
    [_goodButton addTarget:self action:@selector(goodAction:) forControlEvents:UIControlEventTouchUpInside];
    [_goodButton setImageEdgeInsets:UIEdgeInsetsMake(5,-60, 0, 0)];
    [_goodButton setTitleEdgeInsets:UIEdgeInsetsMake(5,10, 0, 0)];
    [_contentScrollView addSubview:_goodButton];
    
    _commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentButton setFrame:CGRectMake(170, 365, 130, 35)];
    [_commentButton setTitle:@"0人" forState:UIControlStateNormal];
    [_commentButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    [_commentButton setImage:commentImage forState:UIControlStateNormal];
    _commentButton.titleLabel.textColor = titleColor;
    _commentButton.titleLabel.font = NormalBoldDefaultFont;
    [_commentButton setTitleColor:titleColor forState:UIControlStateHighlighted];
    [_commentButton setTitleColor:titleColor forState:UIControlStateNormal];
    [_commentButton setImageEdgeInsets:UIEdgeInsetsMake(5,-50, 0, 0)];
    [_commentButton setTitleEdgeInsets:UIEdgeInsetsMake(5,10, 0, 0)];
    [_commentButton addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentScrollView addSubview:_commentButton];
    
    _deviceInfoLbl = [[UILabel alloc]initWithFrame:CGRectMake(20,410,130,25)];
    _deviceInfoLbl.textColor = [UIColor grayColor];
    _deviceInfoLbl.backgroundColor = [UIColor clearColor];
    _deviceInfoLbl.font = [UIFont systemFontOfSize:12.0];
    [_contentScrollView addSubview:_deviceInfoLbl];
    
    _viewCountLbl = [[UILabel alloc]initWithFrame:CGRectMake(170,410,130,25)];
    _viewCountLbl.textColor = [UIColor grayColor];
    [_viewCountLbl setAdjustsFontSizeToFitWidth:YES];
    [_viewCountLbl setTextAlignment:UITextAlignmentRight];
    _viewCountLbl.backgroundColor = [UIColor clearColor];
    _viewCountLbl.font = [UIFont systemFontOfSize:12.0];
    [_contentScrollView addSubview:_viewCountLbl];
    
    _commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 440, 320, 100) style:UITableViewStylePlain];
    _commentTableView.backgroundColor = [UIColor clearColor];
    _commentTableView.backgroundView = nil;
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    [_contentScrollView addSubview:_commentTableView];    
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 366, 320, 50)];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    bottomView.layer.shadowRadius = 4.0;
    bottomView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9].CGColor;
    bottomView.layer.shadowOffset=CGSizeMake(0.0f, 0.0f);
    bottomView.layer.shadowOpacity = 0.4;
    [self.view addSubview:bottomView];
    
    //actionbar height
    NSArray *items =[NSArray arrayWithObjects:
                     [NSDictionary dictionaryWithObjectsAndKeys:@"FocusToolBarCommentsIcon.png",@"img",AppLocalizedString(@"评论"),@"title", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"FocusToolBarUnlikeIcon.png",@"img",AppLocalizedString(@"称赞"),@"title", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"FocusToolBarShareIcon.png",@"img",AppLocalizedString(@"分享"),@"title", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"MoreIcon.png",@"img",AppLocalizedString(@"更多"),@"title", nil], nil];
    CGFloat userActionToolBarHeight = 50.0f;
    UserActionToolBar *uaToolBar = [[UserActionToolBar alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width,userActionToolBarHeight) target:self action:@selector(tapUserActionToolBarItem:) items:items];
    uaToolBar.tag = 1000;
    [bottomView addSubview:uaToolBar];
    [uaToolBar release];
    [bottomView release];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(isUserLoadPhotoRequesting && userLoadPhotoRequest)
    {
        [userLoadPhotoRequest cancel];
    }
    [super viewWillDisappear:animated];
}

-(void)commentAction:(UIButton *)btn
{
    InPutPageVC *vc = [[InPutPageVC alloc]initWithTitle:AppLocalizedString(@"发表评论") content:@"" delegate:self];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(void)goodAction:(UIButton*)btn
{
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理...")];
    [[ProgressHUD sharedProgressHUD]showInView:self.navigationController.view];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       @"MemberFile",@"ObjectKind",photoid,@"ObjectNo",[[SettingManager sharedSettingManager]loggedInAccount],@"AccountId", nil];
    userAddPraiseRequest=[[UserAddPraiseRequest alloc]initWithRequestWithDic:dic];
    userAddPraiseRequest.delegate=self;
    [userAddPraiseRequest startAsynchronous];
    
}

-(void)friendsCircleRequestRequest:(FriendsCircleRequest *)request didFinishWithData:(id)data
{
    if ([request isEqual:userAddPraiseRequest])
    {
        isPraised = YES;
        _goodButton.enabled = NO;

        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"赞成功!")];
        [[ProgressHUD sharedProgressHUD]done];
        [userAddPraiseRequest release];userAddPraiseRequest = nil;
        NSDictionary *info = [_userInfo objectForKey:@"Info"];
        NSInteger pcount = [[info objectForKey:@"PraiseCount"] intValue];
        pcount++;
        NSMutableDictionary *minfo = [[NSMutableDictionary alloc]initWithDictionary:info];
        [minfo setObject:[NSString stringWithFormat:@"%d",pcount] forKey:@"PraiseCount"];
        [_userInfo setObject:minfo forKey:@"Info"];
        [minfo release];
        [self refreshUI];
    }
    else if([request isEqual:userAddCommentRequest])
    {
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"评论成功!")];
        [[ProgressHUD sharedProgressHUD]done];
        [userAddCommentRequest release];userAddCommentRequest = nil;
        
        _commentButton.enabled = NO;
        isCommented = YES;
        
        [self getPhotoDetailInfo:photoid];
    }
    else if([request isEqual:userRemovePhotoRequest])
    {
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"删除成功!")];
        [[ProgressHUD sharedProgressHUD]done];
        [userRemovePhotoRequest release];userRemovePhotoRequest = nil;
        
        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(didFinishedAction:)])
        {
            [self.vDelegate didFinishedAction:self];
        }
    }
    HYLog(@"%@",data);
}

-(void)friendsCircleRequestRequest:(FriendsCircleRequest *)request didFailedWithErrorMsg:(NSString *)msg
{
    HYLog(@"%@",msg);
    NSString *e = @"";
    if (msg)e = msg;
    if ([request isEqual:userAddPraiseRequest])
    {
        NSString *tip = [NSString stringWithFormat:@"%@,%@",AppLocalizedString(@"赞失败!"),e];
        [[ProgressHUD sharedProgressHUD]setText:tip];
        [[ProgressHUD sharedProgressHUD]done:NO];
        [userAddPraiseRequest release];userAddPraiseRequest = nil;
    }
    else if([request isEqual:userAddCommentRequest])
    {
            NSString *tip = [NSString stringWithFormat:@"%@,%@",AppLocalizedString(@"评论失败!"),e];
            [[ProgressHUD sharedProgressHUD]setText:tip];
            [[ProgressHUD sharedProgressHUD]done:NO];
            [userAddCommentRequest release];userAddCommentRequest = nil;
    }
    else if([request isEqual:userRemovePhotoRequest])
    {
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"删除失败!")];
        [[ProgressHUD sharedProgressHUD]done:NO];
        [userRemovePhotoRequest release];userRemovePhotoRequest = nil;
    }
}

#pragma vDelegate Methord
-(void)didFinishedAction:(UIViewController *)viewController witfhInfo:(id)info
{
    if ([viewController isKindOfClass:[ImageFilterVC class]])
    {
        //set avatar
    }
    else
    {
        if (info && [info isKindOfClass:[NSString class]] && [info length]>0)
        {
            [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理...")];
            [[ProgressHUD sharedProgressHUD]showInView:self.navigationController.view];
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                               @"MemberFile",@"ObjectKind",photoid,@"ObjectNo",[[SettingManager sharedSettingManager]loggedInAccount],@"AccountId",info,@"Content", nil];
            userAddCommentRequest=[[UserAddCommentRequest alloc]initWithRequestWithDic:dic];
            userAddCommentRequest.delegate=self;
            [userAddCommentRequest startAsynchronous];
        }
    }
    HYLog(@"%@",info);
}

//ActionToolBar
-(void)tapUserActionToolBarItem:(UITapGestureRecognizer *)tap
{
    UIButtonUserInfoAction *toolbaritem = (UIButtonUserInfoAction *)tap.view;
    HYLog(@"%d",toolbaritem.tag);
    if (isUserSelf)
    {
        
    }
    else
    {
        switch (toolbaritem.tag) {
            case 1:
                if (isCommented)
                {
                    toolbaritem.alpha = 0.5;
                }
                else
                {
                    [self commentAction:nil];
                }
                break;
            case 2:
                toolbaritem.alpha = 0.5;
                if (!isPraised)
                {
                    [self goodAction:nil];
                    isPraised = YES;
                    toolbaritem.userInteractionEnabled = NO;
                }
                else
                {
                    toolbaritem.userInteractionEnabled = NO;                
                }
                break;
            case 3:
                [self shareAction];
                break;
            case 4:
                [self actionMore];
                break;
            default:
                break;
        }
    
    }
}

//更多
-(void)actionMore
{
    UIActionSheet *sheet;

    if (isUserAccount)
    {
        sheet = [[UIActionSheet alloc]initWithTitle:AppLocalizedString(@"请选择需要的操作") delegate:self cancelButtonTitle:AppLocalizedString(@"取消") destructiveButtonTitle:AppLocalizedString(@"删除该图片") otherButtonTitles:AppLocalizedString(@"设为头像"),AppLocalizedString(@"保存到相册"), nil];
    }
    else
    {
        sheet = [[UIActionSheet alloc]initWithTitle:AppLocalizedString(@"请选择需要的操作") delegate:self cancelButtonTitle:AppLocalizedString(@"取消") destructiveButtonTitle:nil otherButtonTitles:AppLocalizedString(@"保存到相册"), nil];
    }
    sheet.tag = 2;
    [sheet showInView:self.navigationController.view];
    [sheet release];
}

-(void)shareAction
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:AppLocalizedString(@"取消") destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"腾讯微博", nil];
    sheet.tag = 1;
    [sheet showInView:self.navigationController.view];
    [sheet release];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    
    else if( actionSheet.tag ==1)
    {
        if(buttonIndex == 0)
        {
            [self performSelector:@selector(shateToSina) withObject:nil afterDelay:0.0];
        }
        else
        {
            [self performSelector:@selector(shateToQQ) withObject:nil afterDelay:0.0];
        }
    }
    else if( actionSheet.tag ==2)
    {
        if (isUserAccount)
        {
            if(buttonIndex == 0)
            {
                [self performSelector:@selector(deletePhoto) withObject:nil afterDelay:0.0];
            }
            else if(buttonIndex == 1)
            {
                [self performSelector:@selector(setToUserAvatar) withObject:nil afterDelay:0.0];
            }
            else if(buttonIndex == 2)
            {
                [self performSelector:@selector(saveToPhoto) withObject:nil afterDelay:0.0];
            }
        }
        else
        {
            if(buttonIndex == 0)
            {
                [self performSelector:@selector(saveToPhoto) withObject:nil afterDelay:0.0];
            }
        }
    }
}


-(void)shateToSina
{
    NSDictionary *info = [_userInfo objectForKey:@"Info"];
    if (info)
    {
        UIImage *image = [[SDImageCache sharedImageCache]imageFromKey:[info objectForKey:@"FilePath"]];
        if (image)
        {
            [[SinaWeiBoShare sharedSinaWeiBo]setDelegate:self];
            [[SinaWeiBoShare sharedSinaWeiBo].sinaweibo logIn];
        }
    }  
}

-(void)SinaWeiBoShareBindFailure
{
    [[SinaWeiBoShare sharedSinaWeiBo]setDelegate:nil];
}

-(void)SinaWeiBoShareBindSuccessed
{
    NSDictionary *info = [_userInfo objectForKey:@"Info"];
    if (info)
    {
        UIImage *image = [[SDImageCache sharedImageCache]imageFromKey:[info objectForKey:@"FilePath"]];
        if (image)
        {
            NSString *msg = [NSString stringWithFormat:@"%@分享图片%@，来自大小圈iPhone版",[info objectForKey:@"MemberName"],photoDes];
            [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在分享...")];
            [[ProgressHUD sharedProgressHUD]showInView:[UIApplication sharedApplication].keyWindow];
            [[SinaWeiBoShare sharedSinaWeiBo]postTextMessage:msg withImage:image];
        }
    }
}

-(void)SinaWeiBoShareRequestSuccessed
{
    [[ProgressHUD sharedProgressHUD] hide];
}

-(void)SinaWeiBoShareRequestFailure
{
    [[ProgressHUD sharedProgressHUD] hide];
}



-(void)shateToQQ
{
    NSDictionary *info = [_userInfo objectForKey:@"Info"];
    if (info)
    {
        UIImage *image = [[SDImageCache sharedImageCache]imageFromKey:[info objectForKey:@"FilePath"]];
        if (image)
        {
            [[TecentWeiBoShare sharedTecentWeiBoShare]setDelegate:self];
            [[TecentWeiBoShare sharedTecentWeiBoShare] onLogin];
        }
    }
}


-(void)TecentWeiBoShareBindFailure
{
    [[TecentWeiBoShare sharedTecentWeiBoShare]setDelegate:nil];
}

-(void)TecentWeiBoShareBindSuccessed
{
    NSDictionary *info = [_userInfo objectForKey:@"Info"];
    if (info)
    {
        UIImage *image = [[SDImageCache sharedImageCache]imageFromKey:[info objectForKey:@"FilePath"]];
        if (image)
        {
            NSString *msg = [NSString stringWithFormat:@"%@分享图片%@，来自大小圈iPhone版",[info objectForKey:@"MemberName"],photoDes];
            [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在分享...")];
            [[ProgressHUD sharedProgressHUD]showInView:[UIApplication sharedApplication].keyWindow];
            [[TecentWeiBoShare sharedTecentWeiBoShare]postMessage:msg withImage:UIImageJPEGRepresentation(image, 0.6)];
        }
    }
}

-(void)TecentWeiBoShareRequestSuccessed
{
    [[ProgressHUD sharedProgressHUD] hide];
}

-(void)TecentWeiBoShareRequestFailure
{
    [[ProgressHUD sharedProgressHUD] hide];
}


-(void)saveToPhoto
{
    UIImageWriteToSavedPhotosAlbum(_contentImageView.image, nil, nil, nil);
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"保存成功!")];
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]done];
}

//删除照片
-(void)deletePhoto
{
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理...")];
    [[ProgressHUD sharedProgressHUD]showInView:self.navigationController.view];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       photoid,@"Id", nil];
    userRemovePhotoRequest=[[UserRemovePhoto alloc]initWithRequestWithDic:dic];
    userRemovePhotoRequest.delegate=self;
    [userRemovePhotoRequest startAsynchronous];
}

//设置为头像
-(void)setToUserAvatar
{
        ImageFilterVC *vc = [[ImageFilterVC alloc]initWithImage:_contentImageView.image type:@"1"];
        CustonNavigationController *nav = [[CustonNavigationController alloc]initWithRootViewController:vc];
        vc.vDelegate = self;
        [[AppDelegate sharedAppDelegate].menuController presentModalViewController:nav animated:YES];
        [vc release];
        [nav release];
}

-(void)tapImage:(UIGestureRecognizer *)sender
{
    NSDictionary *info = [_userInfo objectForKey:@"Info"];
    if (info)
    {
        NSString *picurl = [info objectForKey:@"FilePath"];
        if (picurl && [picurl length] > 0)
        {
            CGRect rect = [_contentImageView convertRect:_contentImageView.bounds toView:nil];
            ZoomImageView *zoom = [[ZoomImageView alloc]initWithFrame:[UIScreen mainScreen].bounds withImage:nil delegate:self withUrl:picurl withOriginRect:rect];
            [self.navigationController.view addSubview:zoom];
            [zoom release];
        }
    }
}

-(void)getPhotoDetailInfo:(NSString *)pid
{
    if (isUserLoadPhotoRequesting) {
        return;
    }
    isUserLoadPhotoRequesting = YES;
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       pid,@"Id", nil];
    userLoadPhotoRequest = [[UserLoadPhotoRequest alloc]initRequestWithDic:dic];
    userLoadPhotoRequest.delegate=self;
    [userLoadPhotoRequest startAsynchronous];
}

-(void)userLoadPhotoRequestDidFinishedWithParamters:(id)result
{
    HYLog(@"%@",result);
    NSDictionary *arr = (NSDictionary *)result;
    if (arr &&[arr isKindOfClass:[NSDictionary class]]&&[arr count]>0)
    {
        [_userInfo removeAllObjects];
        [_userInfo addEntriesFromDictionary:result];
        [self refreshUI];
    }
    HYLog(@"%@",_userInfo);

    isUserLoadPhotoRequesting = NO;
    [userLoadPhotoRequest release];
    userLoadPhotoRequest = nil;
}

-(void)userLoadPhotoRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    isUserLoadPhotoRequesting = NO;
    [userLoadPhotoRequest release];
    userLoadPhotoRequest = nil;
}

-(void)refreshUI
{
    NSDictionary *info = [_userInfo objectForKey:@"Info"];
    
    NSString *picurl = [NSString stringWithFormat:@"%@%@",[info objectForKey:@"PhotoUrl"],THUMB_IMAGE_SUFFIX];
    NSURL *URL = [NSURL URLWithString:picurl];
    [_avatarImageView setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"Info_icon_default.jpg"] ];
    
    _nameLbl.text = [info objectForKey:@"MemberName"];
    
    NSString *lbl = [info objectForKey:@"Label"];
    if (lbl&&[lbl length]>0)
    {
        NSMutableArray *lbls = [[NSMutableArray alloc]initWithArray:[lbl componentsSeparatedByString:@","]];
        NSString *addressInfo = [info objectForKey:@"AddressInfo"];
        if (addressInfo && [addressInfo length]>0)
        {
            [lbls addObject:addressInfo];
        }
        CGFloat lbl_x = 0.0f;
        for (int i = 0 ; i < [lbls count]; i++)
        {
            NSString *s =[lbls objectAtIndex:i];
            UILabel *lbl =[[UILabel alloc]initWithFrame:CGRectMake(lbl_x, 0, 89,25)];
            [lbl setText:s];
            [lbl setFont:[UIFont systemFontOfSize:12.0]];
            lbl.layer.cornerRadius = 4.0f;
            lbl.layer.masksToBounds = YES;
            lbl.textColor = [UIColor whiteColor];
            lbl.backgroundColor = [self getColor];
            [lbl sizeToFit];
            [_tagScrollView addSubview:lbl];
            lbl_x = lbl_x + lbl.frame.size.width + 5.0f;
            [lbl release];
        }
        [_tagScrollView setContentSize:CGSizeMake(lbl_x, 0)];
        [lbls release];
    }
    
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:[[info objectForKey:@"CreateDate"]longLongValue]];
    _dateLbl.text =  [NSString stringWithFormat:@"%@前",[Tool calculateDate:confromTime]];
    
    [_contentImageView setImageWithURL:[NSURL URLWithString:[info objectForKey:@"FilePath"]] placeholderImage:[UIImage imageNamed:@"user_detail_topdefault.jpg"]];
    
    [_goodButton setTitle:[NSString stringWithFormat:@"%@人",[info objectForKey:@"PraiseCount"]] forState:UIControlStateNormal];
    [_commentButton setTitle:[NSString stringWithFormat:@"%@人",[info objectForKey:@"CommentCount"]] forState:UIControlStateNormal];
    
    NSString *device  = [info objectForKey:@"DeviceInfo"];
    if (device&&[device isKindOfClass:[NSString class]]&& [device length]>0)
    {
        
        if([device isEqualToString:@"0"])
        {
        _deviceInfoLbl.text = @"来自电脑网页";
        }
        else if([device isEqualToString:@"1"])
        {
            _deviceInfoLbl.text = @"来自iPhone客户端";
        }
        else if([device isEqualToString:@"2"])
        {
            _deviceInfoLbl.text = @"来自Android客户端";
        }
        else
        {
            _deviceInfoLbl.text = @"来自未知客户端";
        }
    }
    
    _viewCountLbl.text = [NSString stringWithFormat:@"该照片已被浏览%@次",[info objectForKey:@"ReadCount"]];
    
    [_dataArr removeAllObjects];
    NSArray *items = [_userInfo objectForKey:@"Items"];
    CGFloat contentSizeHeight = 0.0f;
    if (items && [items isKindOfClass:[NSArray class]] &&[items count]>0)
    {
        [_dataArr addObjectsFromArray:items];
        [_commentTableView reloadData];
        contentSizeHeight = 15.0f;
    }
    
    CGRect rect = _commentTableView.frame;
    rect.size.height = _commentTableView.contentSize.height;
    _commentTableView.frame = rect;
    
    [_contentScrollView setContentSize:CGSizeMake(0.0f,445.0f+rect.size.height+contentSizeHeight)];
}

- (UIColor *)getColor
{    
    UIColor *color1 = [UIColor colorWithRed:1.000 green:0.203 blue:0.269 alpha:1.000];
    
    UIColor *color2 = [UIColor colorWithRed:0.185 green:0.562 blue:1.000 alpha:1.000];

    UIColor *color3 = [UIColor colorWithRed:0.308 green:0.772 blue:0.135 alpha:1.000];

    UIColor *color4 = [UIColor colorWithRed:0.174 green:0.838 blue:1.000 alpha:1.000];

    NSArray *colors = [NSArray arrayWithObjects:color1,color2,color3,color4, nil];
    
    srandom(time(NULL)); //将随机数种子重置,
    int idx=rand()%4;
    if (idx>=4||idx<0)idx = 0;
    return  [colors objectAtIndex:idx];
//    UIColor *uicolor = [UIColor colorWithRed:[self getRandomNumber] green:[self getRandomNumber] blue:[self getRandomNumber] alpha:1.0];
}

-(CGFloat)getRandomNumber
{
    srandom(time(NULL)); //将随机数种子重置,
    int index = arc4random() % 100 + 50;
    float color = (float)index/100;
    return color;
}

- (void)viewDidLoad
{
    [self setNavgationTitle:[_userInfo objectForKey:@"MemberName"] backItemTitle:AppLocalizedString(@"返回")];
    
    [super viewDidLoad];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [_dataArr objectAtIndex:indexPath.row];
    NSString *content = [item objectForKey:@"Content"];
    calculateTxtView.text = content;
    CGFloat h = calculateTxtView.contentSize.height + 30.0f;
    if (h < 60 ) {
        return 60;
    }
    return h;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArr count];
}

-(void)viewUser:(UIButton *)btn
{

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell"];
    PhotoCommentCell * cCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];    
    if (cCell == nil)
    {
        cCell = (PhotoCommentCell*)[[[PhotoCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *item = [_dataArr objectAtIndex:indexPath.row];
    [cCell.iconButton setImageWithURL:[NSURL URLWithString:[item objectForKey:@"PhotoUrl"]]];
    [cCell.iconButton addTarget:self action:@selector(viewUser:) forControlEvents:UIControlEventTouchUpInside];
    cCell.aliasLable.text = [item objectForKey:@"MemberName"];
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:[[item objectForKey:@"OpTime"]longLongValue]];
    _dateLbl.text =  [NSString stringWithFormat:@"%@前",[Tool calculateDate:confromTime]];
    
    cCell.timeLbl.text =  [item objectForKey:@"create_time"];
    [cCell.contentLbl setText:[item objectForKey:@"Content"]];
    cCell.accessoryType = UITableViewCellAccessoryNone;
    cCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
