//
//  ChatUserManager.h
//  DXQ
//
//  Created by 黄修勇 on 12-12-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Users.h"

@interface ChatUserManager : NSObject

+(ChatUserManager *)shareChatUserManager;

-(void)chatWithUserID:(NSString *)userID;
-(void)chatWithUserDic:(NSDictionary *)dic;
-(void)chatWithUser:(Users *)user;

-(void)removeChatUserByDic:(NSDictionary *)dic;
-(void)removeChatUser:(Users *)user;

-(NSInteger)getMsgNumberByUser:(Users *)user;
-(NSInteger)getMsgNumberByUserID:(NSString *)userId;

-(NSArray *)getMsgsByUser:(Users *)user;
-(NSArray *)getMsgsByUserID:(NSString *)userID;

@end
