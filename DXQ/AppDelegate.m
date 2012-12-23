//
//  AppDelegate.m
//  DXQ
//
//  Created by Yuan.He on 12-9-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "RightViewController.h"
#import "LeftViewController.h"
#import "DXQCoreDataManager.h"
#import "DXQCoreDataEntityBuilder.h"

#import "CouponsCircleVC.h"
#import "TicketViewController.h"

#import "CustonNavigationController.h"
#import "PPRevealSideViewController.h"
#import "DXQWebSocket.h"
#import "GPS.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navViewController = _navViewController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize menuController = _menuController;

- (void)dealloc
{
    [_menuController release];
    [_navViewController release];
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //gps
    [[GPS gpsManager]startUpdateLocation];
    
    //coredata
    [[DXQCoreDataManager sharedCoreDataManager] setDXQManageObjectContext:[self managedObjectContext]];
    
    //menu
    TicketViewController *viewController = [[TicketViewController alloc]init];
    self.navViewController = [[CustonNavigationController alloc] initWithRootViewController:viewController];
 
    PPRevealSideViewController *rootController=[[PPRevealSideViewController alloc]initWithRootViewController:self.navViewController];
    [rootController setDirectionsToShowBounce:PPRevealSideDirectionLeft];
    self.menuController = rootController;
    
    LeftViewController  *leftController = [[LeftViewController alloc] init];
    [rootController preloadViewController:leftController forSide:PPRevealSideDirectionLeft];
    [leftController release];
        
//    RightViewController *rightController = [[RightViewController alloc] init];
//    [rootController preloadViewController:rightController forSide:PPRevealSideDirectionRight];
//    [rightController release];
    self.window = [[[TestWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.menuController;
    [self.window makeKeyAndVisible];

    [viewController release];
    
    [rootController release];
    
    [self loadLoginViewWithAnimation:NO];
    
    //开始websocket链接
    [[DXQWebSocket sharedWebSocket]reconnetWebSocket];

    return YES;
}

//弹出登陆界面
- (void)loadLoginViewWithAnimation:(BOOL)animated
{
    SignInVC *loginViewController = [[SignInVC alloc]init];
    CustonNavigationController *navController = [[CustonNavigationController alloc] initWithRootViewController:loginViewController];
    [self.menuController presentModalViewController:navController animated:animated];
    [loginViewController release];
    [navController release];
}

-(void)dismissLoginViewControl
{
    [[AppDelegate sharedAppDelegate].menuController  dismissModalViewControllerAnimated:YES];
}

- (void)saveAccountInfoToCoreData:(NSDictionary*)dictionary withPassword:(NSString *)pwd dismissViewController:(BOOL)isdimiss
{
    [[DXQCoreDataEntityBuilder sharedCoreDataEntityBuilder] buildAccountWitdDictionary:dictionary accountPassword:pwd];
    if([[DXQCoreDataManager sharedCoreDataManager] saveChangesToCoreData] && isdimiss)
    {
        HYLog(@"保存用户信息成功！");
        //保存成功
        [[AppDelegate sharedAppDelegate]dismissLoginViewControl];
    }
}

//登陆
-(void)signInWithAccount:(NSString *)account password:(NSString *)psw
{
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
    [parametersDic setObject:account forKey:@"Account"];
    [parametersDic setObject:[Tool ConMD5:psw] forKey:@"Password"];
    NSString *lat = [[GPS gpsManager]getLocation:GPSLocationLatitude];
    NSString *lon = [[GPS gpsManager]getLocation:GPSLocationLongitude];
    [parametersDic setObject:lon forKey:@"JingDu"];
    [parametersDic setObject:lat forKey:@"WeiDu"];
    [parametersDic setObject:@"0" forKey:@"AccountType"];
    [parametersDic setObject:@"1" forKey:@"DeviceInfo"];
    [parametersDic setObject:[[GPS gpsManager]getLocation:GPSLocationLatitude] forKey:@"WeiDu"];
    [parametersDic setObject:[[GPS gpsManager]getLocation:GPSLocationLongitude] forKey:@"JingDu"];
    NSString *pJson = [parametersDic JSONRepresentation];
    NSString *mes = [NSString stringWithFormat:@"a=UserLogIn&p=%@",pJson];
    HYLog(@"Socket 发送数据:%@",mes);
    [[DXQWebSocket sharedWebSocket]sendMessage:mes];
}

#pragma 登陆回调
- (void)signInRequestDidFinishedWithParamters:(NSDictionary *)dict
{
    [[DXQWebSocket sharedWebSocket]setIsSignIn:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONCENTER_SIGNIN object:dict];
}


- (void)signInRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    [[DXQWebSocket sharedWebSocket]setIsSignIn:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONCENTER_SIGNIN object:errorMsg];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DXQ" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DXQ.sqlite"];
    
    // handle db upgrade 
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
							 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
							 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end


@implementation TestWindow

-(void)addSubview:(UIView *)view{

    [super addSubview:view];
    NSLog(@"sssss");
}

@end
