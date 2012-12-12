//
//  ForgotPswRequest.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-28.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQBaseRequest.h"

@protocol ForgotPswRequestDelegate <NSObject>

@optional
- (void)forgotPswRequestDidFinishedWithParamters:(NSDictionary *)dic;

- (void)forgotPswRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;
@end

@interface ForgotPswRequest : DXQBaseRequest

@property (nonatomic,assign)id<ForgotPswRequestDelegate>delegate;

@property (nonatomic, retain) NSDictionary *  paramDic;

- (ForgotPswRequest *)initRequestWithDic:(NSDictionary *)dic;

@end
