//
//  UpdateAccountInfoRequest.h
//  DXQ
//
//  Created by Yuan on 12-11-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "DXQBaseRequest.h"

@protocol UpdateAccountInfoRequestDelegate <NSObject>

-(void)updateAccountInfoRequestDidFinishedWithParamters:(NSDictionary *)dic;

-(void)UpdateAccountInfoRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;

@end
@interface UpdateAccountInfoRequest : DXQBaseRequest

@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <UpdateAccountInfoRequestDelegate, NSObject> delegate;

- (UpdateAccountInfoRequest *)initRequestWithDic:(NSDictionary *)dic;

@end