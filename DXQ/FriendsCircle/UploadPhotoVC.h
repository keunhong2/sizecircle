//
//  UploadPhotoVC.h
//  DXQ
//
//  Created by Yuan on 12-11-27.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface UploadPhotoVC : BaseViewController<CLLocationManagerDelegate,MKReverseGeocoderDelegate>
{
    CLLocationManager *_locationManager;
    
    CLLocationCoordinate2D _coordinate;
    
    CLGeocoder *_geoCoder;
    
    MKReverseGeocoder *_reverseGeocoder;
}

@property (nonatomic, retain) CLGeocoder *geoCoder;

@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;

@property (nonatomic,retain)NSString *productID;

-(id)initWithImage:(UIImage *)image;

@end
