//
//  GetGiftListRequest.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-7.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQBaseRequest.h"

@protocol GetGiftListRequestDelegate <NSObject>

-(void)getGiftListRequestDidFinishWithGiftList:(NSArray *)giftList;
-(void)getGiftListRequestDidFinishedWithErrorMessage:(NSString *)errorMsg;

@end
@interface GetGiftListRequest : DXQBaseRequest

@property (nonatomic,retain)NSDictionary *  paramDic;
@property (nonatomic,assign)id<GetGiftListRequestDelegate>delegate;

-(GetGiftListRequest *)initRequestWithDic:(NSDictionary *)dic;

@end
