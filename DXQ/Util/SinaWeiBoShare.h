//
//  SinaWeiBoShare.h
//  DXQ
//
//  Created by Yuan on 12-12-9.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@protocol SinaWeiBoShareDelegate <NSObject>

@optional

-(void)SinaWeiBoShareBindSuccessed;

-(void)SinaWeiBoShareBindFailure;

-(void)SinaWeiBoShareRequestFailure;

-(void)SinaWeiBoShareRequestSuccessed;

@end

@interface SinaWeiBoShare : NSObject<SinaWeiboDelegate, SinaWeiboRequestDelegate>
{
    id<SinaWeiBoShareDelegate>delegate;
    
    SinaWeibo *sinaweibo;
}
@property (nonatomic,assign)id<SinaWeiBoShareDelegate>delegate;

@property (readonly, nonatomic) SinaWeibo *sinaweibo;

+(SinaWeiBoShare*)sharedSinaWeiBo;

-(void)loginSinaWeibo;

-(void)logoutSinaWeibo;

-(void)postTextMessage:(NSString *)msg;

-(void)postTextMessage:(NSString *)msg withImage:(UIImage *)img;

@end
