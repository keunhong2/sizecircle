//
//  SettingVC.m
//  DXQ
//
//  Created by Yuan on 12-10-29.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "SettingVC.h"
#import "SDImageCache.h"
#import "UserSetOpenPosition.h"
#import "CheckPhoneVersion.h"
#import "EmailManage.h"
#import "WebViewController.h"

@interface SettingVC ()<BusessRequestDelegate,UIAlertViewDelegate>
{
    UISwitch *autoLoginSwitch;
    UISwitch *outwayLocationSwitch;
    
    UserSetOpenPosition *openLocationRequest;
    CheckPhoneVersion *checkVersion;
    
}
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSArray *dataSourceArray;
@property (nonatomic,retain)NSDictionary *versionDic;

@end

@implementation SettingVC

@synthesize dataSourceArray = _dataSourceArray;
@synthesize tableView=_tableView;

-(void)dealloc
{
    [_tableView release];_tableView = nil;
    [_dataSourceArray release];_dataSourceArray = nil;
    [autoLoginSwitch release];
    [outwayLocationSwitch release];
    [_versionDic release];
    [super dealloc];
}


-(void)viewDidUnload
{
    self.tableView = nil;

    [super viewDidUnload];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _dataSourceArray = [[NSArray alloc]initWithArray:[[SettingManager sharedSettingManager] getSettingMenu]];

    }
    return self;
}


-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        _tableView = tableView;
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, tableView.frame.size.width, 80.f)];
        UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [logoutButton setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
        [logoutButton setFrame:CGRectMake(10,10, 300, 40.0f)];
        [logoutButton.titleLabel setFont:TitleDefaultFont];
        [logoutButton setTitle:AppLocalizedString(@"退出系统") forState:UIControlStateNormal];
        [logoutButton addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:logoutButton];
        tableView.tableFooterView=footerView;
        [footerView release];
    }
    if (!autoLoginSwitch) {
        autoLoginSwitch=[[UISwitch alloc]initWithFrame:CGRectZero];
        autoLoginSwitch.on=[[SettingManager sharedSettingManager]isAutoLogin];
        [autoLoginSwitch addTarget:self action:@selector(autoLoginChange:) forControlEvents:UIControlEventValueChanged];
    }
    
    if (!outwayLocationSwitch) {
        outwayLocationSwitch=[[UISwitch alloc]initWithFrame:CGRectZero];
        outwayLocationSwitch.on=[[SettingManager sharedSettingManager]outwayLocation];
        [outwayLocationSwitch addTarget:self action:@selector(outwayLocationChange:) forControlEvents:UIControlEventValueChanged];
    }
}

- (void)viewDidLoad
{
    self.navigationItem.title = AppLocalizedString(@"设置");

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self cancelAllRequest];
}

#pragma mark -Action

-(void)autoLoginChange:(UISwitch *)theSwitch{

    [[SettingManager sharedSettingManager]setIsAutoLogin:theSwitch.on];
}

-(void)outwayLocationChange:(UISwitch *)theSwitch{
    
    [[SettingManager sharedSettingManager]setOutwayLocation:theSwitch.on];
    [self postionOpen:theSwitch.on];
}

-(void)clearCache{
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"清理缓存...")];
    [NSThread detachNewThreadSelector:@selector(clearAllCache) toTarget:self withObject:nil];
}

-(void)clearAllCache{

    [[SDImageCache sharedImageCache]clearMemory];
    [[SDImageCache sharedImageCache]clearDisk];
    [[SDImageCache sharedImageCache]cleanDisk];
    [[ProgressHUD sharedProgressHUD]performSelectorOnMainThread:@selector(done:) withObject:(id)kCFBooleanTrue waitUntilDone:YES];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

-(void)logOut:(UIButton *)btn
{
    //init account and pwd
    [[SettingManager sharedSettingManager]setIsLogin:NO];
    [[SettingManager sharedSettingManager]setTempAccountID:nil];
    [[SettingManager sharedSettingManager]setTempAccountPassword:nil];
    [[SettingManager sharedSettingManager]setLoggedInAccountPwd:nil];
    [[SettingManager sharedSettingManager]setLoggedInAccount:nil];
    
    //stop all request...
  
    //show signin page
    [[AppDelegate sharedAppDelegate]loadLoginViewWithAnimation:YES];
    
    //default page
    [self didSelectControl:@"CouponsCircleVC"];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSourceArray count];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_dataSourceArray objectAtIndex:section] objectForKey:@"rows"] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.accessoryView=nil;
    
    NSDictionary *item = [[[_dataSourceArray objectAtIndex:indexPath.section] objectForKey:@"rows"] objectAtIndex:indexPath.row];
    NSString *title=[item objectForKey:@"title"];
    
    if ([title isEqualToString:@"位置公开"]) {
        cell.accessoryView=outwayLocationSwitch;
    }
    if ([title isEqualToString:@"自动登陆"]) {
        cell.accessoryView=autoLoginSwitch;
    }
    cell.detailTextLabel.text=nil;
    if ([title isEqualToString:@"清除缓存"]) {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%.2f MB",(float)[[SDImageCache sharedImageCache]getSize]/1024.f/1024.f];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = title;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *actionString = [[_dataSourceArray objectAtIndex:indexPath.section] objectForKey:@"sectionaction"];
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
    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)baseAction:(NSNumber *)number{

    switch ([number integerValue]) {
        case 0:
            [self goViewControllerWithClassName:@"ActivitySettingViewController"];
            break;
        case 1:
            [self goViewControllerWithClassName:@"ShareManageViewController"];
            break;
        case 2:
            [self goViewControllerWithClassName:@"EventRemindViewController"];
            break;
        case 3:
            [self goViewControllerWithClassName:@"CitySelectedViewController"];
            break;
        case 4:
            [self goViewControllerWithClassName:@"BlackFriendViewController"];
            break;
        case 7:
            [self clearCache];
            break;
            
        default:
            break;
    }
}

//

-(void)myAction:(NSNumber *)number
{
    NSString *viewControllerClassName=nil;
    switch ([number intValue]) {
        case 0:
            viewControllerClassName=@"AllOrderViewController";
            break;
        case 1:
            viewControllerClassName=@"MyTicketViewController";
            break;
        case 2:
            viewControllerClassName=@"MyTuanViewController";
            break;
        case 3:
            viewControllerClassName=@"MyCardViewController";
            break;
        case 4:
            viewControllerClassName=@"MyEventViewController";
            break;
        case 5:
            viewControllerClassName=@"MyPraiseViewController";
            break;
        default:
            break;
    }
    [self goViewControllerWithClassName:viewControllerClassName];
}

-(void)AboutAppAction:(NSNumber *)number{

    switch ([number integerValue]) {
        case 0:
        {
            NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",APPID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 1:
        {
            [EmailManage showEmailViewControllerWithHandleViewController:self sendToUser:DXQFeedbackEmail];
        }
            break;
        case 2:
            [self requestVersion];
            break;
        case 3:
            [self goHelpViewController];
            break;
        case 4:
            [self goViewControllerWithClassName:@"AboutViewController"];
            break;
        default:
            break;
    }
}
-(void)goViewControllerWithClassName:(NSString *)className{

    UIViewController *controller=[[NSClassFromString(className) alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)goHelpViewController{

    WebViewController *controller=[[WebViewController alloc]init];
    controller.title=AppLocalizedString(@"帮助");
    [self.navigationController pushViewController:controller animated:YES];
    [controller.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:HelpWebSite]]];
    [controller release];
}
#pragma mark -Request


-(void)cancelAllRequest{

    [self cancelOpenPostionRequest];
    [self cancelCheckVersion];
}

-(void)cancelOpenPostionRequest{

    if (openLocationRequest) {
        [openLocationRequest cancel];
        [openLocationRequest release];
        openLocationRequest=nil;
    }
}

-(void)postionOpen:(BOOL)open{

    [self cancelOpenPostionRequest];
    
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSString *isOpen=open==YES?@"1":@"0";
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accountID,@"AccountId",isOpen,@"IsOpenPosition", nil];
    openLocationRequest=[[UserSetOpenPosition alloc]initWithRequestWithDic:dic];
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"设置中...")];
    openLocationRequest.delegate=self;
    [openLocationRequest startAsynchronous];
}

-(void)cancelCheckVersion{

    if (checkVersion) {
        [checkVersion cancel];
        [checkVersion release];
        checkVersion=nil;
    }
}

-(void)requestVersion{

    [self cancelCheckVersion];

    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSString *sysType=@"IOS";
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accountID,@"AccountId",sysType,@"SysType", nil];
    [[ProgressHUD sharedProgressHUD]showInView:[[[UIApplication sharedApplication]windows]objectAtIndex:0]];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"检查更新")];
    checkVersion=[[CheckPhoneVersion alloc]initWithRequestWithDic:dic];
    checkVersion.delegate=self;
    [checkVersion startAsynchronous];
}

#pragma mark -

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    if (request==openLocationRequest) {
        [[ProgressHUD sharedProgressHUD]showInView:self.view];
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"设置位置信息成功")];
        [[ProgressHUD sharedProgressHUD]done:YES];
        [[SettingManager sharedSettingManager]setOutwayLocation:outwayLocationSwitch.on];
    }else if (request==checkVersion){
    
        self.versionDic=data;
        NSString *currentVersion=[[SettingManager sharedSettingManager]appVersion];
        [[ProgressHUD sharedProgressHUD]done:YES];
        if ([[data objectForKey:@"Version"] floatValue]>[currentVersion floatValue]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppLocalizedString(@"有新版本发布") message:AppLocalizedString(@"是否下载最新版本?") delegate:self cancelButtonTitle:@"下次" otherButtonTitles:@"前往", nil];
            [alert show];
            [alert release];
        }else
        {
            [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"当前版本为最新版本")];
            [[ProgressHUD sharedProgressHUD]done:YES];
        }
    }
}

#pragma mark -UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[_versionDic objectForKey:@"DownLoadUrl"]]];
    }
}
@end
