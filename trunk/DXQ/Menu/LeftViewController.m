//
//  LeftViewController.m
//  DXQ
//
//  Created by Yuan on 12-10-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "LeftViewController.h"
#import "CouponsCircleVC.h"
#import "DDMenuController.h"
#import "UIColor+ColorUtils.h"
#import "PPRevealSideViewController.h"
#import "SettingVC.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "UserDetailInfoVC.h"
#import "DXQAccount.h"
#import "BeautyContestViewController.h"
#import "BadgeView.h"
#import "ChatMessageCenter.h"
#import "ImageFilterVC.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UniversalViewControlDelegate>
{
    NSArray *dataSourceArray;
    BadgeView *numberView;
}

@property(nonatomic,retain)NSArray *dataSourceArray;
@property(nonatomic,strong)UITableView *tableView;

@end


@implementation LeftViewController
@synthesize tableView=_tableView;
@synthesize dataSourceArray = _dataSourceArray;

- (id)init
{
    self = [super init];
    if (self)
    {
        dataSourceArray = [[NSArray alloc]initWithArray:[[SettingManager sharedSettingManager] getLeftControlMenu]];
        //注册一个通知在切换用户的时候刷新左边菜单
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:NOTIFICATIONCENTER_MENU_LEFTCONTROL_REFRESH object:nil];
        //注册获取通知后刷新通知的提示数目 add note by Huang Xiu Yong
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotice:) name:NOTIFICATIONCENTER_RECEIED_NOTICE object:nil];
        _noticeBadgeValue=0;
        _chatMsgValue=0;
        [[ChatMessageCenter shareMessageCenter]addObserverForChatMessageNumberChange:self];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATIONCENTER_MENU_LEFTCONTROL_REFRESH object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATIONCENTER_RECEIED_NOTICE object:nil];
    [[ChatMessageCenter shareMessageCenter]removeObserverForChatMessageNumberChange:self];
    [_tableView release];_tableView = nil;
    [_dataSourceArray release];_dataSourceArray = nil;
    [numberView release];
    [super dealloc];
}

-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    UIImage *navImage = [UIImage imageNamed:@"left_nav_top.png"];
    CGRect  topNavFrame = CGRectMake(0, 0, navImage.size.width, navImage.size.height);
    UIView *topNav = [[UIView alloc]initWithFrame:topNavFrame];
    [topNav setBackgroundColor:[UIColor colorWithPatternImage:navImage]];
    [self.view addSubview:topNav];
    
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    UIButton *logoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoBtn setImage:logoImage forState:UIControlStateNormal];
    [logoBtn setUserInteractionEnabled:NO];
    [logoBtn setFrame:CGRectMake(0,navImage.size.height/2-logoImage.size.height/2,logoImage.size.width,logoImage.size.height)];
    [topNav addSubview:logoBtn];
    
    UIImage *takephotoImage = [UIImage imageNamed:@"left_top_camera.png"];
    UIButton *takephotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [takephotoBtn setImage:takephotoImage forState:UIControlStateNormal];
    [takephotoBtn setShowsTouchWhenHighlighted:YES];
    [takephotoBtn addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    [takephotoBtn setFrame:CGRectMake(180.0,navImage.size.height/2-takephotoImage.size.height/2,takephotoImage.size.width,takephotoImage.size.height)];
    [topNav addSubview:takephotoBtn];
    
    UIImage *toobarImage = [UIImage imageNamed:@"left_bottom_toolbar.png"];
    CGFloat margin_top = rect.size.height- STATUS_HEIGHT - toobarImage.size.height;
    CGFloat tableViewHeight = margin_top - navImage.size.height + STATUS_HEIGHT;
    CGRect  toolbarFrame = CGRectMake(0,margin_top,toobarImage.size.width,toobarImage.size.height);
    UIView *tooBar = [[UIView alloc]initWithFrame:toolbarFrame];
    [tooBar setBackgroundColor:[UIColor colorWithPatternImage:toobarImage]];

    UIImage *remindImage = [UIImage imageNamed:@"left_bottom_toolbar_remind.png"];
    UIButton *remindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [remindBtn setShowsTouchWhenHighlighted:YES];
    [remindBtn addTarget:self action:@selector(remindAction:) forControlEvents:UIControlEventTouchUpInside];
    [remindBtn setImage:remindImage forState:UIControlStateNormal];
    [remindBtn setFrame:CGRectMake(5.0,toobarImage.size.height/2-remindImage.size.height/2,remindImage.size.width,remindImage.size.height)];
    [tooBar addSubview:remindBtn];
    
    UIImage *settingImage = [UIImage imageNamed:@"left_bottom_toolbar_setting.png"];
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setShowsTouchWhenHighlighted:YES];
    [settingBtn addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setImage:settingImage forState:UIControlStateNormal];
    [settingBtn setFrame:CGRectMake(180.0,toobarImage.size.height/2-settingImage.size.height/2,settingImage.size.width,settingImage.size.height)];
    [tooBar addSubview:settingBtn];
    
    if (!numberView) {
        numberView=[[BadgeView alloc]initWithFrame:CGRectMake(35.f, 0.f, 0.f, 0.f)];
        numberView.userInteractionEnabled=NO;
        if (_noticeBadgeValue==0) {
            numberView.hidden=YES;
        }
    }
    numberView.number=_noticeBadgeValue;
    [tooBar addSubview:numberView];
    
    if (!_tableView)
    {
        rect.origin.y = navImage.size.height;
        rect.size.height = tableViewHeight;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
    
    [self.view addSubview:tooBar];

    [topNav release];
    [tooBar release];
    
}

-(void)reloadData
{
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)takePicture:(UIButton *)btn
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
    ImageFilterVC *vc = [[ImageFilterVC alloc]initWithImage:image type:@"2"];
    CustonNavigationController *nav = [[CustonNavigationController alloc]initWithRootViewController:vc];
    vc.vDelegate = self;
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
    if ([viewController isKindOfClass:[ImageFilterVC class]])
    {
        [self didCancelViewViewController];
    }
}


-(void)viewDidAppear:(BOOL)animated
{    
    [super viewDidAppear:animated];
}

-(void)remindAction:(UIButton *)sender
{
    self.noticeBadgeValue=0;
    [self didSelectControl:@"NoticeViewController"];
}

-(void)settingAction:(UIButton *)sender
{
    [self didSelectControl:@"SettingVC"];
}

-(void)mySelfInfo
{
    PPRevealSideViewController *menuController = [AppDelegate sharedAppDelegate].menuController;
    DXQAccount *account = [[DXQCoreDataManager sharedCoreDataManager]getCurrentLoggedInAccount];
    UserDetailInfoVC *controller=[[UserDetailInfoVC alloc]initwithUserInfo:[NSDictionary dictionaryWithObjectsAndKeys: account.dxq_MemberName,@"MemberName",account.dxq_AccountId,@"AccountId",account.dxq_Introduction,@"Introduction",account.dxq_PhotoUrl,@"PhotoUrl", nil]];
    CustonNavigationController *navController = [[CustonNavigationController alloc] initWithRootViewController:controller];
    [controller release];
    [menuController popViewControllerWithNewCenterController:navController animated:YES];
    [navController release];
}

-(void)friendCircleAction:(NSNumber*)actiontag
{
    switch ([actiontag intValue])
    {
        case 0:
            [self didSelectControl:@"NearByFriendsVC"];
            break;
        case 1:
            [self didSelectControl:@"MyFriendsVC"];
            [self setChatMsgValue:0];
            break;
        case 2:
            [self didSelectControl:@"DXQDatingVC"];
            break;
        default:
            break;
    }
}

-(void)couponsCircleAction:(NSNumber*)actiontag
{
    switch ([actiontag intValue])
    {
        case 0:
            [self didSelectControl:@"CouponsCircleVC"];
            break;
        case 1:
            [self didSelectControl:@"TicketViewController"];
            break;
        case 2:
            [self didSelectControl:@"TuanViewController"];
            break;
        case 3:
            [self didSelectControl:@"UserMemberViewController"];
            break;
        default:
            break;
    }
}

-(void)activityCircleAction:(NSNumber*)actiontag
{
    switch ([actiontag intValue])
    {
        case 0:
            [self didSelectControl:@"HotEventViewController"];
            break;
        case 1:
            [self didSelectControl:@"BeautyContestViewController"];
            break;
        case 2:
            [self didSelectControl:@"ShearPicViewController"];
            break;
        default:
            break;
    }
}


#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataSourceArray count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[dataSourceArray objectAtIndex:section] objectForKey:@"rows"] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    LeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
    {
        cell = [[LeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8,8, 30, 30)];
        iconImageView.tag = 1;
        iconImageView.layer.cornerRadius = 4.0f;
        iconImageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:iconImageView];
        [iconImageView release];
        
         UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(46,8,190, 30)];
        lbl.tag = 2;
        [lbl setFont:NormalBoldDefaultFont];
        [lbl setTextColor:[UIColor whiteColor]];
        [lbl setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:lbl];
        [lbl release];
        
        UIImage *image = [UIImage imageNamed:@"left_cell_bg.png"];
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,320,image.size.height)];
        [bgImageView setImage:image];
        [cell setBackgroundView:bgImageView];
        [bgImageView release];
    }
    NSDictionary *item = [[[dataSourceArray objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row];
    UIImageView *iconImageView =(UIImageView *)[cell.contentView viewWithTag:1];
    UILabel *lbl =(UILabel *)[cell.contentView viewWithTag:2];
    if (indexPath.section == 0  && indexPath.row == 0)
    {
        cell.imageView.image = nil;
        cell.textLabel.text = @"";        
        [iconImageView setHidden:NO];
        [lbl setHidden:NO];
        
        DXQAccount *account = [[DXQCoreDataManager sharedCoreDataManager]getCurrentLoggedInAccount];
        if (account.dxq_PhotoUrl && [account.dxq_PhotoUrl length]>0)
        {
            [iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@.thumb.jpg",account.dxq_PhotoUrl]] placeholderImage:[UIImage imageNamed:@"tx_gray.png"]];
        }
        else
            [iconImageView setImage:[UIImage imageNamed:@"tx_gray.png"]];
        lbl.text = account.dxq_MemberName;
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:[item objectForKey:@"image"]];
        cell.textLabel.text = [item objectForKey:@"title"];

        [iconImageView setHidden:YES];
        [lbl setHidden:YES];
        [iconImageView setImage:nil];
        lbl.text = @"";
    }
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    cell.textLabel.textColor = [UIColor colorWithString:@"#605D58"];
    if (indexPath.section==1&&indexPath.row==3) {
        cell.badgeNumber=_chatMsgValue;
    }else
        cell.badgeNumber=0;
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{    
    UIView *headerView = [[[UIView alloc]initWithFrame:CGRectZero] autorelease];
    UIImage *bgImage = [UIImage imageNamed:[[dataSourceArray objectAtIndex:section] objectForKey:@"sectionbg"]];
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:bgImage];
    [bgImageView setFrame:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    [headerView addSubview:bgImageView];
    [bgImageView release];
    
    UILabel *topHeaderTipLabel = [[UILabel alloc]initWithFrame:CGRectMake(5.0f,0.0f, 260.0f,23.0f)];
    [topHeaderTipLabel setShadowColor:[UIColor grayColor]];
    [topHeaderTipLabel setShadowOffset:CGSizeMake(0,-1)];
    [topHeaderTipLabel setNumberOfLines:1];
    [topHeaderTipLabel setTextColor:[UIColor whiteColor]];
    [topHeaderTipLabel setBackgroundColor:[UIColor clearColor]];
    [topHeaderTipLabel setText:[[dataSourceArray objectAtIndex:section] objectForKey:@"sectiontitle"]];
    
    [headerView addSubview:topHeaderTipLabel];
    [topHeaderTipLabel release];
       
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 23.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *actionString = [[dataSourceArray objectAtIndex:indexPath.section] objectForKey:@"sectionaction"];
    if (actionString && [actionString length]>0)
    {
        SEL func = NSSelectorFromString(actionString);
        if ([self respondsToSelector:func])
        {
            [self performSelector:func withObject:[NSNumber numberWithInt:indexPath.row]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Notice 

-(void)setNoticeBadgeValue:(NSInteger)noticeBadgeValue{

    if (noticeBadgeValue==_noticeBadgeValue) {
        return;
    }
    if (noticeBadgeValue<=0) {
        noticeBadgeValue=0;
    }
    _noticeBadgeValue=noticeBadgeValue;
    if (noticeBadgeValue==0) {
        [numberView setHidden:YES];
    }else
        [numberView setHidden:NO];
    numberView.number=noticeBadgeValue;
}

-(void)setChatMsgValue:(NSInteger)chatMsgValue{

    if (chatMsgValue<=0) {
        chatMsgValue=0;
    }
    if (chatMsgValue==_chatMsgValue) {
        return;
    }
    _chatMsgValue=chatMsgValue;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)addNoticeBadgeNumber:(NSInteger)addNumber{

    self.noticeBadgeValue=self.noticeBadgeValue+addNumber;
}

-(void)removeNoticeBadgeNumber:(NSInteger)removeNumber{

    self.noticeBadgeValue=self.noticeBadgeValue-removeNumber;
}

-(void)getNotice:(NSNotification *)not{

    [self addNoticeBadgeNumber:1];
}

-(void)chatMsgCountChangeNumber:(NSInteger)number{

    self.chatMsgValue=number;
}

@end

@interface LeftMenuCell (){

    BadgeView *badgeView;
}

@end
@implementation LeftMenuCell

-(void)dealloc{

    [badgeView release];
    [super dealloc];
}

-(void)setBadgeNumber:(NSInteger)badgeNumber{

    if (badgeNumber<=0) {
        badgeNumber=0;
    }
    
    if (badgeNumber==_badgeNumber) {
        return;
    }

    _badgeNumber=badgeNumber;
    
    if (badgeNumber==0) {
        [badgeView removeFromSuperview];
        [badgeView release];
        badgeView=nil;
    }else
    {
        if (!badgeView) {
            badgeView=[[BadgeView alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:badgeView];
        }
        badgeView.number=badgeNumber;
        badgeView.frame=CGRectMake(self.contentView.frame.size.width-150.f, self.contentView.frame.size.height/2-badgeView.frame.size.height/2, badgeView.frame.size.width, badgeView.frame.size.height);
    }
}
@end