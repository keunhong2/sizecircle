//
//  ChatMessageCenter.h
//  DXQ
//
//  Created by 黄修勇 on 12-12-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatHistory.h"


extern NSString *const DXQChatMessageWillGetUnReadMessageNotification;
extern NSString *const DXQChatMessageDidGetUnReadMessageNotification;

@protocol ChatMessageDelegate <NSObject>

@optional

-(void)chatMessage:(NSDictionary *)msgDic sendFailedWithError:(NSError *)error;

-(void)chatMessageDidSend:(NSDictionary *)msgDic;

@end

@interface ChatMessageCenter : NSObject

+(ChatMessageCenter *)shareMessageCenter;

-(void)postNewChatMessage:(id)msg;

-(void)postNewChatMessageArray:(NSArray *)msgArray;

-(NSArray *)getMsgWithChatName:(NSString *)chatName;

-(void)addChatViewController:(UIViewController *)controller chatName:(NSString *)chatName;

-(void)removeChatViewController:(UIViewController *)controller;

-(void)removeChatViewController:(UIViewController *)controller chatName:(NSString *)chatName;

-(void)addObserverForChatMessageNumberChange:(id)observer;

-(void)removeObserverForChatMessageNumberChange:(id)observer;


//for send msg

-(void)sendMsg:(NSDictionary *)msgDic target:(id)target;

-(void)removeMsgTarget:(id)target;


//for un read msg

-(void)getUnReadMessage;

-(void)cancelGetUnReadMessage;

@end

@interface ChatObserveObject : NSObject

@property (nonatomic,readonly)UIViewController *controller;
@property (nonatomic,retain,readonly)NSString *chatName;

+(id)chatWithController:(UIViewController *)controller chatName:(NSString *)chatName;

@end

@interface ChatMessageNumberChangeObject : NSObject

@property(nonatomic,readonly)id observer;

-(id)initWithObserver:(id)observer;

@end

@interface SendMessageEntity : NSObject

@property (nonatomic,retain)ChatHistory *chatMsg;
@property (nonatomic,assign)id target;

@end
//for ChatVC get message
@interface UIViewController (ChatViewController)

-(void)getChatMessage:(NSDictionary *)msgDic;

@end

@interface NSObject (ChatMsgNumber)

-(void)chatMsgCountChangeNumber:(NSInteger)number;

@end
