//
//  ChatMessageCenter.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ChatMessageCenter.h"
#import "DXQWebSocket.h"
#import "UserLoadUnReceivedChat.h"

@interface ChatMessageCenter ()<BusessRequestDelegate>{

    NSMutableArray *chatObserArray;
    NSMutableArray *chatMsgArray;
    NSMutableArray *chatMsgNumObserArray;
    NSMutableArray *sendAndNotReceviecArray;
    UserLoadUnReceivedChat *getUnReadMsgRequest;
}

@end

NSString *const DXQChatMessageWillGetUnReadMessageNotification=@"DXQChatMessageWillGetUnReadMessageNotification";
NSString *const DXQChatMessageDidGetUnReadMessageNotification=@"DXQChatMessageDidGetUnReadMessageNotification";

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
        sendAndNotReceviecArray=[NSMutableArray new];
    }
    return self;
}

-(void)dealloc{

    [chatMsgArray release];
    [chatObserArray release];
    [chatMsgNumObserArray release];
    [sendAndNotReceviecArray release];
    [super dealloc];
}

-(void)postNewChatMessage:(id)msg{

    if ([[(NSDictionary *)msg allKeys]containsObject:@"AccountTo"]) {
        if ([[msg objectForKey:@"AccountFrom"] isEqualToString:[[SettingManager sharedSettingManager]loggedInAccount]]) {
            //chat msg is send success
            [self chatMsgIsSend:msg];
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


-(void)postNewChatMessageArray:(NSArray *)msgArray
{
    NSInteger number=0;
    for (NSDictionary *msg in msgArray) {
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
            number++;
        }
    }
    for (ChatMessageNumberChangeObject *object in chatMsgNumObserArray) {
        [object.observer chatMsgCountChangeNumber:number];
    }
}

-(NSArray *)getMsgWithChatName:(NSString *)chatName{

    NSMutableArray *tempArray=[NSMutableArray array];
    for (int i=0; i<chatMsgArray.count; i++) {
        NSDictionary *dic=[chatMsgArray objectAtIndex:i];
        if ([[dic objectForKey:@"AccountFrom"] isEqualToString:chatName]) {
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

//for send msg

-(void)sendMsg:(NSDictionary *)msgDic target:(id)target{

    
    ChatHistory *chat=[msgDic chatHistory];
    [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
    
    if(![[DXQWebSocket sharedWebSocket]isOpen])
    {
        if (target&&[target respondsToSelector:@selector(chatMessage:sendFailedWithError:)]) {
            NSError *error=[NSError errorWithDomain:@"Chat Message" code:100 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Socket is not connection", nil]];
            [target chatMessage:msgDic sendFailedWithError:error];
        }
        return;
    }
    
    SendMessageEntity *send=[[SendMessageEntity alloc]init];
    send.chatMsg=chat;
    send.target=nil;
    [sendAndNotReceviecArray addObject:send];
    NSString *pJson = [msgDic JSONRepresentation];
    NSString *mes = [NSString stringWithFormat:@"a=UserChatWithFriend&p=%@",pJson];
    HYLog(@"Socket 发送数据:%@",mes);
    [[DXQWebSocket sharedWebSocket]sendMessage:mes];
    [self performSelector:@selector(msgTimeOut:) withObject:send afterDelay:5.f];
    [send release];
}

-(void)removeMsgTarget:(id)target
{
    for (SendMessageEntity *entity in sendAndNotReceviecArray) {
        if (entity.target==target) {
            entity.target=nil;
        }
    }
}

-(void)msgTimeOut:(SendMessageEntity *)entity{
    
    if (entity.target&&[entity.target respondsToSelector:@selector(chatMessage:sendFailedWithError:)]) {
        NSError *error=[NSError errorWithDomain:@"Chat Message" code:101 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Send message time out", nil]];
        [entity.target chatMessage:[entity.chatMsg chatDictionary] sendFailedWithError:error];
    }
    [sendAndNotReceviecArray removeObject:entity];
}

-(void)chatMsgIsSend:(NSDictionary *)dic
{
    for (int i=0; i<sendAndNotReceviecArray.count; i++) {
        SendMessageEntity *chat=[sendAndNotReceviecArray objectAtIndex:i];
        if ([chat.chatMsg.dxq_Content isEqualToString:[dic objectForKey:@"Content"]]&&
            [chat.chatMsg.dxq_AccountFrom isEqualToString:[dic objectForKey:@"AccountFrom"]]&&
            [chat.chatMsg.dxq_AccountTo isEqualToString:[dic objectForKey:@"AccountTo"]]) {
            chat.chatMsg.dxq_IsReceived=@"1";
            [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
            if (chat.target&&[chat.target respondsToSelector:@selector(chatMessageDidSend:)]) {
                [chat.target chatMessageDidSend:dic];
            }
            [sendAndNotReceviecArray removeObject:chat];
            return;
        }
    }
}

//for un read msg

-(void)getUnReadMessage{

    [self cancelGetUnReadMessage];
    NSDictionary *pager=[NSDictionary dictionaryWithObjectsAndKeys:
                         @"1",@"PageIndex",
                         @"9999",@"ReturnCount", nil];
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accountID,@"AccountId",pager,@"Pager", nil];
    getUnReadMsgRequest=[[UserLoadUnReceivedChat alloc]initWithRequestWithDic:dic];
    getUnReadMsgRequest.delegate=self;
    [[NSNotificationCenter defaultCenter]postNotificationName:DXQChatMessageWillGetUnReadMessageNotification object:dic];
    [getUnReadMsgRequest startAsynchronous];
}

-(void)cancelGetUnReadMessage{

    if (getUnReadMsgRequest) {
        [getUnReadMsgRequest cancel];
        [getUnReadMsgRequest release];
        getUnReadMsgRequest=nil;
    }
}

#pragma mark-RequestDelegate

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    if (request==getUnReadMsgRequest) {
        [self getUnReadMessage];
    }
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    if (request==getUnReadMsgRequest) {
        [self postNewChatMessageArray:data];
        [[NSNotificationCenter defaultCenter]postNotificationName:DXQChatMessageDidGetUnReadMessageNotification object:data];
    }
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

@implementation SendMessageEntity

@synthesize chatMsg;
@synthesize target;

-(id)init{

    self=[super init];
    if (self) {
        chatMsg=nil;
        target=nil;
    }
    return self;
}

-(void)dealloc{

    [chatMsg release];
    target=nil;
    [super dealloc];
}

@end