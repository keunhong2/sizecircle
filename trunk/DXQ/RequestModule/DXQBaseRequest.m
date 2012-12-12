//
//  DXQBaseRequest.m
//  DXQ
//
//  Created by Yuan on 12-10-12.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQBaseRequest.h"

@implementation DXQBaseRequest

@synthesize request = _request;
@synthesize managerName = _managerName;
@synthesize actionName = _actionName;
@synthesize parameterJSONString = _parameterJSONString;

- (DXQBaseRequest *)initWithBackendManagerName:(NSString*)managerName_
{
    if (self = [super init])
    {
        self.managerName = managerName_;
        NSURL *requstURL = [NSURL URLWithString:WebServiceURL];
        self.request = [ASIFormDataRequest requestWithURL:requstURL];
        [self.request setTimeOutSeconds:kServerRequest_Timeout];
        self.request.delegate=self;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
        [self.request setShouldContinueWhenAppEntersBackground:YES];
#endif
        [self.request setDelegate:self];
        [self.request setDidStartSelector:@selector(requestDidStarted:)];
        [self.request setDidFailSelector:@selector(requestDidFailed:)];
        [self.request setDidFinishSelector:@selector(requestDidFinished:)];
    }
    return self;
}

//同步请求
- (void)startSynchronous
{
    [self.request setPostValue:self.managerName forKey:@"m"];
    [self.request setPostValue:self.actionName forKey:@"a"];
    [self.request setPostValue:self.parameterJSONString forKey:@"p"];
    [self.request startSynchronous];
}

//异步请求
- (void)startAsynchronous
{
    [self.request setPostValue:self.managerName forKey:@"m"];
    [self.request setPostValue:self.actionName forKey:@"a"];
    [self.request setPostValue:self.parameterJSONString forKey:@"p"];
    [self.request startAsynchronous];
}

- (NSString *)actionName
{
    return nil;
}

- (NSString *)parameterJSONString
{
    return nil;
}

- (NSMutableDictionary *)defaultParameterDic
{
    NSMutableDictionary *defautsDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil, nil];
    SettingManager *settingsManager = [SettingManager sharedSettingManager];
    [defautsDic setObject:[settingsManager getProtocolVersion] forKey:@"protocolv"];
    [defautsDic setObject:[settingsManager appVersion] forKey:@"appv"];
    //使用时释放
    return defautsDic;
}

-(void)cancel
{
    [request clearDelegatesAndCancel];
}
#pragma mark -
#pragma mark Request Callback
- (void)requestDidStarted:(ASIHTTPRequest *)theRequest
{
    HYLog(@"start request");
}

- (void)requestDidFailed:(ASIHTTPRequest *)theRequest
{
    NSString *errorMessage = [NSString stringWithFormat:@"Request failed:\r\n%@",[[theRequest error] localizedDescription]];
    HYLog(@"error = %@", errorMessage);
}

- (void)requestDidFinished:(ASIHTTPRequest *)theRequest
{
    // this must implement in subclass
}

- (void)dealloc
{
    [_actionName release];_actionName = nil;
    [_parameterJSONString release]; _parameterJSONString = nil;
    [_managerName release];_managerName = nil;
    [_request setDelegate:nil];
    [_request release];_request = nil;
    [super dealloc];
}
@end
