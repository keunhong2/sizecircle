//
//  ChatMessageCenter.h
//  DXQ
//
//  Created by 黄修勇 on 12-12-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatMessageCenter : NSObject

+(ChatMessageCenter *)shareMessageCenter;

-(void)postNewChatMessage:(id)msg;

-(NSArray *)getMsgWithChatName:(NSString *)chatName;

-(void)addChatViewController:(UIViewController *)controller chatName:(NSString *)chatName;

-(void)removeChatViewController:(UIViewController *)controller;

-(void)removeChatViewController:(UIViewController *)controller chatName:(NSString *)chatName;

-(void)addObserverForChatMessageNumberChange:(id)observer;

-(void)removeObserverForChatMessageNumberChange:(id)observer;

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


@interface UIViewController (ChatViewController)

-(void)getChatMessage:(NSDictionary *)msgDic;

@end

@interface NSObject (ChatMsgNumber)

-(void)chatMsgCountChangeNumber:(NSInteger)number;

@end
