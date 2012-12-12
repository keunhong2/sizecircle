//
//  SignInRequest.h
//  DXQ
//
//  Created by Yuan on 12-10-12.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXQBaseRequest.h"

@protocol SignInRequestDelegate <NSObject>

- (void)signInRequestDidFinishedWithParamters:(NSDictionary *)dic;

- (void)signInRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;
@end

@interface SignInRequest : DXQBaseRequest
{
    NSDictionary *  paramDic;
    id <SignInRequestDelegate, NSObject> delegate;
}
@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <SignInRequestDelegate, NSObject> delegate;

- (SignInRequest *)initRequestWithDic:(NSDictionary *)dic;

@end


