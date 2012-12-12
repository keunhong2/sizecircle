//
//  HYMapAnnotation.m
//  DXQ
//
//  Created by Yuan on 12-12-2.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "HYMapAnnotation.h"
@implementation HYMapAnnotation

@synthesize image;
@synthesize latitude;
@synthesize longitude;
@synthesize title;
@synthesize subtitle;

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [latitude doubleValue];
    theCoordinate.longitude = [longitude doubleValue];
    return theCoordinate;
}

- (void)dealloc
{
    [image release];
	[latitude release];
	[longitude release];
	[title release];
	[subtitle release];
	
    [super dealloc];
}


@end
