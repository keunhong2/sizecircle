//
//  SayHelloRequest.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-5.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQBaseRequest.h"

@protocol SayHelloRequestDelegate <NSObject>
@optional
-(void)sayHelloRequestDidFinishedWithParamters:(NSDictionary *)dic;

-(void)sayHelloRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;

@end
@interface SayHelloRequest : DXQBaseRequest

@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <SayHelloRequestDelegate, NSObject> delegate;

- (SayHelloRequest *)initRequestWithDic:(NSDictionary *)dic;

@end
