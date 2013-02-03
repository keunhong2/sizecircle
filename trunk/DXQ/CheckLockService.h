//
//  CheckLockService.h
//  DXQ
//
//  Created by 黄修勇 on 13-2-4.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckLockService : NSObject

@property (nonatomic,getter = isEnable) BOOL enable;
@property (nonatomic,retain)NSURL *checkUrl;
@property (nonatomic,readonly,getter = isLock)BOOL lock;
@property (nonatomic,readonly)BOOL finishCheck;

-(void)startCheck;

@end
