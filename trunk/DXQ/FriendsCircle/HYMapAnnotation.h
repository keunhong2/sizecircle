//
//  HYMapAnnotation.h
//  DXQ
//
//  Created by Yuan on 12-12-2.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYMapAnnotation : NSObject <MKAnnotation> {
    UIImage *image;
    NSNumber *latitude;
    NSNumber *longitude;
	NSString *subtitle;
	NSString *title;
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic,retain) NSString *subtitle;
@property (nonatomic,retain) NSString *title;

@end