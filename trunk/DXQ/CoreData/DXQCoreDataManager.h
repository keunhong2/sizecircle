//
//  DXQCoreDataManager.h
//  DXQ
//
//  Created by Yuan on 12-10-12.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Users.h"
#import "DXQAccount.h"

@interface DXQCoreDataManager : NSObject
{
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, assign) NSManagedObjectContext *managedObjectContext;

+ (DXQCoreDataManager *)sharedCoreDataManager;

- (void)setDXQManageObjectContext:(NSManagedObjectContext *)managedObject;

- (BOOL)saveChangesToCoreData;

//获取当前登陆用户
- (DXQAccount *)getCurrentLoggedInAccount;

//获取Account信息
- (DXQAccount*)getAccountByAccountID:(NSString*)accountID;


@end
