//
//  DXQNoticeCenter.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQNoticeCenter.h"
#import "UserLoadUnReadNoticeList.h"

@interface DXQNoticeCenter ()<BusessRequestDelegate>{

    NSMutableArray *allNoticeArray;
    UserLoadUnReadNoticeList *noticeRequest;
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
    [self cancelGetUnReadNotice];
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


#pragma mark -Unread

-(void)cancelGetUnReadNotice
{
    if (noticeRequest) {
        [noticeRequest cancel];
        [noticeRequest release];
        noticeRequest=nil;
    }
}

-(void)getUnReadNotice{

    [self cancelGetUnReadNotice];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[SettingManager sharedSettingManager].loggedInAccount,@"AccountId", nil];
    noticeRequest=[[UserLoadUnReadNoticeList alloc]initWithRequestWithDic:dic];
    noticeRequest.delegate=self;
    [noticeRequest startAsynchronous];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [self getUnReadNotice];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    for (int i=0; i<[data count]; i++) {
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATIONCENTER_RECEIED_NOTICE object:[data objectAtIndex:i]];
    }
}
@end
