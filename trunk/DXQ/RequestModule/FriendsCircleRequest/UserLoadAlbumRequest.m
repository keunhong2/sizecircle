//
//  UserLoadAlbumRequest.m
//  DXQ
//
//  Created by Yuan on 12-11-29.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UserLoadAlbumRequest.h"

@implementation UserLoadAlbumRequest

-(UserLoadAlbumRequest *)initRequestWithDic:(NSDictionary *)dic{
    
    if((self = (UserLoadAlbumRequest *)[super initWithBackendManagerName:@"uim"]))
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
    return @"UserLoadAlbum";
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
            id outputDic = [responseDic objectForKey:@"o"];
            if(self.delegate && [self.delegate respondsToSelector:@selector(userLoadAlbumRequestDidFinishedWithParamters:)])
            {
                objc_msgSend(self.delegate, @selector(userLoadAlbumRequestDidFinishedWithParamters:),outputDic);
            }
        }
        else
        {
            if(self.delegate && [self.delegate respondsToSelector:@selector(userLoadAlbumRequestDidFinishedWithErrorMessage:)])
            {
                objc_msgSend(self.delegate, @selector(userLoadAlbumRequestDidFinishedWithErrorMessage:),errorCodeString);
            }
        }
    }
    else
    {
        if(self.delegate && [self.delegate respondsToSelector:@selector(userLoadAlbumRequestDidFinishedWithErrorMessage:)])
        {
            objc_msgSend(self.delegate, @selector(userLoadAlbumRequestDidFinishedWithErrorMessage:),AppLocalizedString(@"服务出错,稍后再试..."));
        }
    }
}

- (void)requestDidFailed:(ASIHTTPRequest *)theRequest
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(userLoadAlbumRequestDidFinishedWithErrorMessage:)])
    {
        objc_msgSend(self.delegate, @selector(userLoadAlbumRequestDidFinishedWithErrorMessage:),AppLocalizedString(@"网络错误"));
    }
}

@end


