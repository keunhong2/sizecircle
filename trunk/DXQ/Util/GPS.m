//
//  GPS.m
//  DXQ
//
//  Created by Yuan on 12-11-8.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "GPS.h"
#import "Definitions.h"

static GPS* sharedGPSManager = nil;

@implementation GPS

@synthesize currentLocation = _currentLocation;

+ (GPS*)gpsManager
{
    if (!sharedGPSManager)
    {
        sharedGPSManager = [[GPS alloc] init];
    }
    return sharedGPSManager;
}

//get location
-(NSString *)getLocation:(GPSLocation)locationType
{
    GPS* gps = [GPS gpsManager];
    NSString* location = @"0.0";
    if (gps.currentLocation)
    {
        switch (locationType)
        {
            case GPSLocationLatitude:
                location = [NSString stringWithFormat:@"%f", gps.currentLocation.coordinate.latitude];
                break;
            case GPSLocationLongitude:
                location = [NSString stringWithFormat:@"%f", gps.currentLocation.coordinate.longitude];
                break;
            default:
                break;
        }
    }
    return location;
}

-(NSString*)getDistanceFromLat:(NSNumber *)lat Lon:(NSNumber *)lon
{
    NSString *me_latString =   [[GPS gpsManager]getLocation:GPSLocationLatitude];
    NSString *me_lonString =   [[GPS gpsManager]getLocation:GPSLocationLongitude];
    
    CGFloat me_lat = me_latString!=nil?[me_latString floatValue]:0.0f;
    CGFloat me_lon = me_lonString!=nil?[me_lonString floatValue]:0.0f;
    CGFloat user_lat = lat!=nil?[lat floatValue]:0.0f;
    CGFloat user_lon = lon!=nil?[lon floatValue]:0.0f;
    
    BOOL isLocationRecord = YES;
    NSString *distanceString = @"";
    if (me_lat== me_lon && me_lon == 0.0)isLocationRecord = NO;
    if (user_lat== user_lon && user_lon == 0.0)isLocationRecord = NO;
    if (isLocationRecord)
    {
        CGFloat  dis = [Tool getDistanceFromPoint:CLLocationCoordinate2DMake(me_lat,me_lon) toPoint:CLLocationCoordinate2DMake(user_lat, user_lon)];
        if (dis > 1000)
        {
            distanceString = [NSString stringWithFormat:@"%.1f%@",dis/1000,AppLocalizedString(@"千米")];
        }
        else if (dis > 50)
        {
            distanceString = [NSString stringWithFormat:@"%.1f%@",dis,AppLocalizedString(@"米")];
        }
        else if (dis > 20)
        {
            distanceString = [NSString stringWithFormat:@"%@50%@",AppLocalizedString(@"小于"),AppLocalizedString(@"米")];
        }
        else
        {
            distanceString = [NSString stringWithFormat:@"%@20%@",AppLocalizedString(@"小于"),AppLocalizedString(@"米")];
        }
    }
    else
    {
        distanceString = AppLocalizedString(@"未知");
    }
    return distanceString;
}


//location Services turn on/off
- (BOOL)islocationServicesEnabled
{
    if ([CLLocationManager locationServicesEnabled]
        && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)return YES;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:AppLocalizedString(@"定位提示") message:AppLocalizedString(@"定位被拒绝") delegate:nil cancelButtonTitle:AppLocalizedString(@"确定") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
    return NO;
}

#pragma mark -
#pragma mark Public Method

- (void)startUpdateLocation
{
    if (!_locationManager)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = DEFAULT_DISTANCE_FILTER;
    }
    [_locationManager startUpdatingLocation];
}

- (void)stopUpdateLocation
{
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
        
        [_locationManager release];
        _locationManager = nil;
    }
    
    if (_currentLocation)
    {
        [_currentLocation release];
        _currentLocation = nil;
    }
}

#pragma mark - location Delegate
//当位置获取或更新失败会调用的方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSString *errorMsg = AppLocalizedString(@"获取位置信息失败");

    if ([error code] == kCLErrorDenied)
    {
        errorMsg = AppLocalizedString(@"定位被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown)
    {
        errorMsg = AppLocalizedString(@"获取位置信息失败");
    }
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:AppLocalizedString(@"定位提示")
                                                       message:errorMsg delegate:self cancelButtonTitle:AppLocalizedString(@"确定") otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (!newLocation) {
        [self locationManager:manager didFailWithError:(NSError *)NULL];
        return;
    }
    
    if (signbit(newLocation.horizontalAccuracy)) {
		[self locationManager:manager didFailWithError:(NSError *)NULL];
		return;
	}
    
    [manager stopUpdatingLocation];
    
    if (_currentLocation) {
        [_currentLocation release];
        _currentLocation = nil;
    }
    _currentLocation = [newLocation retain];
}

@end
