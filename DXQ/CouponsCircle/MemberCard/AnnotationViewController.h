//
//  AnnotationViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-1.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseAnnotation.h"

@interface AnnotationViewController : UIViewController<MKMapViewDelegate>

@property (retain, nonatomic) IBOutlet MKMapView *theMapView;
@end
