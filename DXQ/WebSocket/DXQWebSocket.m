//
//  YKWebSocket.m
//
//  Created by he yuan on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DXQWebSocket.h"

@implementation DXQWebSocket
@synthesize isSignIn;

static DXQWebSocket *shareWS = nil;

+(DXQWebSocket*)sharedWebSocket
{
    @synchronized(self)
    {    
        if (!shareWS)
        {
            shareWS = [[DXQWebSocket alloc]init];
        }
    }
    return shareWS;
}

- (id)init
{
	if ((self = [super init])) // Initialize
	{
        handleSocketQueue = [[NSOperationQueue alloc] init]; //新建一个队列
        [handleSocketQueue setMaxConcurrentOperationCount:1];
        [handleSocketQueue setSuspended:NO];
	}
	return self;
}

//链接websocket
- (void)reconnetWebSocket
{
    //开始链接
    HYLog(@"开始连接...");
    if (webSocket)
    {
        webSocket.delegate = nil;
        [webSocket close];
        [webSocket release];
        webSocket = nil;
    }
    isSignIn = NO;
    NSURL *nsUrl = [NSURL URLWithString:WebSocketURL];
    webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:nsUrl]];
    webSocket.delegate = self;
    [webSocket open];
}

- (BOOL)isOpen
{
    if (webSocket && [webSocket isOpen])
    {
        return YES;
    }
    return NO;
}

//发送消息
-(void)sendMessage:(NSString *)mes
{
    if (webSocket && [webSocket isOpen] && mes&&[mes length]>0)
    {
        [webSocket send:mes];
    }
}

//关闭链接
-(void)closeWebSocket
{
    if (webSocket)
    {
        webSocket.delegate = nil;
        [webSocket close];
        [webSocket release];
        webSocket = nil;
    }
    isSignIn = NO;
    
    HYLog(@"websocket 已经断开链接");
}

#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket_;
{
    //如果在程序运行期间socket断开重新连接了就重新登陆
    SettingManager *sm = [SettingManager sharedSettingManager];
    if (!isSignIn && [sm getTempAccountID] && [sm getTempAccountPassword])
    {
        [[AppDelegate sharedAppDelegate] signInWithAccount:[sm getTempAccountID] password:[sm getTempAccountPassword]];
    }
    HYLog(@"Socket 连接成功");
}

- (void)webSocket:(SRWebSocket *)webSocket_ didFailWithError:(NSError *)error;
{
    HYLog(@"Socket 连接出错，开始重新连接");
    isSignIn = NO;
    webSocket_ = nil;
    [self reconnetWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket_ didReceiveMessage:(id)message;
{
    HYLog(@"%@",[NSString stringWithFormat:@"Socket 收到数据--->%@",message]);
    NSDictionary *receiveDict = [[Tool TrimJsonChar:message] JSONValue];
    if (receiveDict && [[receiveDict objectForKey:@"a"] isEqualToString:@"UserChatWithFriend"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATIONCENTER_RECEIVED_MESSAGES object:nil userInfo:[receiveDict objectForKey:@"o"]];
    }
    else  if(receiveDict &&[[receiveDict objectForKey:@"a"] isEqualToString:@"UserLogIn"]) //登陆返回
    {
        NSString *errorCodeString = [receiveDict objectForKey:@"e"];
        if([errorCodeString isEqualToString:@"0000"])
        {
            [[AppDelegate sharedAppDelegate]signInRequestDidFinishedWithParamters:[receiveDict objectForKey:@"o"]];
        }
        else
        {
            [[AppDelegate sharedAppDelegate]signInRequestDidFinishedWithErrorMessage:errorCodeString];
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket_ didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    HYLog(@"socket 断开了连接，开始重新连接");
    webSocket_ = nil;
    [self reconnetWebSocket];
}

@end
