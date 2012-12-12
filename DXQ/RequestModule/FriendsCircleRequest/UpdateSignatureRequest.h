//
//  UpdateSignatureRequest.h
//  DXQ
//
//  Created by Yuan on 12-11-15.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DXQBaseRequest.h"

@protocol UpdateSignatureRequestDelegate <NSObject>

-(void)updateSignatureRequestDidFinishedWithParamters:(NSDictionary *)dic;

-(void)updateSignatureRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;

@end
@interface UpdateSignatureRequest : DXQBaseRequest

@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <UpdateSignatureRequestDelegate, NSObject> delegate;

- (UpdateSignatureRequest *)initRequestWithDic:(NSDictionary *)dic;

@end
