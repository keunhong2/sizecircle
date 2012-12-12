//
//  UserReportUserRequest.h
//  DXQ
//
//  Created by Yuan on 12-11-26.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserReportUserRequestDelegate <NSObject>
@optional
-(void)userReportUserRequestDidFinishedWithParamters:(NSDictionary *)dic;

-(void)userReportUserRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;

@end
@interface UserReportUserRequest : DXQBaseRequest

@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <UserReportUserRequestDelegate, NSObject> delegate;

- (UserReportUserRequest *)initRequestWithDic:(NSDictionary *)dic;

@end
