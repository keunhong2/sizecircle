//
//  SettingManager.m
//  DXQ
//
//  Created by Yuan on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "SettingManager.h"
#import "CustomNavigationBar.h"
#import "DXQAccount.h"
#import "DXQCoreDataEntityBuilder.h"

@implementation SettingManager
@synthesize isAutoLogin=_isAutoLogin;
@synthesize userInfoDic = _userInfoDic;

static SettingManager *setting = nil;

+(SettingManager*)sharedSettingManager
{
    @synchronized(self)
    {
        if (setting == nil)
        {
            setting = [[SettingManager alloc]init];
        }
        return setting;
    }
    return nil;
}

-(void)dealloc
{
    [_userInfoDic release];_userInfoDic = nil;
    [super dealloc];
}

-(id)init
{
    self = [super init];
    if (self)
    {
        //用来存储用户账号和密码等临时信息，只在程序运行期间有效
        _userInfoDic = [[NSMutableDictionary alloc]init];
        
        // 获取自动登陆
        _isAutoLogin=[[self valueForKey:SETTING_IS_AUTO_LOGIN_KEY] boolValue];
    }
    return self;
}

//用在socket登陆时
-(void)setTempAccountID:(NSString *)accountID
{
    if (accountID == nil) {
        [_userInfoDic removeObjectForKey:SETTING_ACCOUNT_KEY];return;
    }
    [_userInfoDic setObject:accountID forKey:SETTING_ACCOUNT_KEY];
}

-(NSString *)getTempAccountID
{
    return [_userInfoDic objectForKey:SETTING_ACCOUNT_KEY];
}

-(void)setTempAccountPassword:(NSString *)pwd
{
    if (pwd == nil) {
        [_userInfoDic removeObjectForKey:SETTING_PASSWORD_KEY];return;
    }
    [_userInfoDic setObject:pwd forKey:SETTING_PASSWORD_KEY];
}

-(NSString *)getTempAccountPassword
{
    return [_userInfoDic objectForKey:SETTING_PASSWORD_KEY];
}

-(NSString *)getProtocolVersion
{
    NSString *p = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"Protocol version"];
    if (p == nil) p = @"";
    return p;
}

- (NSString *)appVersion
{
    NSString *versionNo = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    return versionNo;
}

-(NSArray *)getLeftControlMenu
{
    NSString *path_ = [[NSBundle mainBundle] pathForResource:@"LeftMenu" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path_];
    return arr;
}


-(NSArray *)getSettingMenu
{
    NSString *path_ = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path_];
    return arr;
}

+(NSString *)getImagePath:(NSString*)imgname
{
    NSString *path_ = [[NSBundle mainBundle] pathForResource:imgname ofType:@"png"];
    return path_;
}

-(void)setNavBackGround:(UINavigationBar*)navbar
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
    {
        NSString *sourcePath = [SettingManager getImagePath:@"nav_bg"];
        UIImage *backImage = [UIImage imageWithContentsOfFile:sourcePath];
        [navbar setBackgroundImage:backImage forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        object_setClass(navbar, [CustomNavigationBar class]);
    }
}

// userdefault  save or get setting;
// 下面通过调用NSUserDefault 来获取或者设置变量
-(void)setValue:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setValue:value forKey:key];
}

-(id)valueForKey:(NSString *)key{

    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    return [userDefault valueForKey:key];
}

// isAutoLogin
-(void)setIsAutoLogin:(BOOL)isAutoLogin{

    if (isAutoLogin==_isAutoLogin) {
        return;
    }
    _isAutoLogin=isAutoLogin;
    [self setValue:[NSNumber numberWithBool:isAutoLogin] forKey:SETTING_IS_AUTO_LOGIN_KEY];
}

//location outway

-(BOOL)outwayLocation{

    DXQAccount *account=[[DXQCoreDataManager sharedCoreDataManager]getCurrentLoggedInAccount];
    return [account.dxq_IsOpenPosition boolValue];
}

-(void)setOutwayLocation:(BOOL)outwayLocation{

    DXQAccount *account=[[DXQCoreDataManager sharedCoreDataManager]getCurrentLoggedInAccount];
    account.dxq_IsOpenPosition=[NSNumber numberWithBool:outwayLocation];
    [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
}

-(void)setLoggedInAccount:(NSString *)accountid
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if (accountid == nil)
    {
        [userDefault removeObjectForKey:SETTING_ACCOUNT_KEY];
        [userDefault synchronize];
        return;
    }
    [userDefault setObject:accountid forKey:SETTING_ACCOUNT_KEY];
    [userDefault synchronize];
}


- (NSString *)loggedInAccount
{
    NSUserDefaults *defaultsSetting = [NSUserDefaults standardUserDefaults];
    return [defaultsSetting objectForKey:SETTING_ACCOUNT_KEY];
}

-(void)setLoggedInAccountPwd:(NSString *)pwd
{
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    if (pwd == nil)
    {
        [userDefault removeObjectForKey:SETTING_PASSWORD_KEY];
        [userDefault synchronize];
        return;
    }
    [userDefault setObject:pwd forKey:SETTING_PASSWORD_KEY];
    [userDefault synchronize];
}

- (NSString *)loggedInAccountPwd
{
    NSUserDefaults *defaultsSetting = [NSUserDefaults standardUserDefaults];
    return [defaultsSetting stringForKey:SETTING_PASSWORD_KEY];
}

- (NSDictionary *)getNearByFriendsListFilterConfig
{
    return [self valueForKey:NEARBY_FRIENDSLIST_FILTER_CONFIG];
}

- (void)setNearByFriendsListFilterConfig:(NSDictionary *)dict
{
    [self setValue:dict forKey:NEARBY_FRIENDSLIST_FILTER_CONFIG];
}

- (NSMutableArray *)getLastestContact
{
    NSUserDefaults *defaultsSetting = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@-%@",LASTEST_CONTACTS,[[SettingManager sharedSettingManager]loggedInAccount]];
    return [defaultsSetting objectForKey:key];
}

-(void)addLastestContact:(NSDictionary *)contact
{
    if (contact == nil) {
        return;
    }
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSMutableArray *allContacts = [[NSMutableArray alloc]initWithArray:[self getLastestContact]];
    BOOL isExist = NO;
    for (NSDictionary *item in allContacts)
    {
        NSString *AccountId = [contact objectForKey:@"AccountId"];
        
        if ([AccountId isEqualToString:[item objectForKey:@"AccountId"]])
        {
            isExist = YES;
            if (contact.allKeys.count>item.allKeys.count) {
                [allContacts removeObject:item];
                [allContacts replaceObjectAtIndex:[allContacts indexOfObject:item] withObject:contact];
            }
            break;
        }
    }
    if (!isExist)[allContacts addObject:contact];
    NSString *key = [NSString stringWithFormat:@"%@-%@",LASTEST_CONTACTS,[[SettingManager sharedSettingManager]loggedInAccount]];
    [userDefault setObject:allContacts forKey:key];
    [userDefault synchronize];
    [allContacts release];
}

-(BOOL)isContentAndHadDetailInfomationInLastest:(NSDictionary *)contact
{
    NSArray *tempArray=[self getLastestContact];
    NSMutableArray *allContacts = [[NSMutableArray alloc]initWithArray:tempArray];
    for (NSDictionary *item in allContacts)
    {
        NSString *AccountId = [contact objectForKey:@"AccountId"];
        
        if ([AccountId isEqualToString:[item objectForKey:@"AccountId"]])
        {
            if (contact.allKeys.count==item.allKeys.count) {
                return NO;
            }else
                return YES;
        }
    }
    return NO;
}

-(void)saveLastestContact:(NSMutableArray *)allContacts
{
    if (allContacts == nil) {
        return;
    }
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@-%@",LASTEST_CONTACTS,[[SettingManager sharedSettingManager]loggedInAccount]];
    [userDefault setObject:allContacts forKey:key];
    [userDefault synchronize];
}


@end
