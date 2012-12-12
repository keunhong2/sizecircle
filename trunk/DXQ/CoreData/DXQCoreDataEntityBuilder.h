//
//  DXQCoreDataEntityBuilder.h
//  DXQ
//
//  Created by Yuan on 12-11-16.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXQCoreDataManager.h"
#import "DXQAccount.h"
#import "Users.h"

@interface DXQCoreDataEntityBuilder : NSObject
{

}

+ (DXQCoreDataEntityBuilder*)sharedCoreDataEntityBuilder;

- (DXQAccount*)buildAccountWitdDictionary:(NSDictionary*)dictionary accountPassword:(NSString*)accountPassword;

- (DXQAccount*)buildAccountWitdDictionary:(NSDictionary*)dictionary accountPassword:(NSString*)accountPassword managedObjectContext:(NSManagedObjectContext*)managedObjectContext;

-(NSDictionary *)DXQAccountToNSDictionary:(DXQAccount *)account;

@end
