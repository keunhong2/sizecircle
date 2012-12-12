//
//  ChatHistory.h
//  DXQ
//
//  Created by Yuan on 12-11-26.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ChatHistory : NSManagedObject

@property (nonatomic, retain) NSString * dxq_AccountFrom;
@property (nonatomic, retain) NSNumber * dxq_Id;
@property (nonatomic, retain) NSString * dxq_AccountTo;
@property (nonatomic, retain) NSString * dxq_IsReceived;
@property (nonatomic, retain) NSString * dxq_Face;
@property (nonatomic, retain) NSString * dxq_Content;
@property (nonatomic, retain) NSString * dxq_JingDu;
@property (nonatomic, retain) NSDate * dxq_OpTime;
@property (nonatomic, retain) NSString * dxq_Picture;
@property (nonatomic, retain) NSString * dxq_WeiDu;

@end
