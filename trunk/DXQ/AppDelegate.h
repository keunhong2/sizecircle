//
//  AppDelegate.h
//  DXQ
//
//  Created by Yuan.He on 12-9-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponsCircleVC.h"
#import "SignInVC.h"

@class DDMenuController;

@class PPRevealSideViewController;
@class CheckLockService;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) UINavigationController *navViewController;

@property (strong, nonatomic) PPRevealSideViewController *menuController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic,retain)CheckLockService *check;

+ (AppDelegate *)sharedAppDelegate;

- (NSURL *)applicationDocumentsDirectory;

//加载登陆页面
- (void)loadLoginViewWithAnimation:(BOOL)animated;

//登陆页面消失
-(void)dismissLoginViewControl;

//保存用户信息
- (void)saveAccountInfoToCoreData:(NSDictionary*)dictionary withPassword:(NSString *)pwd dismissViewController:(BOOL)isdimiss;

#pragma 登陆
//登陆
-(void)signInWithAccount:(NSString *)account password:(NSString *)psw;

//回调
- (void)signInRequestDidFinishedWithParamters:(NSDictionary *)dict;
- (void)signInRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;

@end
