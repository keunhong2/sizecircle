//
//  UserInfoDetailRequest.h
//  DXQ
//
//  Created by Yuan on 12-11-5.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXQBaseRequest.h"

@protocol UserInfoDetailRequestDelegate <NSObject>

- (void)userInfoDetailRequestDidFinishedWithParamters:(NSDictionary *)dic;

- (void)userInfoDetailRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;
@end

@interface UserInfoDetailRequest : DXQBaseRequest
{
    NSDictionary *  paramDic;
    id <UserInfoDetailRequestDelegate, NSObject> delegate;
}
@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <UserInfoDetailRequestDelegate, NSObject> delegate;

- (UserInfoDetailRequest *)initRequestWithDic:(NSDictionary *)dic;

@end