//
//  ForgotPswRequest.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-28.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ForgotPswRequest.h"

@implementation ForgotPswRequest

-(void)dealloc{

    [_paramDic release];
    [super dealloc];
}

-(ForgotPswRequest *)initRequestWithDic:(NSDictionary *)dic{

    self=[super initWithBackendManagerName:@"uim"];
    if (self) {
        self.paramDic=dic;
    }
    return self;
}

- (NSString *)actionName
{
    return @"UserResetPassword";
}

- (NSString *)parameterJSONString
{
    NSMutableDictionary *pDict = [self defaultParameterDic];
    [pDict addEntriesFromDictionary:self.paramDic];
    NSString * jsonString = [[NSString alloc] initWithString:[pDict JSONRepresentation]];
    [pDict release];
    return [jsonString autorelease];
}


#pragma mark -ASIHTTPRequestDelegate

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
            if(self.delegate && [self.delegate respondsToSelector:@selector(forgotPswRequestDidFinishedWithParamters:)])
            {
                objc_msgSend(self.delegate, @selector(forgotPswRequestDidFinishedWithParamters:),outputDic);
            }
        }
        else
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(forgotPswRequestDidFinishedWithErrorMessage:)])
            {
                objc_msgSend(self.delegate, @selector(forgotPswRequestDidFinishedWithErrorMessage:),errorCodeString);
            }
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(forgotPswRequestDidFinishedWithErrorMessage:)])
        {
            objc_msgSend(self.delegate, @selector(forgotPswRequestDidFinishedWithErrorMessage:),AppLocalizedString(@"请求数据错误"));
        }
    }
}


- (void)requestDidFailed:(ASIHTTPRequest *)theRequest
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(forg)])
    {
        objc_msgSend(self.delegate, @selector(forgotPswRequestDidFinishedWithErrorMessage:),AppLocalizedString(@"网络错误"));
    }
}


@end
