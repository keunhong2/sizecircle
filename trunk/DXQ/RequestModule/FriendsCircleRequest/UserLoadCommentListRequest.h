//
//  UserLoadCommentListRequest.h
//  DXQ
//
//  Created by Yuan on 12-11-29.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserLoadCommentListRequestDelegate <NSObject>

-(void)userLoadCommentListRequestDidFinishedWithParamters:(id)outPut;

-(void)userLoadCommentListRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;

@end
@interface UserLoadCommentListRequest : DXQBaseRequest

@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <UserLoadCommentListRequestDelegate, NSObject> delegate;

- (UserLoadCommentListRequest *)initRequestWithDic:(NSDictionary *)dic;

@end