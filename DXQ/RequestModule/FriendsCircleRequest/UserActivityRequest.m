//
//  UserActivityRequest.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-5.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UserActivityRequest.h"

@implementation UserActivityRequest

- (UserActivityRequest *)initRequestWithDic:(NSDictionary *)dic
{
    if((self = (UserActivityRequest *)[super initWithBackendManagerName:@"uim"]))
    {
        self.paramDic = dic;
    }
    return self;
}

- (void)dealloc
{
    [_paramDic release];_paramDic = nil;
    [super dealloc];
}

- (NSString *)actionName
{
    return @"UserLoadNewsList";
}


- (NSString *)parameterJSONString
{
    NSMutableDictionary *pDict = [self defaultParameterDic];
    [pDict addEntriesFromDictionary:self.paramDic];
    NSString * jsonString = [[NSString alloc] initWithString:[pDict JSONRepresentation]];
    [pDict release];
    return [jsonString autorelease];
}

#pragma mark -
#pragma mark Request Callback
- (void)requestDidFinished:(ASIHTTPRequest *)theRequest
{
     NSString *responseString = [[[NSString alloc] initWithData:[theRequest responseData] encoding:NSUTF8StringEncoding] autorelease];
    responseString = [Tool TrimJsonChar:responseString];
    NSDictionary *responseDic = [responseString JSONValue];
    HYLog(@"%@",responseDic);
    if(responseDic != nil)
    {
        NSString *errorCodeString = [responseDic objectForKey:@"e"];
        
        if([errorCodeString isEqualToString:@"0000"])
        {
            NSArray *outputDic = [responseDic objectForKey:@"o"];
            if(self.delegate && [self.delegate respondsToSelector:@selector(userActivityRequestDidFinishedWithParamters:)])
            {
                objc_msgSend(self.delegate, @selector(userActivityRequestDidFinishedWithParamters:),outputDic);
            }
        }
        else
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(userActivityRequestDidFinishedWithErrorMessage:)])
            {
                objc_msgSend(self.delegate, @selector(userActivityRequestDidFinishedWithErrorMessage:),errorCodeString);
            }
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(userActivityRequestDidFinishedWithErrorMessage:)])
        {
            objc_msgSend(self.delegate, @selector(userActivityRequestDidFinishedWithErrorMessage:),AppLocalizedString(@"服务出错,稍后再试..."));
        }
    }
}

- (void)requestDidFailed:(ASIHTTPRequest *)theRequest
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(userActivityRequestDidFinishedWithErrorMessage:)])
    {
        objc_msgSend(self.delegate, @selector(userActivityRequestDidFinishedWithErrorMessage:),AppLocalizedString(@"网络错误"));
    }
}


@end
