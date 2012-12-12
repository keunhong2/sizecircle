//
//  DXQNoticeCenter.h
//  DXQ
//
//  Created by 黄修勇 on 12-12-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXQNoticeCenter : NSObject


+(id)defaultNoticeCenter;

-(NSArray *)allNotice;

-(void)addNoticeByArray:(NSArray *)array;

-(void)removeNoticeByArray:(NSArray *)array;

@end
