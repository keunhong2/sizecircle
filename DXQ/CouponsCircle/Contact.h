//
//  Contact.h
//  DXQ
//
//  Created by 黄修勇 on 13-2-18.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic,retain)NSString *firstName;
@property (nonatomic,retain)NSString *lastName;
@property (nonatomic,readonly)NSString *fullName;
@property (nonatomic,retain)NSMutableArray *phoneArray;
@property (nonatomic,readonly)NSString *phone;
-(BOOL)isContainPhone:(NSString *)phone;

-(BOOL)checkIsContainPhone:(NSArray *)array;

@end
