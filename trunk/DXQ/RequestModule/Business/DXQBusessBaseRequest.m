//
//  DXQBusessBaseRequest.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-7.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQBusessBaseRequest.h"

@implementation DXQBusessBaseRequest

-(void)dealloc{

    [_paramDic release];_paramDic=nil;_delegate=nil;
    [super dealloc];
}

-(id)init{

    return [self initWithRequestWithDic:nil];
}

-(id)initWithRequestWithDic:(NSDictionary *)dic{

    self=[super initWithBackendManagerName:@"uim"];//
    if (self) {
        self.paramDic=dic;
    }
    return self;
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
            if(self.delegate && [self.delegate respondsToSelector:@selector(busessRequest:didFinishWithData:)])
            {
                objc_msgSend(self.delegate, @selector(busessRequest:didFinishWithData:),self,outputDic);
            }
        }
        else
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(busessRequest:didFailedWithErrorMsg:)])
            {
                objc_msgSend(self.delegate, @selector(busessRequest:didFailedWithErrorMsg:),self,errorCodeString);
            }
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(busessRequest:didFailedWithErrorMsg:)])
        {
            objc_msgSend(self.delegate, @selector(busessRequest:didFailedWithErrorMsg:),self,AppLocalizedString(@"服务出错,稍后再试..."));
        }
    }
}

- (void)requestDidFailed:(ASIHTTPRequest *)theRequest
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(busessRequest:didFailedWithErrorMsg:)])
    {
        objc_msgSend(self.delegate, @selector(busessRequest:didFailedWithErrorMsg:),self,AppLocalizedString(@"网络错误"));
    }
}

@end
