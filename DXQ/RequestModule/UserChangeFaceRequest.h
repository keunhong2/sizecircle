//
//  UserChangeFaceRequest.h
//  DXQ
//
//  Created by Yuan on 12-11-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserChangeFaceRequestDelegate <NSObject>

- (void)userChangeFaceRequestDidFinishedWithParamters:(NSDictionary *)dic;

- (void)userChangeFaceRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;
@end

@interface UserChangeFaceRequest : DXQBaseRequest
{
    NSDictionary *  paramDic;
    id <UserChangeFaceRequestDelegate, NSObject> delegate;
}
@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <UserChangeFaceRequestDelegate, NSObject> delegate;

- (UserChangeFaceRequest *)initRequestWithDic:(NSDictionary *)dic;

@end

