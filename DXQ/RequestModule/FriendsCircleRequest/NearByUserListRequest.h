//
//  NearByUserListRequest.h
//  DXQ
//
//  Created by Yuan on 12-11-3.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXQBaseRequest.h"

@protocol NearByUserListRequestDelegate <NSObject>

- (void)nearByUserListRequestDidFinishedWithParamters:(NSDictionary *)dic;

- (void)nearByUserListRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;
@end

@interface NearByUserListRequest : DXQBaseRequest
{
    NSDictionary *  paramDic;
    id <NearByUserListRequestDelegate, NSObject> delegate;
}
@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <NearByUserListRequestDelegate, NSObject> delegate;

- (NearByUserListRequest *)initRequestWithDic:(NSDictionary *)dic;

@end
