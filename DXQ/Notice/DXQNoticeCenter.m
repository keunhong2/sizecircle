//
//  DXQNoticeCenter.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQNoticeCenter.h"

@interface DXQNoticeCenter (){

    NSMutableArray *allNoticeArray;
}

@end
@implementation DXQNoticeCenter

static DXQNoticeCenter *noticeCenter=nil;

+(id)defaultNoticeCenter{

    if (!noticeCenter) {
        noticeCenter=[[DXQNoticeCenter alloc]init];
    }
    return noticeCenter;
}

-(id)init{

    self=[super init];
    if (self) {
        
    }
    return self;
}

-(NSArray *)allNotice{

    return allNoticeArray;
}

-(void)addNoticeByArray:(NSArray *)array{

    if (!allNoticeArray) {
        allNoticeArray=[NSMutableArray new];
    }
    [allNoticeArray addObjectsFromArray:array];
}

-(void)removeNoticeByArray:(NSArray *)array{

    [allNoticeArray removeObjectsInArray:array];
    if (allNoticeArray.count==0) {
        [allNoticeArray release];
        allNoticeArray=nil;
    }
}

@end
