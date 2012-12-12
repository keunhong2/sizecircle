//
//  FriendsCircleRequest.h
//  DXQ
//
//  Created by Yuan on 12-11-29.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//


#import "DXQBaseRequest.h"

@class FriendsCircleRequest;

@protocol FriendsCircleRequestDelegate <NSObject>

-(void)friendsCircleRequestRequest:(FriendsCircleRequest *)request didFinishWithData:(id)data;
-(void)friendsCircleRequestRequest:(FriendsCircleRequest *)request didFailedWithErrorMsg:(NSString *)msg;

@end
@interface FriendsCircleRequest : DXQBaseRequest

@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic,assign) id<FriendsCircleRequestDelegate>delegate;

-(id)initWithRequestWithDic:(NSDictionary *)dic;

@end
