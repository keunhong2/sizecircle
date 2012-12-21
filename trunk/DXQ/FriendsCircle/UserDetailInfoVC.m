//
//  UserDetailInfoVC.m
//  DXQ
//
//  Created by Yuan on 12-10-19.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UserDetailInfoVC.h"
#import "FansListVC.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "FansView.h"
#import "UserActionToolBar.h"
#import "UIImageView+WebCache.h"
#import "BottomToolBar.h"
#import "AboutTableViewDataSource.h"
#import "ActivityTableViewDataSource.h"
#import "SendGiftsVC.h"
#import "ChatVC.h"
#import "UserInfoDetailRequest.h"
#import "UserReportUserRequest.h"
#import "SayHelloRequest.h"
#import "UserRemoveRelation.h"
#import "RelationMakeRequest.h"
#import "EditUserInfoVC.h"
#import "WriteSignatureVC.h"
#import "DXQCoreDataEntityBuilder.h"
#import "ImageFilterVC.h"
#import "UserLoadAlbumRequest.h"
#import "WaterFlowView.h"
#import "ImageViewCell.h"
#import "PhotoDetailVC.h"

#define TOP_IMAGE_HEIGHT  204.0f

@interface UserDetailInfoVC ()<WaterFlowViewDelegate,WaterFlowViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIScrollViewDelegate,UIActionSheetDelegate,UserInfoDetailRequestDelegate,SayHelloRequestDelegate,RelationMakeRequestDelegate,UserRemoveRelationDelegate,UniversalViewControlDelegate,UserReportUserRequestDelegate,UserLoadAlbumRequestDelegate>
{
    UserInfoDetailRequest *userInfoDetailRequest;//获取用户详细
    SayHelloRequest *sayHelloReqest;//打招呼
    RelationMakeRequest *relationMakeRequest;//建立关系
    UserRemoveRelation *userRemoveRelationRequest;//删除关系
    UserReportUserRequest *userReportUserRequest;//举报
    
    UserLoadAlbumRequest  *userLoadAlbumRequest;
    
    UILabel *noPhotoLabel;
    WaterFlowView *waterFlow;
    NSMutableArray *photoArray;

    BOOL isUserInfoDetailRequesting;
    BOOL isRequesting;
    
    BOOL isUserLoadAlbumRequesting;

    
    BOOL isInitLoading;
    BOOL isUserAccount;
    
    RelationType relationType;
    
    BOOL isUploadPhoto;
}

@property(nonatomic,retain)AboutTableViewDataSource *aboutTableViewDataSource;
@property(nonatomic,retain)ActivityTableViewDataSource *activityTableViewDataSource;
@property(nonatomic,retain)UITableView *aboutTableView;
@property(nonatomic,retain)UITableView *activityTableView;
@property(nonatomic,retain)UITextView *statusLbl;
@property(nonatomic,retain)UIImageView *topUserImageView;
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)NSMutableDictionary *userinfo;
@property(nonatomic,retain)BottomToolBar *bottomToolBar;
@property(nonatomic)BottomToolBarItemType selectedBottomToolBarItemType;
@property(nonatomic,retain)FansView *fansView;
@property(nonatomic,retain)WaterFlowView *waterFlow;
@property(nonatomic,retain)NSMutableArray *photoArray;
@property(nonatomic,retain)UILabel *noPhotoLabel;


@end

@implementation UserDetailInfoVC
@synthesize aboutTableViewDataSource = _aboutTableViewDataSource;
@synthesize activityTableViewDataSource = _activityTableViewDataSource;
@synthesize userinfo = _userinfo;
@synthesize scrollView = _scrollView;
@synthesize topUserImageView = _topUserImageView;
@synthesize statusLbl = _statusLbl;
@synthesize aboutTableView = _aboutTableView;
@synthesize activityTableView = _activityTableView;
@synthesize bottomToolBar = _bottomToolBar;
@synthesize selectedBottomToolBarItemType = _selectedBottomToolBarItemType;
@synthesize fansView=_fansView;
@synthesize photoArray = _photoArray;
@synthesize noPhotoLabel = _noPhotoLabel;
@synthesize waterFlow = _waterFlow;

-(void)dealloc
{
    [_noPhotoLabel release];_noPhotoLabel = nil;
    [_photoArray release];_photoArray = nil;
    [_waterFlow release];_waterFlow = nil;
    [_userinfo release];_userinfo = nil;
    [_aboutTableViewDataSource release];_aboutTableViewDataSource = nil;
    [_activityTableViewDataSource release];_activityTableViewDataSource = nil;
    [_bottomToolBar release];_bottomToolBar = nil;
    [_aboutTableView release];_aboutTableView = nil;
    [_activityTableView release];_activityTableView = nil;
    [_statusLbl release];_statusLbl = nil;
    [_scrollView release];_scrollView = nil;
    [_userinfo release];_userinfo = nil;
    [_topUserImageView release];_topUserImageView = nil;
    [_fansView release];_fansView=nil;
    [super dealloc];
}

-(void)viewDidUnload
{
    self.waterFlow = nil;
    
    self.noPhotoLabel = nil;

    self.bottomToolBar = nil;self.activityTableView = nil;
    
    self.statusLbl = nil;self.aboutTableView = nil;
    
    self.scrollView = nil;self.topUserImageView = nil;
    
    self.fansView=nil;
    [super dealloc];
}

- (id)initwithUserInfo:(NSDictionary *)item
{
    self = [super init];
    
    if (self)
    {
        isInitLoading = YES;
        
        _userinfo = [[NSMutableDictionary alloc]initWithDictionary:item];
        
        _activityTableViewDataSource = [[ActivityTableViewDataSource alloc]initWithDataList:nil viewControl:self];
        
        _aboutTableViewDataSource = [[AboutTableViewDataSource alloc]initWithViewControl:self];
        
        isUserAccount =  ([[_userinfo objectForKey:@"AccountId"] isEqualToString:[[SettingManager sharedSettingManager] loggedInAccount]]);
        
        _photoArray = [[NSMutableArray alloc]init];

    }
    return self;
}

-(BOOL)checkIsUpateUserInfo:(NSDate *)lastUpdateTime
{
    if (lastUpdateTime)
    {
        //时间差
        NSTimeInterval diff = fabs([[NSDate date] timeIntervalSinceDate:lastUpdateTime]);
        
        //24小时
        NSTimeInterval daySp = 86400;
        return (diff>=daySp);
    }
    return YES;
}

-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    CGFloat bottomToolBarHeight = 49.0f;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,rect.size.width,416-bottomToolBarHeight)];
	[self.view addSubview:_scrollView];
	_scrollView.delegate = self;
	_scrollView.alwaysBounceVertical = YES;
	[_scrollView setScrollEnabled:YES];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setPullToRefreshHandler:^{
        [self refreshStart];
    }];
    
    CGRect  topImageFrame = CGRectMake(0, 0, CGRectGetWidth(rect),TOP_IMAGE_HEIGHT);
    _topUserImageView = [[UIImageView alloc]initWithFrame:topImageFrame];
    _topUserImageView.clipsToBounds = YES;
    _topUserImageView.backgroundColor=[UIColor grayColor];
    [_topUserImageView setImage:[UIImage imageNamed:@"user_detail_topdefault.jpg"]];
    [_topUserImageView setContentMode:UIViewContentModeScaleAspectFit];
    [_scrollView addSubview:_topUserImageView];
   
    
    CGRect statusFrame = CGRectMake(0, TOP_IMAGE_HEIGHT, CGRectGetWidth(rect),0);
    _statusLbl = [[UITextView alloc]initWithFrame:statusFrame];
    [_statusLbl setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.3]];
    [_statusLbl setEditable:NO];
    [_statusLbl setContentInset:UIEdgeInsetsMake(4, 4, 4, 4)];
    [_statusLbl setUserInteractionEnabled:NO];
    [_statusLbl setTextColor:[UIColor whiteColor]];
    [_statusLbl setFont:NormalDefaultFont];
    [_scrollView addSubview:_statusLbl];
    
    FansView *fansView = [[FansView alloc]initWithFrame:CGRectMake(228, 100, 0.0, 0.0) target:self action:@selector(tapFanView:)];
    fansView.isFans=NO;
    fansView.tag = 999;
    fansView.hidden = YES;
    [_scrollView addSubview:fansView];
    self.fansView=fansView;
    [fansView release];
    
    //actionbar height
    CGFloat userActionToolBarHeight = 50.0f;
    NSArray *items = isUserAccount?USER_SELF_ACTION_ITEMS:USER_ACTION_ITEMS;
    UserActionToolBar *uaToolBar = [[UserActionToolBar alloc]initWithFrame:CGRectMake(0,TOP_IMAGE_HEIGHT,self.view.frame.size.width,userActionToolBarHeight) target:self action:@selector(tapUserActionToolBarItem:) items:items];
    uaToolBar.hidden = YES;
    uaToolBar.tag = 1000;
    [_scrollView addSubview:uaToolBar];
    [uaToolBar release];
    
    CGRect aboutTableViewFrame = CGRectMake(0,TOP_IMAGE_HEIGHT+userActionToolBarHeight,rect.size.width,0.0);
    _aboutTableView=[[UITableView alloc]initWithFrame:aboutTableViewFrame style:UITableViewStylePlain];
    [_aboutTableView setSeparatorColor:TABLEVIEW_SEPARATORCOLOR];
    _aboutTableView.backgroundColor=[UIColor whiteColor];
    _aboutTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _aboutTableView.delegate = _aboutTableViewDataSource;
    _aboutTableView.dataSource = _aboutTableViewDataSource;
    [_scrollView addSubview:_aboutTableView];

    _activityTableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.0f, self.view.frame.size.width,self.view.frame.size.height-49.f) style:UITableViewStylePlain];
    [_activityTableView setSeparatorColor:TABLEVIEW_SEPARATORCOLOR];
    _activityTableView.backgroundColor=[UIColor whiteColor];
    _activityTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [_activityTableView setHidden:YES];
    _activityTableView.delegate=_activityTableViewDataSource;
    _activityTableView.dataSource=_activityTableViewDataSource;
    [self.view addSubview:_activityTableView];
    
    _waterFlow = [[WaterFlowView alloc] initWithFrame:CGRectMake(0,0,320,416)];
    _waterFlow.waterFlowViewDelegate = self;
    _waterFlow.waterFlowViewDatasource = self;
    _waterFlow.delegate = self;
    _waterFlow.backgroundColor = [UIColor clearColor];
    [_waterFlow setHidden:YES];
    [_waterFlow setPullToRefreshHandler:^{
        [self refreshPhoto];
    }];
    [self.view addSubview:_waterFlow];
    
    _noPhotoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,150, self.view.frame.size.width, 44)];
    [_noPhotoLabel setHidden:YES];
    [_noPhotoLabel setBackgroundColor:[UIColor clearColor]];
    [_noPhotoLabel setTextColor:[UIColor grayColor]];
    [_noPhotoLabel setTextAlignment:UITextAlignmentCenter];
    [_noPhotoLabel setText:AppLocalizedString(@"用户还未上传图片")];
    [self.view addSubview:_noPhotoLabel];
    
    _bottomToolBar=[[BottomToolBar alloc]initWithFrame:CGRectMake(0.f, self.view.frame.size.height-49.f, self.view.frame.size.width, bottomToolBarHeight)];
    _bottomToolBar.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [_bottomToolBar addTarget:self action:@selector(bottomToolBarSelectedItemChange:) forControlEvents:UIControlEventValueChanged];
    _bottomToolBar.selectIndex=0;
    _bottomToolBar.hidden = YES;
    _selectedBottomToolBarItemType = BottomToolBarItemTypeAbout;
    [self.view addSubview:_bottomToolBar];
}

- (void)viewDidLoad
{
    [self setNavgationTitle:[_userinfo objectForKey:@"MemberName"] backItemTitle:AppLocalizedString(@"返回")];
    
    UIImage *bgImage;
    UIImage *image;
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    if (isUserAccount)
    {
        bgImage=[UIImage imageNamed:@"btn_round"];
        image=[UIImage imageNamed:@"nav_menu_icon"];
        image=[UIImage imageWithCGImage:image.CGImage scale:2. orientation:UIImageOrientationUp];
        [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showleft) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
        [btn sizeToFit];
        self.navigationItem.leftBarButtonItem=leftItem;
        [leftItem release];
        
       btn=[UIButton buttonWithType:UIButtonTypeCustom];
       [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
       [btn sizeToFit];
        [btn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:AppLocalizedString(@"编辑") forState:UIControlStateNormal];
        [btn.titleLabel setFont:MiddleBoldDefaultFont];
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem=rightItem;
        [rightItem release];
        
        [_statusLbl setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(writeSignature:)];
        [_statusLbl addGestureRecognizer:tap];
        [tap release];
    }
    else
    {
        bgImage=[UIImage imageNamed:@"btn_round"];
        image=[UIImage imageNamed:@"pyq_nav_r_chat"];
        [btn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(startChat:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem=rightItem;
        [rightItem release];
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    if (isInitLoading)
    {
        isInitLoading = NO;
        DXQAccount *currentUser = [[DXQCoreDataManager sharedCoreDataManager]getAccountByAccountID:[_userinfo objectForKey:@"AccountId"]];
        BOOL isUpateUserInfo = (currentUser == nil)?YES:[self checkIsUpateUserInfo:currentUser.dxq_LastUpdateTime];
        if (isUpateUserInfo)
        {
            [_scrollView performSelector:@selector(pullToRefresh) withObject:nil afterDelay:0.1];
        }
        else
        {
            [self refreshUI];
        }
    }
    [super viewDidAppear:animated];
}

-(void)layoutSubView
{
    CGRect aboutTableViewFrame = _aboutTableView.frame;
    aboutTableViewFrame.size.height = _aboutTableView.contentSize.height;
    _aboutTableView.frame = aboutTableViewFrame;
    CGFloat height_ = _aboutTableView.contentSize.height+aboutTableViewFrame.origin.y;
    _scrollView.contentSize = CGSizeMake(0.0f, height_);
}

-(void)refreshUI
{
    //刷新UI上的数据
    DXQAccount *currentUser = [[DXQCoreDataManager sharedCoreDataManager]getAccountByAccountID:[_userinfo objectForKey:@"AccountId"]];

    HYLog(@"c---->%@",[[_userinfo objectForKey:@"IsBlackList"] class]);
    UserActionToolBar *toolBar =   (UserActionToolBar*)[_scrollView viewWithTag:1000];
    toolBar.hidden = NO;
    if (!isUserAccount)
    {
       [_userinfo setObject:(currentUser&&currentUser.dxq_IsBlackList)?currentUser.dxq_IsBlackList:@"0" forKey:@"IsBlackList"];
        
        [_userinfo setObject:(currentUser&&currentUser.dxq_IsFriend)?currentUser.dxq_IsFriend:@"0" forKey:@"IsFriend"];
       UILabel *friendLbl = (UILabel*)[[toolBar viewWithTag:4] viewWithTag:1];
       friendLbl.text = (currentUser && [currentUser.dxq_IsFriend intValue] == 0)?AppLocalizedString(@"加好友"):AppLocalizedString(@"删除好友");
    }
    
    FansView *fansView = (FansView *)[_scrollView viewWithTag:999];
    [fansView setFansCount:[currentUser.dxq_LinkmeCount intValue]];
    
    [fansView setIsFans:[currentUser.dxq_IsMylink boolValue]];

    self.fansView.hidden = NO;
    _bottomToolBar.hidden = NO;
    
    //标题
    self.navigationItem.title = currentUser.dxq_MemberName;
    
    //顶部图片
    NSString *picurl = [NSString stringWithFormat:@"%@",currentUser.dxq_PhotoUrl];
    if (picurl && [picurl isKindOfClass:[NSString class]] && [picurl length]>0)
    {
        [_topUserImageView setImageWithURL:[NSURL URLWithString:picurl] placeholderImage:[UIImage imageNamed:@"user_detail_topdefault.jpg"] success:^(UIImage *image,BOOL iscached){[self showTopImage:image];} failure:nil];
    }
    else
    {
        [_topUserImageView setImage:[UIImage imageNamed:@"user_detail_topdefault.jpg"]];
    }
    
    //更新用户签名
    NSString *statusString = currentUser.dxq_Introduction;
    if (!statusString || [statusString isEqual:[NSNull null]]  || [statusString length]<1 )
    {
        if (isUserAccount)
        {
            statusString = AppLocalizedString(@"点击这里输入签名");
        }
        else{
            statusString = AppLocalizedString(@"这家伙很懒...");
        }
    }
    else
    {
        if (isUserAccount)
        {
            //通知刷新菜单左边的control
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONCENTER_MENU_LEFTCONTROL_REFRESH object:nil userInfo:nil];            
        }
        statusString = [Tool decodeBase64:statusString];
    }
    [_statusLbl setText:statusString];
    CGRect statusFrame = _statusLbl.frame;
    _statusLbl.scrollEnabled = NO;
    statusFrame.size.height = _statusLbl.contentSize.height;
    statusFrame.origin.y = TOP_IMAGE_HEIGHT -  _statusLbl.contentSize.height;
    _statusLbl.frame = statusFrame;

    //更新用户信息和礼物
    [_aboutTableViewDataSource reloadData:[_userinfo objectForKey:@"AccountId"]];
    [_aboutTableView reloadData];
    [self layoutSubView];
}

-(void)writeSignature:(UIGestureRecognizer *)g
{
    WriteSignatureVC *vc = [[WriteSignatureVC alloc]init];
    vc.vDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}


-(void)editAction:(UIButton *)btn
{    
     EditUserInfoVC *vc = [[EditUserInfoVC alloc]initWithDelegate:self];
     CustonNavigationController *nav = [[CustonNavigationController alloc]initWithRootViewController:vc];
     [[AppDelegate sharedAppDelegate].menuController presentModalViewController:nav animated:YES];
     [vc release];
     [nav release];    
}

#pragma mark
#pragma UniversalViewControlDelegate Methord
-(void)didCancelViewViewController
{
    [[AppDelegate sharedAppDelegate].menuController  dismissModalViewControllerAnimated:YES];
}

-(void)didFinishedAction:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[WriteSignatureVC class]])
    {
        DXQAccount *account = [[DXQCoreDataManager sharedCoreDataManager]getCurrentLoggedInAccount];
        [_userinfo setObject:account.dxq_Introduction forKey:@"Introduction"];
        [self refreshUI];
    }
    if ([viewController isKindOfClass:[EditUserInfoVC class]])
    {
        [_scrollView performSelector:@selector(pullToRefresh) withObject:nil afterDelay:0.1];
        [self didCancelViewViewController];
    }
    if ([viewController isKindOfClass:[ImageFilterVC class]])
    {
        [self refreshUI];
    }
    else
    {
        [self didCancelViewViewController];
    }
}

#pragma mark -Request
//取消所有的请求 可以再返回的时候 调用这个函数
-(void)cancelAllRequest
{
    if (relationMakeRequest)[relationMakeRequest cancel];
    if (userRemoveRelationRequest)[userRemoveRelationRequest cancel];
    if (sayHelloReqest)[sayHelloReqest cancel];
    if (userInfoDetailRequest)[userInfoDetailRequest cancel];
}

-(void)refreshStart
{
    [self userInfoDetailRequest];
}

//获取页面用户信息
-(void)userInfoDetailRequest
{
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
    [parametersDic setObject:[[SettingManager sharedSettingManager]loggedInAccount] forKey:@"AccountFrom"];
    [parametersDic setObject:[_userinfo objectForKey:@"AccountId"] forKey:@"AccountId"];
    isUserInfoDetailRequesting = YES;
    userInfoDetailRequest = [[UserInfoDetailRequest alloc] initRequestWithDic:parametersDic];
    userInfoDetailRequest.delegate = self;
    [userInfoDetailRequest startAsynchronous];
}

#pragma userInfoDetailRequest Methord
-(void)userInfoDetailRequestDidFinishedWithParamters:(NSDictionary *)result
{
    if (result && [result isKindOfClass:[NSDictionary class]] &&[result count]>0)
    {
        NSString *AccountId = [_userinfo objectForKey:@"AccountId"];
        [_userinfo removeAllObjects];

        //数据配置到userinfo字典中
        [_userinfo addEntriesFromDictionary:[result objectForKey:@"Info"]];
        [_userinfo setObject:AccountId forKey:@"AccountId"];
        NSArray *items = [result objectForKey:@"Items"];
        [_userinfo setObject:items forKey:@"Items"];
        
        //以字符串的方式保存到数据库
        NSDictionary *itemsDict = [NSDictionary dictionaryWithObject:items forKey:@"Items"];
        NSString * jsonString = [[NSString alloc] initWithString:[itemsDict JSONRepresentation]];
        [_userinfo setObject:jsonString forKey:@"ReceivedGifts"];
        [jsonString release];
        
        //save
        [[DXQCoreDataEntityBuilder sharedCoreDataEntityBuilder]buildAccountWitdDictionary:_userinfo accountPassword:nil];
        [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
        
        [self refreshUI];
    }
    [self finishedUserInfoDetailRequestSuccessed:YES withMessage:nil];
}

-(void)userInfoDetailRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    [self finishedUserInfoDetailRequestSuccessed:NO withMessage:nil];
}

-(void)finishedUserInfoDetailRequestSuccessed:(BOOL)isSuccessed withMessage:(NSString *)msg
{
    if (isSuccessed)
    {
        [[ProgressHUD sharedProgressHUD]hide];
    }
    else
    {
        [[ProgressHUD sharedProgressHUD]setText:msg];
        [[ProgressHUD sharedProgressHUD]done:NO];
    }
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.scrollView refreshFinished];
                   });
    isUserInfoDetailRequesting = NO;
    userInfoDetailRequest.delegate = nil,
    [userInfoDetailRequest release];
    userInfoDetailRequest = nil;
}

-(void)setSelectedBottomToolBarItemType:(BottomToolBarItemType)selectedBottomToolBarItemType
{
    if (selectedBottomToolBarItemType == _selectedBottomToolBarItemType)
    {
        return;
    }
    _selectedBottomToolBarItemType = selectedBottomToolBarItemType;
    
    switch (selectedBottomToolBarItemType)
    {
        case BottomToolBarItemTypeAbout:
            [_waterFlow setHidden:YES];
            [_activityTableView setHidden:YES];
            [_scrollView setHidden:NO];
            [_noPhotoLabel setHidden:YES];
            break;
        case BottomToolBarItemTypeActivity:
            [_waterFlow setHidden:YES];
            [_activityTableView setHidden:NO];
            [_scrollView setHidden:YES];
            [_noPhotoLabel setHidden:YES];
            break;
        case BottomToolBarItemTypePhotos:
            [_waterFlow setHidden:NO];
            [_activityTableView setHidden:YES];
            [_scrollView setHidden:YES];
            if ([_photoArray count]<1)
            {
                [_waterFlow pullToRefresh];
                [_noPhotoLabel setHidden:NO];
            }
            else
            { [_noPhotoLabel setHidden:YES];}
            break;
        default:
            break;
    }
    HYLog(@"%d",_selectedBottomToolBarItemType);
}

-(void)bottomToolBarSelectedItemChange:(BottomToolBar *)bottomToolBar
{
    self.selectedBottomToolBarItemType = bottomToolBar.selectIndex;
}

//ActionToolBar
-(void)tapUserActionToolBarItem:(UITapGestureRecognizer *)tap
{
    UIButtonUserInfoAction *toolbaritem = (UIButtonUserInfoAction *)tap.view;
    if (isUserAccount)
    {
        switch (toolbaritem.tag)
        {
            case 1:
                [self editAction:nil];
                break;
            case 2:
                [self editAvatar];
                break;
            case 3:
                [self uploadPhotoes];
                break;
            case 4:
                [self writeSignature:nil];
                break;
            default:
                break;
        }
    }
    else
    {
        switch (toolbaritem.tag)
        {
            case UIButtonUserInfoActionTypeGifts:
                [self sendGifts];
                break;
            case UIButtonUserInfoActionTypeChat:
                [self startChat:nil];
                break;
            case UIButtonUserInfoActionTypeAloha:
                [self sendAloha];
                break;
            case UIButtonUserInfoActionTypeAddNewFriend:
                [self addNewFriend];
                break;
            case UIButtonUserInfoActionTypeMore:
                [self actionMore];
                break;
            default:
                break;
        }
    }
    HYLog(@"%d",toolbaritem.tag);
}

-(void)tapFanView:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 1)
    {
        if ([[_userinfo objectForKey:@"IsMylink"] intValue] == 0)
        {
            [self handleCreateUserRelationWithType:RelationTypeFans];
        }
        else
        {
            [self handleRemoveUserRelationWithType:RelationTypeFans];
        }
    }
    else  if (tap.view.tag == 2)
    {        
        FansListVC *vc =  [[FansListVC alloc]initWithAccountID:[_userinfo objectForKey:@"AccountId"]];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }    
}

-(void)showUIActionSheet:(NSInteger)tag
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:AppLocalizedString(@"取消") destructiveButtonTitle:nil otherButtonTitles:AppLocalizedString(@"拍照"),AppLocalizedString(@"从相册选择"), nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    sheet.tag = tag;
    [sheet showInView:self.navigationController.view];
    [sheet release];
}

//修改头像
-(void)editAvatar
{
    isUploadPhoto = NO;
    [self showUIActionSheet:1];
}

//上传照片
-(void)uploadPhotoes
{
    isUploadPhoto = YES;
    [self showUIActionSheet:2];
}

-(void)openPhotoLibrary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

//take a photo from camera
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *picker = [[UIImagePickerController alloc] init];
		picker.delegate = self;
		picker.allowsEditing = YES;
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"设备不支持拍照" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSAssert(image != nil, @"Can't get the image!");
	if (image)
	{
        [self performSelector:@selector(showImageFilter:) withObject:image afterDelay:0.5];
    }
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)showImageFilter:(UIImage *)image
{
    NSString *type = isUploadPhoto?@"2":@"1";
    ImageFilterVC *vc = [[ImageFilterVC alloc]initWithImage:image type:type];
    CustonNavigationController *nav = [[CustonNavigationController alloc]initWithRootViewController:vc];
    vc.vDelegate = self;
    [[AppDelegate sharedAppDelegate].menuController presentModalViewController:nav animated:YES];
    [vc release];
    [nav release];
}

//送礼
-(void)sendGifts
{
    if ([[_userinfo objectForKey:@"IsBlackList"] intValue] == 1)
    {
       return [Tool showAlertWithTitle:AppLocalizedString(@"该用户在黑名单,无法给Ta送礼") msg:nil];
    }
    SendGiftsVC *vc=[[SendGiftsVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

//聊天
-(void)startChat:(UIButton *)sender
{
    if ([[_userinfo objectForKey:@"IsBlackList"] intValue] == 1)
    {
        return [Tool showAlertWithTitle:AppLocalizedString(@"该用户在黑名单,无法给Ta发信息") msg:nil];
    }
    ChatVC *vc=[[ChatVC alloc]initWithInfo:_userinfo];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

//打招呼
-(void)sendAloha
{
    if ([[_userinfo objectForKey:@"IsBlackList"] intValue] == 1)
    {
        return [Tool showAlertWithTitle:AppLocalizedString(@"该用户在黑名单,不能和Ta打招呼") msg:nil];
    }
    if (isRequesting)return;
    isRequesting = YES;
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理...")];
    [[ProgressHUD sharedProgressHUD]showInView:self.navigationController.view];
    sayHelloReqest=[[SayHelloRequest alloc]initRequestWithDic:
                    [NSDictionary dictionaryWithObjectsAndKeys:[[SettingManager sharedSettingManager]loggedInAccount],@"AccountFrom",
                     [_userinfo objectForKey:@"AccountId"],@"AccountTo", nil]];
    sayHelloReqest.delegate=self;
    [sayHelloReqest startAsynchronous];
}

#pragma SayHelloRequestDelegate Methord
-(void)sayHelloRequestDidFinishedWithParamters:(NSDictionary *)dic
{
    isRequesting = NO;    
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"打招呼成功!")];
    [[ProgressHUD sharedProgressHUD]done];
    [sayHelloReqest release];
    sayHelloReqest=nil;
}

-(void)sayHelloRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    isRequesting = NO;
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"打招呼失败!")];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [sayHelloReqest release];
    sayHelloReqest=nil;
}

//加好友
-(void)addNewFriend
{
    if ([[_userinfo objectForKey:@"IsBlackList"] intValue] == 1)
    {
        return [Tool showAlertWithTitle:AppLocalizedString(@"该用户在黑名单,请先删除黑名单再添加Ta为好友") msg:nil];
    }
    if ([[_userinfo objectForKey:@"IsFriend"] intValue] == 0)
    {
        [self handleCreateUserRelationWithType:RelationTypeHiddenFriend];
    }
    else
    {
        [self handleRemoveUserRelationWithType:RelationTypeHiddenFriend];
    }
}

//更多
-(void)actionMore
{
    NSString *blackString = ([_userinfo objectForKey:@"IsBlackList"] && [[_userinfo objectForKey:@"IsBlackList"] intValue] == 0)?AppLocalizedString(@"加入黑名单"):AppLocalizedString(@"取消黑名单");
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:AppLocalizedString(@"取消") destructiveButtonTitle:nil otherButtonTitles:AppLocalizedString(@"举报个人资料不当"),blackString, nil];
    sheet.tag = 3;
    [sheet showInView:self.navigationController.view];
    [sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    else if( actionSheet.tag ==2 || actionSheet.tag ==1)
    {
        if(buttonIndex == 1)
        {
            [self performSelector:@selector(openPhotoLibrary) withObject:nil afterDelay:0.0];
        }
        else
        {
            [self performSelector:@selector(takePhoto) withObject:nil afterDelay:0.0];
        }
    }
    else if(buttonIndex == 0 && actionSheet.tag ==3)
    {
        [self performSelector:@selector(reportUser) withObject:nil afterDelay:0.0];
    }
    else if(buttonIndex == 1&& actionSheet.tag ==3)
    {
        [self performSelector:@selector(addBlackList) withObject:nil afterDelay:0.0];
    }
}

//举报
-(void)reportUser
{
    if (isRequesting)return;
    isRequesting = YES;
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理...")];
    [[ProgressHUD sharedProgressHUD]showInView:self.navigationController.view];
    userReportUserRequest=[[UserReportUserRequest alloc]initRequestWithDic:
                    [NSDictionary dictionaryWithObjectsAndKeys:[[SettingManager sharedSettingManager]loggedInAccount],@"AccountFrom",
                     [_userinfo objectForKey:@"AccountId"],@"AccountTo", nil]];
    userReportUserRequest.delegate=self;
    [userReportUserRequest startAsynchronous];
}

#pragma UserReportUserRequestDelegate methord
-(void)userReportUserRequestDidFinishedWithParamters:(NSDictionary *)dic
{
    isRequesting = NO;
    [userReportUserRequest release];
    userReportUserRequest=nil;
    [[ProgressHUD sharedProgressHUD] hide];
    [Tool showAlertWithTitle:AppLocalizedString(@"举报成功") msg:nil];
}

-(void)userReportUserRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    isRequesting = NO;
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"举报失败，请稍后再试!")];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [userReportUserRequest release];
    userReportUserRequest=nil;
}


//加入黑名单
-(void)addBlackList
{
    if ([[_userinfo objectForKey:@"IsBlackList"] intValue] == 0)
    {
        [self handleCreateUserRelationWithType:RelationTypeBlack];
    }
    else
    {
        [self handleRemoveUserRelationWithType:RelationTypeBlack];
    }
}


//处理用户关系后的提示
-(void)showRelationMakeRequestTipWords:(BOOL)success methordsCreate:(BOOL)iscreate words:(NSString *)words
{
    isRequesting = NO;
    NSString *reloationWords = @"";
    NSString *handleWords = iscreate?@"添加":@"删除";
    switch (relationType)
    {
        case RelationTypeHiddenFriend:
            reloationWords =  AppLocalizedString(@"好友");
            break;
        case RelationTypeHiddenFans:
            reloationWords =  AppLocalizedString(@"暗恋");
            break;
        case RelationTypeBlack:
            reloationWords =  AppLocalizedString(@"黑名单");
            break;
        case RelationTypeFans:
            reloationWords =  AppLocalizedString(@"关注");
            break;
        default:
            break;
    }
    NSString *showTipWords = [NSString stringWithFormat:@"%@%@%@%@!",handleWords,reloationWords,success?@"成功":@"失败",words];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(showTipWords)];
    [[ProgressHUD sharedProgressHUD]done:success];
}

//处理用户关系后数据处理
-(void)finishedHandleRelation:(NSString *)success
{
    if (relationType == RelationTypeHiddenFriend)
    {
        [_userinfo setObject:success forKey:@"IsFriend"];
        DXQAccount *user = [[DXQCoreDataManager sharedCoreDataManager]getAccountByAccountID:[_userinfo objectForKey:@"AccountId"]];
        user.dxq_IsFriend = success;
        [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
        [self refreshUI];
    }
    else if (relationType == RelationTypeBlack)
    {
        [_userinfo setObject:success forKey:@"IsBlackList"];
        DXQAccount *user = [[DXQCoreDataManager sharedCoreDataManager]getAccountByAccountID:[_userinfo objectForKey:@"AccountId"]];
        user.dxq_IsBlackList = success;
        [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
    }
    else if (relationType == RelationTypeFans)
    {
        [_userinfo setObject:success forKey:@"IsMylink"];
        DXQAccount *user = [[DXQCoreDataManager sharedCoreDataManager]getAccountByAccountID:[_userinfo objectForKey:@"AccountId"]];
        NSInteger fans = [user.dxq_LinkmeCount intValue];
        if ([success intValue]==0)
            fans --;
        else
            fans ++;
        if (fans<0)fans = 0;
        user.dxq_LinkmeCount = [NSString stringWithFormat:@"%d",fans];
        user.dxq_IsMylink = success;
        [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
        [self refreshUI];
    }
}

//添加用户关系
//-1黑名单，0关注，1暗恋，2好友
-(void)handleCreateUserRelationWithType:(RelationType)type
{
    if (isRequesting)return;
    isRequesting = YES;
    relationType = type;
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理...")];
    [[ProgressHUD sharedProgressHUD]showInView:self.navigationController.view];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[SettingManager sharedSettingManager]loggedInAccount],@"AccountFrom",
                       [_userinfo objectForKey:@"AccountId"],@"AccountTo",
                       [NSString stringWithFormat:@"%d",relationType],@"Relation", nil];
    relationMakeRequest=[[RelationMakeRequest alloc]initRequestWithDic:dic];
    relationMakeRequest.delegate=self;
    [relationMakeRequest startAsynchronous];
}

#pragma RelationMakeRequestDelegate methord
-(void)relationMakeRequestDidFinishedWithParamters:(NSDictionary *)dic
{
    [self finishedHandleRelation:@"1"];
    [self showRelationMakeRequestTipWords:YES methordsCreate:YES words:@""];
    [relationMakeRequest release];relationMakeRequest = nil;
}

-(void)relationMakeRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    [self showRelationMakeRequestTipWords:NO methordsCreate:YES words:[NSString stringWithFormat:@",%@",errorMsg]];
    [relationMakeRequest release];relationMakeRequest = nil;
}

//删除用户关系
//-1黑名单，0关注，1暗恋，2好友
-(void)handleRemoveUserRelationWithType:(RelationType)type
{
    if (isRequesting)return;
    isRequesting = YES;
    relationType = type;
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理...")];
    [[ProgressHUD sharedProgressHUD]showInView:self.navigationController.view];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[SettingManager sharedSettingManager]loggedInAccount],@"AccountFrom",
                       [_userinfo objectForKey:@"AccountId"],@"AccountTo",
                       [NSString stringWithFormat:@"%d",type],@"Relation", nil];
    userRemoveRelationRequest=[[UserRemoveRelation alloc]initRequestWithDic:dic];
    userRemoveRelationRequest.delegate=self;
    [userRemoveRelationRequest startAsynchronous];
}

#pragma UserRemoveRelationDelegate methord
-(void)userRemoveRelationDidFinishedWithParamters:(NSDictionary *)dic
{
    [self finishedHandleRelation:@"0"];
    [self showRelationMakeRequestTipWords:YES methordsCreate:NO words:@""];
    [userRemoveRelationRequest release];userRemoveRelationRequest = nil;
}

-(void)userRemoveRelationDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    [self showRelationMakeRequestTipWords:NO methordsCreate:NO words:[NSString stringWithFormat:@",%@",errorMsg]];
    [userRemoveRelationRequest release];userRemoveRelationRequest = nil;
}

#pragma mark -GetUserActivityRequestDelegate
-(void)userActivityRequestDidFinishedWithParamters:(NSArray *)activityList
{
    HYLog(@"Function %s",__FUNCTION__);

    _activityTableViewDataSource.data=activityList;
    [_activityTableView reloadData];
    [[ProgressHUD sharedProgressHUD]hide];
    [[self activityTableView]refreshFinished];
}

-(void)userActivityRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    HYLog(@"Function %s",__FUNCTION__);
    HYLog(@"error msg %@",errorMsg);
    [[ProgressHUD sharedProgressHUD]setText:errorMsg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [[self activityTableView]refreshFinished];
}

-(void)refreshPhoto
{
    if (isUserLoadAlbumRequesting) {
        return;
    }
    isUserLoadAlbumRequesting = YES;
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [_userinfo objectForKey:@"AccountId"],@"AccountId", nil];
    userLoadAlbumRequest = [[UserLoadAlbumRequest alloc]initRequestWithDic:dic];
    userLoadAlbumRequest.delegate=self;
    [userLoadAlbumRequest startAsynchronous];
}

-(void)userLoadAlbumRequestDidFinishedWithParamters:(id)result
{
    NSArray *arr = (NSArray *)result;
    _noPhotoLabel.hidden = NO;
    if (arr &&[arr isKindOfClass:[NSArray class]]&&[arr count]>0)
    {
        _noPhotoLabel.hidden = YES;
        [_photoArray removeAllObjects];
        [_photoArray addObjectsFromArray:arr];
        [_waterFlow reloadData];
    }
    isUserLoadAlbumRequesting = NO;
    [_waterFlow refreshFinished];
    [userLoadAlbumRequest release];
    userLoadAlbumRequest = nil;
}

-(void)userLoadAlbumRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    isUserLoadAlbumRequesting = NO;
    [_waterFlow refreshFinished];
    [userLoadAlbumRequest release];
    userLoadAlbumRequest = nil;
}

#pragma mark WaterFlowViewDataSource
- (NSInteger)numberOfColumsInWaterFlowView:(WaterFlowView *)waterFlowView
{
    return 4;
}

- (NSInteger)numberOfAllWaterFlowView:(WaterFlowView *)waterFlowView{
    
    return [_photoArray count];
}

- (UIView *)waterFlowView:(WaterFlowView *)waterFlowView cellForRowAtIndexPath:(IndexPath *)indexPath
{
    ImageViewCell *view = [[ImageViewCell alloc] initWithIdentifier:nil];
    return view;
}

-(void)waterFlowView:(WaterFlowView *)waterFlowView  relayoutCellSubview:(UIView *)view withIndexPath:(IndexPath *)indexPath
{
    int arrIndex = indexPath.row * waterFlowView.columnCount + indexPath.column;
    NSDictionary *item = [_photoArray objectAtIndex:arrIndex];
    ImageViewCell *imageViewCell = (ImageViewCell *)view;
    imageViewCell.indexPath = indexPath;
    imageViewCell.columnCount = waterFlowView.columnCount;
    [imageViewCell relayoutViews];
    NSString *imageUrl = [item objectForKey:@"FilePath"];
    if (imageUrl&&[imageUrl length]>0)
    {
        NSString *picurl = [NSString stringWithFormat:@"%@%@",imageUrl,THUMB_IMAGE_SUFFIX];        
        NSURL *URL = [NSURL URLWithString:picurl];
        [(ImageViewCell *)view setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"tx_gray.png"] ];
    }
    else
    {
        [(ImageViewCell *)view setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"tx_gray.png"]];
    }
}

#pragma mark WaterFlowViewDelegate
- (CGFloat)waterFlowView:(WaterFlowView *)waterFlowView heightForRowAtIndexPath:(IndexPath *)indexPath
{
    int arrIndex = indexPath.row * waterFlowView.columnCount + indexPath.column;
    NSDictionary *dict = [_photoArray objectAtIndex:arrIndex];
    float width = 0.0f;
    float height = 0.0f;
    if (dict)
    {
        NSObject *width_ = [dict objectForKey:@"width"];
        if (width_ && ![width_ isKindOfClass:[NSNull class]] && [width_ isKindOfClass:[NSString class]])
        {
            width = [(NSString*)width_ floatValue];
        }
        else
        {
            width = 100;
        }
        
        NSObject *height_ = [dict objectForKey:@"height"];
        if (height_ && ![height_ isKindOfClass:[NSNull class]] && [height_ isKindOfClass:[NSString class]])
        {
            height = [(NSString*)height_ floatValue];
        }
        else
        {
            height = 100;
        }
    }
    return waterFlowView.cellWidth * (height/width);
}

- (void)waterFlowView:(WaterFlowView *)waterFlowView didSelectRowAtIndexPath:(IndexPath *)indexPath
{
    NSLog(@"indexpath row == %d,column == %d",indexPath.row,indexPath.column);
    int arrIndex = indexPath.row * waterFlowView.columnCount + indexPath.column;
    NSLog(@"%d",arrIndex);
    NSDictionary *item = [_photoArray objectAtIndex:arrIndex];
    NSLog(@"item --- >%@",item);
    [_userinfo setObject:item forKey:@"uploadphotourl"];
    PhotoDetailVC *vc = [[PhotoDetailVC alloc]initWithUserInfo:_userinfo];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}



- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)showTopImage:(UIImage *)image
{
    if(!image)return;
    CGFloat topImageHeight = 204.0f;
    CGFloat imageWidth = 320.0f;
    CGSize resultImgSize = [Tool getFitSizeFromCGSize:image.size withMaxWidth:imageWidth withMaxHeight:topImageHeight];
    if (CGSizeEqualToSize(CGSizeZero, resultImgSize))
    {
        [_topUserImageView setImage:[UIImage imageNamed:@"user_detail_topdefault.jpg"]];
        return;
    }
    CGFloat rwidth = resultImgSize.width;
    CGFloat rheight = resultImgSize.height;
    if (rwidth < imageWidth)
    {
        resultImgSize.width = imageWidth;
        resultImgSize.height = imageWidth*rheight/rwidth;
    }
    UIImage *scaleImg = [self scaleFromImage:image toSize:resultImgSize];
    CGRect rect =  CGRectMake(0, 0, imageWidth, topImageHeight);
    CGImageRef cgimgref = CGImageCreateWithImageInRect([scaleImg CGImage], rect);
    UIImage *cgimg = [UIImage imageWithCGImage:cgimgref];
    [_topUserImageView setImage:cgimg];
    CGImageRelease(cgimgref);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
