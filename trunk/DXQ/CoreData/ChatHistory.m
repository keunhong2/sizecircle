//
//  ChatHistory.m
//  DXQ
//
//  Created by Yuan on 12-11-26.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ChatHistory.h"
#import "DXQCoreDataManager.h"

@implementation ChatHistory

@dynamic dxq_AccountFrom;
@dynamic dxq_Id;
@dynamic dxq_AccountTo;
@dynamic dxq_IsReceived;
@dynamic dxq_Face;
@dynamic dxq_Content;
@dynamic dxq_JingDu;
@dynamic dxq_OpTime;
@dynamic dxq_Picture;
@dynamic dxq_WeiDu;
//
//-(BOOL)isEqual:(id)object{
//
//    if ([super isEqual:object]) {
//        return YES;
//    }
//    ChatHistory *othor=(ChatHistory *)object;
//    if ([self.dxq_AccountFrom isEqualToString:othor.dxq_AccountFrom]&&
//        [self.dxq_AccountTo isEqualToString:othor.dxq_AccountTo]&&
//        [self.dxq_Id isEqualToNumber:othor.dxq_Id]) {
//        return YES;
//    }else
//        return NO;
//}

-(NSDictionary *)chatDictionary{

    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    if (self.dxq_AccountFrom) {
        [dic setObject:self.dxq_AccountFrom forKey:@"AccountFrom"];
    }
    if (self.dxq_AccountTo) {
        [dic setObject:self.dxq_AccountTo forKey:@"AccountTo"];
    }
    if (self.dxq_Content) {
        [dic setObject:self.dxq_Content forKey:@"Content"];
    }
    if (self.dxq_Face) {
        [dic setObject:self.dxq_Face forKey:@"Face"];
    }
    if (self.dxq_Picture) {
        [dic setObject:self.dxq_Picture forKey:@"Picture"];
    }
    if (self.dxq_JingDu) {
        [dic setObject:self.dxq_JingDu forKey:@"JingDu"];
    }
    if (self.dxq_WeiDu) {
        [dic setObject:self.dxq_WeiDu forKey:@"WeiDu"];
    }
    if (self.dxq_OpTime) {
        NSString *text=[NSString stringWithFormat:@"%f",[self.dxq_OpTime timeIntervalSince1970]];
        [dic setObject:text forKey:@"OpTime"];
    }
    if (self.dxq_IsReceived) {
        [dic setObject:self.dxq_IsReceived forKey:@"IsReceived"];
    }
    return dic;
}

@end

@implementation NSDictionary (ChatHistoty)

-(ChatHistory *)chatHistory{

    NSArray *keys=[self allKeys];
    NSManagedObjectContext *contenxt=[[DXQCoreDataManager sharedCoreDataManager]managedObjectContext];
    ChatHistory *chat=[NSEntityDescription insertNewObjectForEntityForName:@"ChatHistory" inManagedObjectContext:contenxt];
    if ([keys containsObject:@"AccountFrom"]) {
        chat.dxq_AccountFrom=[self objectForKey:@"AccountFrom"];
    }else
        chat.dxq_AccountFrom=@"";
    
    if ([keys containsObject:@"AccountTo"]) {
        chat.dxq_AccountTo=[self objectForKey:@"AccountTo"];
    }else
        chat.dxq_AccountTo=@"";
    
    if ([keys containsObject:@"Content"]) {
        chat.dxq_Content=[self objectForKey:@"Content"];
    }else
        chat.dxq_Content=@"";
    
    if ([keys containsObject:@"Picture"]) {
        chat.dxq_Picture=[self objectForKey:@"Picture"];
    }else
        chat.dxq_Picture=@"";
    
    if ([keys containsObject:@"Face"]) {
        chat.dxq_Face=[self objectForKey:@"Face"];
    }else
        chat.dxq_Face=@"";
    
    if ([keys containsObject:@"JingDu"]) {
        chat.dxq_JingDu=[NSString stringWithFormat:@"%@",[self objectForKey:@"JingDu"]];
    }else
        chat.dxq_JingDu=@"0";
    
    if ([keys containsObject:@"WeiDu"]) {
        chat.dxq_WeiDu=[NSString stringWithFormat:@"%@",[self objectForKey:@"WeiDu"]];
    }else
        chat.dxq_WeiDu=@"0";
    
    if ([keys containsObject:@"IsReceived"]) {
        chat.dxq_IsReceived=[self objectForKey:@"IsReceived"];
    }else
        chat.dxq_IsReceived=@"0";
    
    if ([keys containsObject:@"OpTime"]) {
        chat.dxq_OpTime=[NSDate dateWithTimeIntervalSince1970:[[self objectForKey:@"OpTime"] integerValue]];
    }else
        chat.dxq_OpTime=[NSDate date];
    
    return chat;
}

@end