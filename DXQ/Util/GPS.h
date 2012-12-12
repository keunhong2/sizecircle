//
//  GPS.h
//  DXQ
//
//  Created by Yuan on 12-11-8.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum
{
    GPSLocationLatitude,//维度
    GPSLocationLongitude//经度
}GPSLocation;

@interface GPS : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager* _locationManager;
    CLLocation* currentLocation;
}
@property (nonatomic, readonly) CLLocation* currentLocation;

+ (GPS*)gpsManager;

- (void)startUpdateLocation;

- (void)stopUpdateLocation;

- (BOOL)islocationServicesEnabled;

-(NSString *)getLocation:(GPSLocation)locationType;

-(NSString*)getDistanceFromLat:(NSNumber *)lat Lon:(NSNumber *)lon;

@end
