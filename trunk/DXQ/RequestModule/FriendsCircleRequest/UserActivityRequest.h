//
//  UserActivityRequest.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-5.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQBaseRequest.h"

@protocol UserActivityRequestDelegate <NSObject>

-(void)userActivityRequestDidFinishedWithParamters:(NSArray *)activityList;

-(void)userActivityRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;

@end

@interface UserActivityRequest : DXQBaseRequest

@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <UserActivityRequestDelegate, NSObject> delegate;

- (UserActivityRequest *)initRequestWithDic:(NSDictionary *)dic;
@end
