//
//  SignUpRequest.h
//  DXQ
//
//  Created by Yuan on 12-10-12.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXQBaseRequest.h"

@protocol SignUpRequestDelegate <NSObject>

- (void)signUpRequestDidFinishedWithParamters:(NSDictionary *)dic;

- (void)signUpRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;
@end

@interface SignUpRequest : DXQBaseRequest
{
    NSDictionary *  paramDic;
    id <SignUpRequestDelegate, NSObject> delegate;
}
@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <SignUpRequestDelegate, NSObject> delegate;

- (SignUpRequest *)initRequestWithDic:(NSDictionary *)dic;

@end

