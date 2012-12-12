//
//  TecentWeiBoShare.m
//  DXQ
//
//  Created by Yuan on 12-12-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "TecentWeiBoShare.h"
#import "AppDelegate.h"

static TecentWeiBoShare *swb = nil;

@implementation TecentWeiBoShare
@synthesize weiboEngine;
@synthesize delegate;

- (void)dealloc
{
    [weiboEngine release];
    [super dealloc];
}


+(TecentWeiBoShare*)sharedTecentWeiBoShare
{
    @synchronized(self)
    {
        if (swb == nil)
        {
            swb = [[TecentWeiBoShare alloc]init];
        }
        return swb;
    }
    return nil;
}


-(id)init
{
    self = [super init];
    if (self)
    {
        weiboEngine = [[TCWBEngine alloc] initWithAppKey:WiressSDKDemoAppKey andSecret:WiressSDKDemoAppSecret andRedirectUrl:REDIRECTURI];
        [weiboEngine setRootViewController:(UIViewController*)[AppDelegate sharedAppDelegate].menuController];
    }
    return self;
}

//登录
- (void)onLogin
{
    if ([[self.weiboEngine openId] length] > 0)
    {
        //已经登陆了
        [self onSuccessLogin];
    }
    else
    {
        //未登陆
        [weiboEngine logInWithDelegate:self
                             onSuccess:@selector(onSuccessLogin)
                             onFailure:@selector(onFailureLogin:)];
    }

}

//登录成功回调
- (void)onSuccessLogin
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TecentWeiBoShareBindSuccessed)])
    {
        [self.delegate TecentWeiBoShareBindSuccessed];
    }
}

//登录失败回调
- (void)onFailureLogin:(NSError *)error
{
    NSString *message = [[NSString alloc] initWithFormat:@"%@",[NSNumber numberWithInteger:[error code]]];
    HYLog(@"%@",message);
    [message release];
    if (self.delegate && [self.delegate respondsToSelector:@selector(TecentWeiBoShareBindFailure)])
    {
        [self.delegate TecentWeiBoShareBindFailure];
    }
}

- (void)postMessage:(NSString *)msg
{
    if ([[self.weiboEngine openId] length] > 0)
    {
        [self.weiboEngine postTextTweetWithFormat:@"json" content:msg clientIP:nil longitude:nil andLatitude:nil parReserved:nil delegate:self onSuccess:@selector(createSuccess:) onFailure:@selector(createFail:)];
    }
    else
    {
        [self onLogin];
    }
}

- (void)postMessage:(NSString *)msg withImage:(NSData *)data
{
    if ([[self.weiboEngine openId] length] > 0)
    {
    [self.weiboEngine postPictureTweetWithFormat:@"json" content:msg clientIP:nil pic:data compatibleFlag:nil longitude:nil andLatitude:nil parReserved:nil delegate:self onSuccess:@selector(createSuccess:) onFailure:@selector(createFail:)];
    }
    else
    {
        [self onLogin];
    }
}

- (void)createSuccess:(NSDictionary *)dict
{
    NSLog(@"%s %@", __FUNCTION__,dict);
    if ([[dict objectForKey:@"ret"] intValue] == 0)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(TecentWeiBoShareRequestSuccessed)])
        {
            [self.delegate TecentWeiBoShareRequestSuccessed];
        }
        [self showAlertMessage:@"分享成功！"];
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(TecentWeiBoShareRequestFailure)])
        {
            [self.delegate TecentWeiBoShareRequestFailure];
        }
        [self showAlertMessage:@"分享失败！"];
    }
}

- (void)createFail:(NSError *)error
{
    NSLog(@"error is %@",error);
    if (self.delegate && [self.delegate respondsToSelector:@selector(TecentWeiBoShareRequestFailure)])
    {
        [self.delegate TecentWeiBoShareRequestFailure];
    }
    [self showAlertMessage:@"分享失败！"];
}

- (void)showAlertMessage:(NSString *)msg {
    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil
                                                       message:msg
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    
}


@end
