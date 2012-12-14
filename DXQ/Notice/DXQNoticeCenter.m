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

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTIFICATIONCENTER_RECEIED_NOTICE object:nil];
    [super dealloc];
}

-(id)init{

    self=[super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNotice:) name:NOTIFICATIONCENTER_RECEIED_NOTICE object:nil];
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

-(void)getNotice:(NSNotification *)not{

    id notice=[not object];
    if (notice) {
        [self addNoticeByArray:[NSArray arrayWithObject:notice]];
    }
}
@end
