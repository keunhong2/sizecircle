//
//  UserLoadPhotoRequest.h
//  DXQ
//
//  Created by Yuan on 12-11-29.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXQBaseRequest.h"

@protocol UserLoadPhotoRequestDelegate <NSObject>

-(void)userLoadPhotoRequestDidFinishedWithParamters:(id)outPut;

-(void)userLoadPhotoRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;

@end
@interface UserLoadPhotoRequest : DXQBaseRequest

@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <UserLoadPhotoRequestDelegate, NSObject> delegate;

- (UserLoadPhotoRequest *)initRequestWithDic:(NSDictionary *)dic;

@end