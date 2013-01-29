//
//  ChatUserManager.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ChatUserManager.h"
#import "DXQCoreDataEntityBuilder.h"
#import "UserLoadPersonalPage.h"
#import "ChatMessageCenter.h"

@interface ChatUserManager ()<BusessRequestDelegate>{

    NSMutableArray *chatUserArray;
    NSMutableArray *requestArray;
    UserLoadPersonalPage *userInfoDetail;
}
@end

NSString *const DXQChatUserInfomationLoad=@"DXQChatUserInfomationLoad";
@implementation ChatUserManager

static ChatUserManager *chatManager=nil;

+(ChatUserManager *)shareChatUserManager{

    if (!chatManager) {
        chatManager=[[ChatUserManager alloc]init];
    }
    return chatManager;
}

-(id)init{

    self=[super init];
    if (self) {
        chatUserArray=[NSMutableArray new];
        requestArray=[NSMutableArray new];
    }
    return self;
}

-(NSArray *)allChatUser{

    return chatUserArray;
}

-(void)chatWithUser:(Users *)user{

    for (Users *tempUser in chatUserArray) {
        if ([tempUser.dxq_AccountId isEqualToString:user.dxq_AccountId]) {
            [tempUser retain];
            [chatUserArray removeObject:tempUser];
            [chatUserArray insertObject:tempUser atIndex:0];
            [tempUser release];
            return;
        }
    }
    [chatUserArray insertObject:user atIndex:0];
    [self getUserDetailByUserID:user.dxq_AccountId];
}

-(void)chatWithUserDic:(NSDictionary *)dic{

    Users *user=[[DXQCoreDataEntityBuilder sharedCoreDataEntityBuilder]buildAccountWitdDictionary:dic accountPassword:nil];
    [self chatWithUser:user];
}

-(void)getUserDetailByUserID:(NSString *)userID{

    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:userID,@"AccountFrom",[[SettingManager sharedSettingManager]loggedInAccount],@"AccountId", nil];
    UserLoadPersonalPage *request=[[UserLoadPersonalPage alloc]initWithRequestWithDic:dic];
    request.delegate=self;
    [requestArray addObject:request];
    [request startAsynchronous];
    [request release];
}

-(void)cancelGetUserDetailByUserID:(NSString *)userID{

    for (UserLoadPersonalPage *request in requestArray) {
        if ([[request.paramDic objectForKey:@"AccountId"] isEqualToString:userID]) {
            [chatUserArray removeObject:request];
            [request cancel];
            return;
        }
    }
}


-(BOOL)removeChatUser:(Users *)user{
    
    for (Users *tempUser in chatUserArray) {
        if ([tempUser.dxq_AccountId isEqualToString:user.dxq_AccountId]) {
            [chatUserArray removeObject:tempUser];
            [self cancelGetUserDetailByUserID:tempUser.dxq_AccountId];
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)removeChatUserByDic:(NSDictionary *)dic{

    for (Users *tempUser in chatUserArray) {
        if ([tempUser.dxq_AccountId isEqualToString:[dic objectForKey:@"AccountId"]]) {
            [chatUserArray removeObject:tempUser];
            [self cancelGetUserDetailByUserID:tempUser.dxq_AccountId];
            return YES;
        }
    }
    
    return NO;
}


-(NSInteger)getMsgNumberByUser:(Users *)user{

    return [self getMsgNumberByUserID:user.dxq_AccountId];
}

-(NSInteger)getMsgNumberByUserID:(NSString *)userId{

    return [[[ChatMessageCenter shareMessageCenter]getMsgWithChatName:userId] count];
}

-(NSArray *)getMsgsByUser:(Users *)user{
    
    return [self getMsgsByUserID:user.dxq_AccountId];
}
-(NSArray *)getMsgsByUserID:(NSString *)userID{

    return [[ChatMessageCenter shareMessageCenter]getMsgWithChatName:userID];
}

#pragma mark -Delegate

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [request retain];
    [requestArray removeObject:request];
    [self getUserDetailByUserID:[request.paramDic objectForKey:@"AccountId"]];
    [request release];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    [request retain];
    [requestArray removeObject:request];
    Users *user=nil;
    for (Users *tempUser in chatUserArray) {
        if([tempUser.dxq_AccountId isEqualToString:[request.paramDic objectForKey:@"AccountId"]])
        {
            user=tempUser;
            break;
        }
    }
    if (user) {
        [[DXQCoreDataEntityBuilder sharedCoreDataEntityBuilder]assignToUser:user dictionary:data saveUpdateDate:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:DXQChatUserInfomationLoad object:data];
    }
}



@end
