//
//  UserCreatePhotoRequest.h
//  DXQ
//
//  Created by Yuan on 12-11-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DXQBaseRequest.h"

@protocol UserCreatePhotoRequestDelegate <NSObject>

- (void)userCreatePhotoRequestDidFinishedWithParamters:(NSDictionary *)dic;

- (void)userCreatePhotoRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;
@end

@interface UserCreatePhotoRequest : DXQBaseRequest
{
    NSDictionary *  paramDic;
    id <UserCreatePhotoRequestDelegate, NSObject> delegate;
}
@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <UserCreatePhotoRequestDelegate, NSObject> delegate;

- (UserCreatePhotoRequest *)initRequestWithDic:(NSDictionary *)dic;

@end


