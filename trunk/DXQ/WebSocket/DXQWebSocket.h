//
//  YKWebSocket.h
//
//  Created by he yuan on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"
#import "HandSocketOperation.h"

@interface DXQWebSocket: NSObject<SRWebSocketDelegate>
{
    NSOperationQueue *handleSocketQueue;
    SRWebSocket *webSocket;
    BOOL isSignIn;
}
@property(nonatomic) BOOL isSignIn;

+(DXQWebSocket*)sharedWebSocket;

- (void)reconnetWebSocket;

- (BOOL)isOpen;

-(void)sendMessage:(NSString *)mes;

-(void)closeWebSocket;


@end
