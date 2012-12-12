
//
//  CourseAnnotation.m
//  Golf1872
//
//  Created by fos on 4/26/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation

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
