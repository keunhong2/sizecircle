//
//  RelationMakeRequest.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-6.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQBaseRequest.h"

typedef enum
{
    RelationTypeBlack=-1,              // 黑名单
    RelationTypeFans=0,               // 粉丝
    RelationTypeHiddenFans=1,         // 暗恋
    RelationTypeHiddenFriend=2        // 朋友
}RelationType;

@protocol RelationMakeRequestDelegate <NSObject>
@optional
-(void)relationMakeRequestDidFinishedWithParamters:(NSDictionary *)dic;

-(void)relationMakeRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;

@end
@interface RelationMakeRequest : DXQBaseRequest

@property (nonatomic, retain) NSDictionary *  paramDic;
@property (nonatomic, assign) id <RelationMakeRequestDelegate, NSObject> delegate;

- (RelationMakeRequest *)initRequestWithDic:(NSDictionary *)dic;

@end

