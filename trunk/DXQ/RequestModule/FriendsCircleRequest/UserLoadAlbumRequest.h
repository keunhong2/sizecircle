//
//  UserLoadAlbumRequest.h
//  DXQ
//
//  Created by Yuan on 12-11-29.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXQBaseRequest.h"

@protocol UserLoadAlbumRequestDelegate <NSObject>

-(void)userLoadAlbumRequestDidFinishedWithParamters:(id)outPut;

-(void)userLoadAlbumRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;

@end
@interface UserLoadAlbumRequest : DXQBaseRequest

@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <UserLoadAlbumRequestDelegate, NSObject> delegate;

- (UserLoadAlbumRequest *)initRequestWithDic:(NSDictionary *)dic;

@end