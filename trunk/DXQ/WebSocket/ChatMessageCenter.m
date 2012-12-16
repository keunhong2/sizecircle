//
//  ChatMessageCenter.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ChatMessageCenter.h"

@interface ChatMessageCenter (){

    NSMutableArray *chatObserArray;
    NSMutableArray *chatMsgArray;
    NSMutableArray *chatMsgNumObserArray;
}

@end
@implementation ChatMessageCenter

static ChatMessageCenter *msgCenter=nil;

+(ChatMessageCenter *)shareMessageCenter{

    if (!msgCenter) {
        msgCenter=[[ChatMessageCenter alloc]init];
    }
    return msgCenter;
}

-(id)init{

    self=[super init];
    if (self) {
        chatObserArray=[NSMutableArray new];
        chatMsgArray=[NSMutableArray new];
        chatMsgNumObserArray=[NSMutableArray new];
    }
    return self;
}

-(void)dealloc{

    [chatMsgArray release];
    [chatObserArray release];
    [chatMsgNumObserArray release];
    [super dealloc];
}

-(void)postNewChatMessage:(id)msg{

    if ([[(NSDictionary *)msg allKeys]containsObject:@"AccountTo"]) {
        if ([[msg objectForKey:@"AccountFrom"] isEqualToString:[[SettingManager sharedSettingManager]loggedInAccount]]) {
            //chat msg is send success
            return;
        }
        BOOL isPost=NO;
        NSString *toUser=[msg objectForKey:@"AccountFrom"];
        for (ChatObserveObject *obj in chatObserArray) {
            if ([obj.chatName isEqualToString:toUser]) {
                [obj.controller getChatMessage:msg];
                isPost=YES;
            }
        }
        if (!isPost) {
            [chatMsgArray addObject:msg];
            for (ChatMessageNumberChangeObject *object in chatMsgNumObserArray) {
                [object.observer chatMsgCountChangeNumber:chatMsgArray.count];
            }
        }
    }
}

-(NSArray *)getMsgWithChatName:(NSString *)chatName{

    NSMutableArray *tempArray=[NSMutableArray array];
    for (int i=0; i<chatMsgArray.count; i++) {
        NSDictionary *dic=[chatMsgArray objectAtIndex:i];
        if ([[dic objectForKey:@"AccountTo"] isEqualToString:chatName]) {
            [tempArray addObject:dic];
        }
    }
    [chatMsgArray removeObjectsInArray:tempArray];
    return tempArray;
}

-(void)addChatViewController:(UIViewController *)controller chatName:(NSString *)chatName{

    ChatObserveObject *obj=[ChatObserveObject chatWithController:controller chatName:chatName];
    if (![chatObserArray containsObject:obj]) {
        [chatObserArray addObject:obj];
    }
}

-(void)removeChatViewController:(UIViewController *)controller{

    NSMutableArray *tempRemoveArray=[NSMutableArray new];
    
    for (ChatObserveObject *object in chatObserArray) {
        if (object.controller==controller) {
            [tempRemoveArray addObject:object];
        }
    }
    [chatObserArray removeObjectsInArray:tempRemoveArray];
    [tempRemoveArray release];
}

-(void)removeChatViewController:(UIViewController *)controller chatName:(NSString *)chatName{

     ChatObserveObject *obj=[ChatObserveObject chatWithController:controller chatName:chatName];
    [chatObserArray removeObject:obj];
    
}

-(void)addObserverForChatMessageNumberChange:(id)observer{

    ChatMessageNumberChangeObject *object=[[ChatMessageNumberChangeObject alloc]initWithObserver:observer];
    if (![chatMsgNumObserArray containsObject:object]) {
        
        [chatMsgNumObserArray addObject:object];
    }
    [object release];
}

-(void)removeObserverForChatMessageNumberChange:(id)observer{

    ChatMessageNumberChangeObject *object=[[ChatMessageNumberChangeObject alloc]initWithObserver:observer];
    [chatMsgNumObserArray removeObject:object];
}
@end

@implementation ChatObserveObject

-(void)dealloc{

    _controller=nil;
    [_chatName release];    _chatName=nil;
    [super dealloc];
}

+(id)chatWithController:(UIViewController *)controller chatName:(NSString *)chatName{

    ChatObserveObject *chat=[[ChatObserveObject alloc]initWithController:controller chatName:chatName];
    return [chat autorelease];
}

-(id)initWithController:(UIViewController *)controller chatName:(NSString *)chatName{

    self=[super init];
    if (self) {
        _controller=controller;
        _chatName=[chatName retain];
    }
    return self;
}

-(BOOL)isEqual:(id)object{

    BOOL isEqual=[super isEqual:object];
    if (isEqual) {
        return YES;
    }
    if (self.controller==[(ChatObserveObject *)object controller]&&[self.chatName isEqualToString:[(ChatObserveObject *)object  chatName]]) {
        return YES;
    }else
        return NO;
}

-(NSString *)debugDescription{

    return [NSString stringWithFormat:@"<%@ :%p ViewController:%p ChatName:%@>",self.class,self,_controller,_chatName];
}
@end

@implementation ChatMessageNumberChangeObject

-(void)dealloc{

    _observer=nil;
    [super dealloc];
}

-(id)initWithObserver:(id)observer{

    self=[super init];
    if (self) {
        _observer=observer;
    }
    return self;
}


-(BOOL)isEqual:(id)object{

    if ([super isEqual:object]) {
        return YES;
    }
    
    if (self.observer==[(ChatMessageNumberChangeObject *)object observer]) {
        return YES;
    }else
        return NO;
}

-(NSString *)debugDescription{

    return [NSString stringWithFormat:@"<%@ %p : Observer:%@>",self.class,self,_observer];
}
@end
