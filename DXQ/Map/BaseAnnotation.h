//
//  BaseAnnotation.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-12.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BaseAnnotation : NSObject<MKAnnotation>

@property (nonatomic,retain)NSDictionary *dic;

@property (nonatomic,retain)NSString *latKey;
@property (nonatomic,retain)NSString *longKey;
@property (nonatomic,retain)NSString *titleKey;
@property (nonatomic,retain)NSString *subTitleKey;
@end
