//
//  DXQAccount.m
//  DXQ
//
//  Created by Yuan on 12-11-16.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQAccount.h"
#import "Users.h"


@implementation DXQAccount

@dynamic dxq_AccountName;
@dynamic dxq_Password;
@dynamic dxq_AddDate;
//@dynamic contacts;

/*
- (void)addContactsObject:(Users *)value
{
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"contacts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"contacts"] addObject:value];
    [self didChangeValueForKey:@"contacts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeContactsObject:(Users *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"contacts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"contacts"] removeObject:value];
    [self didChangeValueForKey:@"contacts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addContacts:(NSSet *)value {
    [self willChangeValueForKey:@"contacts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"contacts"] unionSet:value];
    [self didChangeValueForKey:@"contacts" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeContacts:(NSSet *)value {
    [self willChangeValueForKey:@"contacts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"contacts"] minusSet:value];
    [self didChangeValueForKey:@"contacts" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}
*/
 
@end
