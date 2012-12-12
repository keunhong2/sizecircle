//
//  DXQCoreDataManager.m
//  DXQ
//
//  Created by Yuan on 12-10-12.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQCoreDataManager.h"

static DXQCoreDataManager *shManager = nil;

@implementation DXQCoreDataManager
@synthesize managedObjectContext = _managedObjectContext;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(DXQCoreDataManager*)sharedCoreDataManager
{
    @synchronized(shManager)
    {
        if (!shManager) {
            shManager = [[DXQCoreDataManager alloc]init];
        }
    }
    return shManager;
}

- (void)setDXQManageObjectContext:(NSManagedObjectContext *)managedObject
{
    self.managedObjectContext = managedObject;
}

- (BOOL)saveChangesToCoreData
{
    @synchronized(self)
    {
        if(![DXQCoreDataManager sharedCoreDataManager].managedObjectContext)return NO;
        NSError *error = nil;
        [[DXQCoreDataManager sharedCoreDataManager].managedObjectContext setStalenessInterval:0.0];
        if([[DXQCoreDataManager sharedCoreDataManager].managedObjectContext hasChanges])
        {
            if( ![[DXQCoreDataManager sharedCoreDataManager].managedObjectContext save:&error])
            {
                HYLog(@"保存失败: %@", [error localizedDescription]);
                NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
                if(detailedErrors != nil && [detailedErrors count]> 0)
                {
                    for(NSError* detailedError in detailedErrors)
                        HYLog(@"错误详细: %@", [detailedError userInfo]);
                }
                else
                {
                    HYLog(@"%@", [error userInfo]);
                }
                NSAssert(error == nil, @"保存数据出错!");
                HYLog(@"保存错误!");
                return NO;
            }
        }
        return YES;
    }
}

//获取当前登陆用户对象
- (DXQAccount *)getCurrentLoggedInAccount
{
    return  [self getAccountByAccountID:[[SettingManager sharedSettingManager]loggedInAccount]];
}

- (DXQAccount*)getAccountByAccountID:(NSString*)accountID
{
    DXQAccount* account = nil;
    
    if (accountID && self.managedObjectContext)
    {
        //new a fetchrequest
        NSFetchRequest* request = [[NSFetchRequest alloc] init];
        
        //get YKAccount table structure
        NSEntityDescription * entity = [NSEntityDescription entityForName:NSStringFromClass([DXQAccount class]) inManagedObjectContext:self.managedObjectContext];
        
        //set search condition
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"dxq_AccountId = %@", accountID];
        
        //set request's entity
        [request setEntity:entity];
        
        //set request's prdicate
        [request setPredicate:predicate];
        
        NSError* error = nil;
        
        //execute request
        NSMutableArray* mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
        
        if (mutableFetchResults && [mutableFetchResults isKindOfClass:[NSMutableArray class]] && [mutableFetchResults count]>0)
        {
            account = [mutableFetchResults objectAtIndex:0];
        }
        else
        {
//            HYLog(@"没有该条记录: %@", [error description]);
        }
        if (mutableFetchResults)[mutableFetchResults release];
        [request release];
    }
    return account;
}


@end
