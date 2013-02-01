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
#import "UserLoadPersonalPage.h"

@interface ChatMessageCenter ()<BusessRequestDelegate>{

    NSMutableArray *chatObserArray;
    NSMutableArray *chatMsgArray;
    NSMutableArray *chatMsgNumObserArray;
    NSMutableArray *sendAndNotReceviecArray;
    UserLoadUnReceivedChat *getUnReadMsgRequest;
    NSMutableArray *requestUserDetailIDs;
    NSMutableArray *userDetailObserve;
}

@end

NSString *const DXQChatMessageWillGetUnReadMessageNotification=@"DXQChatMessageWillGetUnReadMessageNotification";
NSString *const DXQChatMessageDidGetUnReadMessageNotification=@"DXQChatMessageDidGetUnReadMessageNotification";
NSString *const DXQChatMessageGetNewMessage=@"DXQChatMessageGetNewMessage";

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
        requestUserDetailIDs=[NSMutableArray new];
        userDetailObserve=[NSMutableArray new];
    }
    return self;
}

-(void)dealloc{

    [chatMsgArray release];
    [chatObserArray release];
    [chatMsgNumObserArray release];
    [sendAndNotReceviecArray release];
    [requestUserDetailIDs release];
    [userDetailObserve release];
    [super dealloc];
}

-(void)postNewChatMessage:(id)msg{

    if ([[(NSDictionary *)msg allKeys]containsObject:@"AccountTo"]) {
        if ([[msg objectForKey:@"AccountFrom"] isEqualToString:[[SettingManager sharedSettingManager]loggedInAccount]]) {
            //chat msg is send success
            [self chatMsgIsSend:msg];
            return;
        }
        NSString *tempAccountID=[msg objectForKey:@"AccountFrom"];
        NSDictionary *tempChatUserDic=[NSDictionary dictionaryWithObjectsAndKeys:
                                       tempAccountID,@"AccountId",tempAccountID,@"MemberName",@"",@"PhotoUrl",@"",@"Introduction", nil];

        [self requestUserDefailtInfoByID:tempAccountID];
        [[SettingManager sharedSettingManager]addLastestContact:tempChatUserDic];
        [msg chatHistory];
        [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
        
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
        [[NSNotificationCenter defaultCenter]postNotificationName:DXQChatMessageGetNewMessage object:msg];
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
            NSString *tempAccountID=[msg objectForKey:@"AccountFrom"];
            NSDictionary *tempChatUserDic=[NSDictionary dictionaryWithObjectsAndKeys:
                                           tempAccountID,@"AccountId",tempAccountID,@"MemberName",@"",@"PhotoUrl",@"",@"Introduction", nil];
            if (![[SettingManager sharedSettingManager]isContentAndHadDetailInfomationInLastest:tempChatUserDic]) {
                [self requestUserDefailtInfoByID:tempAccountID];
            }

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

-(NSInteger)getMsgNumberWithChatName:(NSString *)chatName{

    NSInteger number=0;
    for (int i=0; i<chatMsgArray.count; i++) {
        NSDictionary *dic=[chatMsgArray objectAtIndex:i];
        if ([[dic objectForKey:@"AccountFrom"] isEqualToString:chatName]) {
            number++;
        }
    }
    return number;
}

-(NSInteger)getAllMsgNumber
{
    return [chatMsgArray count];
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

//    
//    ChatHistory *chat=[msgDic chatHistory];
//    [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
    
    if(![[DXQWebSocket sharedWebSocket]isOpen])
    {
        if (target&&[target respondsToSelector:@selector(chatMessage:sendFailedWithError:)]) {
            NSError *error=[NSError errorWithDomain:@"Chat Message" code:100 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Socket is not connection", nil]];
            [target chatMessage:msgDic sendFailedWithError:error];
        }
        return;
    }
    
    SendMessageEntity *send=[[SendMessageEntity alloc]init];
    send.chatMsg=msgDic;
    send.target=target;
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
    
    if (![sendAndNotReceviecArray containsObject:entity]) {
        return;
    }
    if (entity.target&&[entity.target respondsToSelector:@selector(chatMessage:sendFailedWithError:)]) {
        NSError *error=[NSError errorWithDomain:@"Chat Message" code:101 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Send message time out", nil]];
        [entity.target chatMessage:entity.chatMsg sendFailedWithError:error];
    }
    [sendAndNotReceviecArray removeObject:entity];
}

-(void)chatMsgIsSend:(NSDictionary *)dic
{
    for (int i=0; i<sendAndNotReceviecArray.count; i++) {
        SendMessageEntity *chat=[sendAndNotReceviecArray objectAtIndex:i];
        if ([[chat.chatMsg objectForKey:@"Content"] isEqualToString:[dic objectForKey:@"Content"]]&&
            [[chat.chatMsg objectForKey:@"AccountFrom"] isEqualToString:[dic objectForKey:@"AccountFrom"]]&&
            [[chat.chatMsg objectForKey:@"AccountTo"] isEqualToString:[dic objectForKey:@"AccountTo"]]) {
            [dic chatHistory];
            [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
            if (chat.target&&[chat.target respondsToSelector:@selector(chatMessageDidSend:)]) {
                [chat.target chatMessageDidSend:dic];
            }
            [sendAndNotReceviecArray removeObject:chat];
            return;
        }
    }
}

-(void)removeChatMsgSendStateObserver:(id)target{

    NSMutableArray *tempRemmove=[NSMutableArray array];
    for (SendMessageEntity *chat in sendAndNotReceviecArray) {
        if (chat.target==target) {
            [tempRemmove addObject:chat];
        }
    }
    [sendAndNotReceviecArray removeObjectsInArray:tempRemmove];
}

-(NSArray *)getHistoryChatMsgFromUser:(NSString *)userID number:(NSInteger)number page:(NSInteger)page{


    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *managedObjectContext =[[DXQCoreDataManager sharedCoreDataManager]managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChatHistory" inManagedObjectContext:managedObjectContext];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc]
                                         initWithKey:@"dxq_OpTime" ascending:NO];
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(dxq_AccountFrom==%@ and dxq_AccountTo==%@) or (dxq_AccountFrom==%@ and dxq_AccountTo==%@)",userID,[[SettingManager sharedSettingManager]loggedInAccount],[[SettingManager sharedSettingManager]loggedInAccount],userID];
    NSArray *sortDescriptors = [[NSArray alloc]
                                initWithObjects:sortDescriptor1, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:number];
    [fetchRequest setFetchOffset:page*number];
    NSArray *objecs = [managedObjectContext executeFetchRequest: fetchRequest error:nil];
    NSMutableArray *tempArray=[NSMutableArray array];
    for (int i=objecs.count-1; i>=0; i--) {
        [tempArray addObject:[(ChatHistory *)[objecs objectAtIndex:i] chatDictionary]];
    }
    
    return tempArray;
}

-(BOOL)deleteHistoryChatMsgByDic:(NSDictionary *)dic{

//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSManagedObjectContext *managedObjectContext =[[DXQCoreDataManager sharedCoreDataManager]managedObjectContext];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChatHistory" inManagedObjectContext:managedObjectContext];
    
     //{"AccountFrom":"1@1.cn","AccountTo":"13800138000","OpTime":"1359638019","IsReceived":"1","Face":"","Picture":"","Content":"8J+YivCfmITwn5iE8J+Gl/CfjLnimIA=","JingDu":0.0,"WeiDu":0.0,"Id":590}
    
//    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc]
//                                         initWithKey:@"dxq_OpTime" ascending:NO];
//    NSMutableString *formatter=[NSMutableString stringWithFormat:@"dxq_AccountFrom==%@ and dxq_AccountTo==%@ and dxq_Content==%@ ",[dic objectForKey:@"AccountFrom"],
//                                [dic objectForKey:@"AccountTo"],[dic objectForKey:@"Content"],[Tool convertTimestampToNSDate:[dic objectForKey:@""] dateStyle:<#(NSString *)#>]];
//    if ([[dic allKeys]containsObject:@"OpTime"]) {
//        <#statements#>
//    }
//    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"",userID,[[SettingManager sharedSettingManager]loggedInAccount],[[SettingManager sharedSettingManager]loggedInAccount],userID];
//    NSArray *sortDescriptors = [[NSArray alloc]
//                                initWithObjects:sortDescriptor1, nil];
//    [fetchRequest setSortDescriptors:sortDescriptors];
//    [fetchRequest setEntity:entity];
//    [fetchRequest setPredicate:predicate];

}

-(BOOL)deleteHistoryChatMsgArray:(NSArray *)array{

}
-(NSString *)getLastChatMsgByChatName:(NSString *)chatName{

    NSArray *array=[self getHistoryChatMsgFromUser:chatName number:1 page:0];
    if (array.count>0) {
        NSDictionary *chatHistory=[array objectAtIndex:0];
        return [chatHistory objectForKey:@"Content"];
    }else
        return nil;
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
    }else
    {
        NSString *tempID=[request.paramDic objectForKey:@"AccountFrom"];
        [requestUserDetailIDs removeObject:tempID];
        [request release];
    }
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    if (request==getUnReadMsgRequest) {
        [self postNewChatMessageArray:data];
        [[NSNotificationCenter defaultCenter]postNotificationName:DXQChatMessageDidGetUnReadMessageNotification object:data];
    }else
    {
        NSString *tempID=[request.paramDic objectForKey:@"AccountId"];
        [requestUserDetailIDs removeObject:tempID];
        [[SettingManager sharedSettingManager]addLastestContact:[data objectForKey:@"Info"]];
        [request release];
        NSMutableArray *tempRemove=[NSMutableArray new];
        for (ChatUserDetailObserve *tempObject in userDetailObserve) {
            if ([tempObject.userID isEqualToString:tempID]) {
                [tempObject.target performSelector:tempObject.action withObject:[data objectForKey:@"Info"]];
                [tempRemove addObject:tempObject];
            }
        }
        [userDetailObserve removeObjectsInArray:tempRemove];
        [tempRemove release];
    }
}

//for request user detail
-(BOOL)isRequestDetailByID:(NSString *)userID{

    return [requestUserDetailIDs containsObject:userID];
}

-(void)addUserInfoDetailObserve:(id)observe action:(SEL)action userID:(NSString *)userID{

    ChatUserDetailObserve *tempObserve=[[ChatUserDetailObserve alloc]init];
    tempObserve.target=observe;
    tempObserve.action=action;
    tempObserve.userID=userID;
    [userDetailObserve addObject:tempObserve];
    [tempObserve release];
}

-(void)removeUserObserByTarget:(id)target userName:(NSString *)userId{

    NSMutableArray *tempRemove=[NSMutableArray new];
    for (ChatUserDetailObserve *tempObserve in userDetailObserve) {
        if (tempObserve.target==target||[tempObserve.userID isEqualToString:userId]) {
            [tempRemove addObject:tempObserve];
        }
    }
    [userDetailObserve removeObjectsInArray:tempRemove];
    [tempRemove release];
}

#pragma mark --Request

-(void)requestUserDefailtInfoByID:(NSString *)tempID
{
    if ([requestUserDetailIDs containsObject:tempID]) {
        return;
    }
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[[SettingManager sharedSettingManager]loggedInAccount],@"AccountFrom",tempID,@"AccountId", nil];
    UserLoadPersonalPage *request=[[UserLoadPersonalPage alloc]initWithRequestWithDic:dic];
    request.delegate=self;
    [requestUserDetailIDs addObject:tempID];
    [request startAsynchronous];
}


- (void)userInfoDetailRequestDidFinishedWithParamters:(NSDictionary *)dic{

    
}

- (void)userInfoDetailRequestDidFinishedWithErrorMessage:(NSString *)errorMsg{

    
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

@implementation ChatUserDetailObserve

-(void)dealloc{

    _target=nil;
    _action=nil;
    [_userID release];
    [super dealloc];
}

@end