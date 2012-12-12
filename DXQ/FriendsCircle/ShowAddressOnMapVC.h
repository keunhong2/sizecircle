//
//  ShowAddressOnMapVC.h
//  DXQ
//
//  Created by Yuan on 12-11-19.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowAddressOnMapVC : BaseViewController <MKMapViewDelegate>
{
	MKMapView *map;
	NSMutableArray *mapAnnotations;
    NSDictionary *mapInfoDict;
}

@property(nonatomic, retain)  MKMapView *map;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;

- (id)initWithDictionary:(NSDictionary *)item;

+ (CGFloat)annotationPadding;
+ (CGFloat)calloutHeight;

- (void)gotoLocationWithLan:(double)lat andLong:(double)lng;
- (void)gotoLocationBetween:(CLLocationCoordinate2D)c1 andC2:(CLLocationCoordinate2D)c2;

@end