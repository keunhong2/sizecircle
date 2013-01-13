//
//  ShowAddressOnMapVC.m
//  DXQ
//
//  Created by Yuan on 12-11-19.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ShowAddressOnMapVC.h"
#import "HYMapAnnotation.h"

@implementation ShowAddressOnMapVC
@synthesize map, mapAnnotations;

- (id)initWithDictionary:(NSDictionary *)dict;
{
    self = [super init];
    if (self)
    {
        mapInfoDict = [[NSDictionary alloc]initWithDictionary:dict];
        NSLog(@"%@",mapInfoDict);
    }
    return self;
}


- (void)dealloc
{
	[mapAnnotations release];
	[map release];
	[mapInfoDict release];
	
    [super dealloc];
}


+ (CGFloat)annotationPadding;
{
    return 10.0f;
}

+ (CGFloat)calloutHeight;
{
    return 40.0f;
}


-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavgationTitle:AppLocalizedString(@"显示位置") backItemTitle:AppLocalizedString(@"返回")];

    
    map = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    map.delegate = self;
    [self.view addSubview:map];
    
    NSString *addTitle=[mapInfoDict objectForKey:@"title"];
	NSString *address = [mapInfoDict objectForKey:@"value"];
	NSString *latString = [mapInfoDict objectForKey:@"lat"];
	NSString *lngString = [mapInfoDict objectForKey:@"lng"];
	
	[map setMapType: MKMapTypeStandard];
	
	//set scroll and zoom action
	map.scrollEnabled = YES;
	map.zoomEnabled = YES;
	
    // create out annotations array (in this example only 2)
    mapAnnotations = [[NSMutableArray alloc] init];
    
    HYMapAnnotation *annotation = [[HYMapAnnotation alloc] init];
	annotation.latitude = [NSNumber numberWithDouble:[latString doubleValue]];
	annotation.longitude = [NSNumber numberWithDouble:[lngString doubleValue]];
	annotation.title =addTitle;
	annotation.subtitle = address;
	[mapAnnotations addObject:annotation];
    [annotation release];
    
	MKUserLocation *userLocation = map.userLocation;
	userLocation.title = @"我在这儿";
	
	map.showsUserLocation = YES;
    
	[self gotoLocationWithLan:[latString doubleValue] andLong:[lngString doubleValue]];
    [self.map removeAnnotations:self.map.annotations];  // remove any annotations that exist
    [self.map addAnnotations:mapAnnotations];
}

-(void)goBack
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.6;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.endProgress = 1.0f;
    animation.removedOnCompletion = NO;
    animation.type = @"oglFlip";
    animation.subtype = @"fromRight";
    [self.navigationController.view.layer addAnimation:animation forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)gotoLocationBetween:(CLLocationCoordinate2D)c1 andC2:(CLLocationCoordinate2D)c2
{
	MKCoordinateRegion theRegion;
	CLLocationCoordinate2D theCenter;
	theCenter.latitude = (c1.latitude + c2.latitude)/2;
	theCenter.longitude = (c1.longitude + c2.longitude)/2;
	theRegion.center=theCenter;
	
	//set zoom level
	MKCoordinateSpan theSpan;
	theSpan.latitudeDelta = 1.5 * fabs(c1.latitude - c2.latitude);
	theSpan.longitudeDelta = 1.5 * fabs(c1.longitude - c2.longitude);
	theRegion.span = theSpan;
	
	//set map Region
	[map setRegion:theRegion animated:YES];
	[map regionThatFits:theRegion];
}

- (void)gotoLocationWithLan:(double)lat andLong:(double)lng
{
	// Override point for customization after app launch
	MKCoordinateRegion theRegion;
	CLLocationCoordinate2D theCenter;
	theCenter.latitude = lat;
	theCenter.longitude = lng;
	theRegion.center=theCenter;
	
	//set zoom level
	MKCoordinateSpan theSpan;
	theSpan.latitudeDelta = 0.099;
	theSpan.longitudeDelta = 0.099;
	theRegion.span = theSpan;
	
	//set map Region
	[map setRegion:theRegion animated:YES];
	[map regionThatFits:theRegion];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)showDetails:(id)sender
{
    //the detail view does not want a toolbar so hide it
	NSLog(@"showDetails ...");
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // handle our custom annotations
    if ([annotation isKindOfClass:[HYMapAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString* MapAnnotationIdentifier = @"MapAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
		[map dequeueReusableAnnotationViewWithIdentifier:MapAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
												   initWithAnnotation:annotation reuseIdentifier:MapAnnotationIdentifier] autorelease];
            customPinView.pinColor = MKPinAnnotationColorGreen;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            /*
             UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
             [rightButton addTarget:self
             action:@selector(showDetails:)
             forControlEvents:UIControlEventTouchUpInside];
             customPinView.rightCalloutAccessoryView = rightButton;
             */
			
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

@end
