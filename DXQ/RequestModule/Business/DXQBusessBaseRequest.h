//
//  DXQBusessBaseRequest.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-7.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQBaseRequest.h"

@class DXQBusessBaseRequest;

@protocol BusessRequestDelegate <NSObject>

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data;
-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg;

@end
@interface DXQBusessBaseRequest : DXQBaseRequest

@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic,assign) id<BusessRequestDelegate>delegate;

-(id)initWithRequestWithDic:(NSDictionary *)dic;

@end
