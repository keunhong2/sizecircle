//
//  UserRemoveRelation.h
//  DXQ
//
//  Created by Yuan on 12-11-25.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UserRemoveRelationDelegate <NSObject>
@optional
-(void)userRemoveRelationDidFinishedWithParamters:(NSDictionary *)dic;

-(void)userRemoveRelationDidFinishedWithErrorMessage:(NSString *)errorMsg;

@end
@interface UserRemoveRelation : DXQBaseRequest

@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <UserRemoveRelationDelegate, NSObject> delegate;

- (UserRemoveRelation *)initRequestWithDic:(NSDictionary *)dic;

@end
