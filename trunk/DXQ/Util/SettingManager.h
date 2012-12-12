//
//  SettingManager.h
//  DXQ
//
//  Created by Yuan on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface SettingManager : NSObject
{
    NSMutableDictionary *userInfoDic;
}

@property (nonatomic)BOOL isAutoLogin;//是否自动登陆;

@property (nonatomic)BOOL outwayLocation;

@property (nonatomic,retain)NSMutableDictionary *userInfoDic;

+(SettingManager*)sharedSettingManager;

+(NSString *)getImagePath:(NSString*)imgname;

-(NSArray *)getSettingMenu;

-(NSArray *)getLeftControlMenu;

-(void)setNavBackGround:(UINavigationBar*)navbar;

// userdefault  save or get setting;
// 下面通过调用NSUserDefault 来获取或者设置变量
-(void)setValue:(id)value forKey:(NSString *)key;

-(id)valueForKey:(NSString *)key;

-(void)setLoggedInAccountPwd:(NSString *)pwd;

-(void)setLoggedInAccount:(NSString *)accountid;

- (NSString *)loggedInAccountPwd;

- (NSString *)loggedInAccount;

-(NSString *)getProtocolVersion;

- (NSString *)appVersion;

- (NSDictionary *)getNearByFriendsListFilterConfig;
- (void)setNearByFriendsListFilterConfig:(NSDictionary *)dict;

-(NSString *)getTempAccountPassword;
-(void)setTempAccountPassword:(NSString *)pwd;

-(void)setTempAccountID:(NSString *)accountID;
-(NSString *)getTempAccountID;

-(void)saveLastestContact:(NSMutableArray *)allContacts;

-(void)addLastestContact:(NSDictionary *)item;

- (NSMutableArray *)getLastestContact;

@end
