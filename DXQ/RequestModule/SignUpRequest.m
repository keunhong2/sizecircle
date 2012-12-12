//
//  SignUpRequest.m
//  DXQ
//
//  Created by Yuan on 12-10-12.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "SignUpRequest.h"

@implementation SignUpRequest
@synthesize paramDic = _paramDic;
@synthesize delegate = _delegate;

- (SignUpRequest *)initRequestWithDic:(NSDictionary *)dic
{
    if((self = (SignUpRequest *)[super initWithBackendManagerName:@"uim"]))
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
    return @"UserRegister";
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
            if(self.delegate && [self.delegate respondsToSelector:@selector(signUpRequestDidFinishedWithParamters:)])
            {
                objc_msgSend(self.delegate, @selector(signUpRequestDidFinishedWithParamters:),outputDic);
            }
        }
        else
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(signUpRequestDidFinishedWithErrorMessage:)])
            {
                objc_msgSend(self.delegate, @selector(signUpRequestDidFinishedWithErrorMessage:),errorCodeString);
            }
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(signUpRequestDidFinishedWithErrorMessage:)])
        {
            objc_msgSend(self.delegate, @selector(signUpRequestDidFinishedWithErrorMessage:),AppLocalizedString(@"请求数据错误"));
        }
    }
}

- (void)requestDidFailed:(ASIHTTPRequest *)theRequest
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(signUpRequestDidFinishedWithErrorMessage:)])
    {
        objc_msgSend(self.delegate, @selector(signUpRequestDidFinishedWithErrorMessage:),AppLocalizedString(@"网络错误"));
    }
}
@end
