//
//  ChatUserManager.h
//  DXQ
//
//  Created by 黄修勇 on 12-12-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Users.h"

extern NSString *const DXQChatUserInfomationLoad;

@interface ChatUserManager : NSObject

+(ChatUserManager *)shareChatUserManager;

-(NSArray *)allChatUser;

-(void)chatWithUserID:(NSString *)userID;
-(void)chatWithUserDic:(NSDictionary *)dic;
-(void)chatWithUser:(Users *)user;

-(BOOL)removeChatUserByDic:(NSDictionary *)dic;
-(BOOL)removeChatUser:(Users *)user;

-(NSInteger)getMsgNumberByUser:(Users *)user;
-(NSInteger)getMsgNumberByUserID:(NSString *)userId;

-(NSArray *)getMsgsByUser:(Users *)user;
-(NSArray *)getMsgsByUserID:(NSString *)userID;

@end
