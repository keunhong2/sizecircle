//
//  MapAnnotation.h
//  YouKo
//
//  Created by Yuan He on 12-3-3.
//  Copyright (c) 2012年 YouKo. All rights reserved.
//
#import <MapKit/MapKit.h>


@interface MapAnnotation : NSObject <MKAnnotation> {
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