//
//  SinaWeiBoShare.m
//  DXQ
//
//  Created by Yuan on 12-12-9.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "SinaWeiBoShare.h"

static SinaWeiBoShare *swb = nil;

@implementation SinaWeiBoShare
@synthesize sinaweibo;
@synthesize delegate;

- (void)dealloc
{
    [sinaweibo release];
    [super dealloc];
}

+(SinaWeiBoShare*)sharedSinaWeiBo
{
    @synchronized(self)
    {
        if (swb == nil)
        {
            swb = [[SinaWeiBoShare alloc]init];
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
        sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
        {
            sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
            sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
            sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        }
    }
    return self;
}

//移除数据
- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

//保存授权数据
- (void)storeAuthData
{    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//登陆
-(void)loginSinaWeibo
{
    [sinaweibo logIn];
}

//登出
-(void)logoutSinaWeibo
{
    [sinaweibo logOut];
}

#pragma mark - SinaWeibo Delegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo_
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
    [self storeAuthData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SinaWeiBoShareBindSuccessed)]) {
        [self.delegate SinaWeiBoShareBindSuccessed];
    }
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SinaWeiBoShareBindFailure)]) {
        [self.delegate SinaWeiBoShareBindFailure];
    }
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
    if (self.delegate && [self.delegate respondsToSelector:@selector(SinaWeiBoShareBindFailure)]) {
        [self.delegate SinaWeiBoShareBindFailure];
    }
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SinaWeiBoShareBindFailure)])
    {
        [self.delegate SinaWeiBoShareBindFailure];
    }
}

//分享文字消息
-(void)postTextMessage:(NSString *)msg
{
    if (!sinaweibo.isAuthValid)
    {
        return [self loginSinaWeibo];
    }
    [sinaweibo requestWithURL:@"statuses/update.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:msg, @"status", nil]
                   httpMethod:@"POST"
                     delegate:self];
}

//分享文字和图片消息
-(void)postTextMessage:(NSString *)msg withImage:(UIImage *)img
{
    if (!sinaweibo.isAuthValid)
    {
        return [self loginSinaWeibo];
    }
    [sinaweibo requestWithURL:@"statuses/upload.json"
                       params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                               msg, @"status",
                               img, @"pic", nil]
                   httpMethod:@"POST"
                     delegate:self];
}

#pragma mark - SinaWeiboRequest Delegate
//请求成功的回调
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",result);
    
   if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"分享成功!"
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"分享图片成功!"
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SinaWeiBoShareRequestSuccessed)])
    {
        [self.delegate SinaWeiBoShareRequestSuccessed];
    }
}

//请求失败的回调
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"分享失败"
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"分享失败"
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        [alertView release];
        NSLog(@"Post image status failed with error : %@", error);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(SinaWeiBoShareRequestFailure)])
    {
        [self.delegate SinaWeiBoShareRequestFailure];
    }
}

@end
