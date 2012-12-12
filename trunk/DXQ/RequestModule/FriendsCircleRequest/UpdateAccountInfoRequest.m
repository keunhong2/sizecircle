//
//  UpdateAccountInfoRequest.m
//  DXQ
//
//  Created by Yuan on 12-11-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UpdateAccountInfoRequest.h"

@implementation UpdateAccountInfoRequest

-(UpdateAccountInfoRequest *)initRequestWithDic:(NSDictionary *)dic{
    
    if((self = (UpdateAccountInfoRequest *)[super initWithBackendManagerName:@"uim"]))
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
    return @"UserUpdateProfessionalInfo";
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
            NSDictionary *outputDic = [responseDic objectForKey:@"o"];
            if(self.delegate && [self.delegate respondsToSelector:@selector(updateAccountInfoRequestDidFinishedWithParamters:)])
            {
                objc_msgSend(self.delegate, @selector(updateAccountInfoRequestDidFinishedWithParamters:),outputDic);
            }
        }
        else
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(UpdateAccountInfoRequestDidFinishedWithErrorMessage:)])
            {
                objc_msgSend(self.delegate, @selector(UpdateAccountInfoRequestDidFinishedWithErrorMessage:),errorCodeString);
            }
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(UpdateAccountInfoRequestDidFinishedWithErrorMessage:)])
        {
            objc_msgSend(self.delegate, @selector(UpdateAccountInfoRequestDidFinishedWithErrorMessage:),AppLocalizedString(@"服务出错,稍后再试..."));
        }
    }
}

- (void)requestDidFailed:(ASIHTTPRequest *)theRequest
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(UpdateAccountInfoRequestDidFinishedWithErrorMessage:)])
    {
        objc_msgSend(self.delegate, @selector(UpdateAccountInfoRequestDidFinishedWithErrorMessage:),AppLocalizedString(@"网络错误"));
    }
}

@end