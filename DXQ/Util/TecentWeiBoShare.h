//
//  TecentWeiBoShare.h
//  DXQ
//
//  Created by Yuan on 12-12-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCWBEngine.h"

@protocol TecentWeiBoShareDelegate <NSObject>

@optional

-(void)TecentWeiBoShareBindSuccessed;

-(void)TecentWeiBoShareBindFailure;

-(void)TecentWeiBoShareRequestFailure;

-(void)TecentWeiBoShareRequestSuccessed;

@end


@interface TecentWeiBoShare : NSObject
{
    id<TecentWeiBoShareDelegate>delegate;

    TCWBEngine                  *weiboEngine;
}
@property (nonatomic,assign)id<TecentWeiBoShareDelegate>delegate;

@property (nonatomic, retain) TCWBEngine   *weiboEngine;

+(TecentWeiBoShare*)sharedTecentWeiBoShare;

- (void)onLogin;

- (void)postMessage:(NSString *)msg;

- (void)postMessage:(NSString *)msg withImage:(NSData *)data;

@end
