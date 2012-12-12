//
//  DXQAccount.h
//  DXQ
//
//  Created by Yuan on 12-11-16.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Users.h"

@interface DXQAccount : Users
{
@private
}

@property (nonatomic, retain) NSString * dxq_AccountName;
@property (nonatomic, retain) NSString * dxq_Password;
@property (nonatomic, retain) NSDate * dxq_AddDate;
//@property (nonatomic, retain) Users *contacts;

@end
