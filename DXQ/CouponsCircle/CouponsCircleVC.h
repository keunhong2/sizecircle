//
//  CouponsCircleVC.h
//  DXQ
//
//  Created by Yuan on 12-10-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomSegmentedControl.h"
#import "BasePullTableViewController.h"
#import <MapKit/MapKit.h>
#import "ScreenViewController.h"
#import "BaseNavigationItemViewController.h"

@interface CouponsCircleVC : BaseNavigationItemViewController<CustomSegmentedControlDelegate,UITableViewDataSource,UITableViewDelegate,ScreenViewControllerDelegate>

@property (nonatomic,retain)NSArray *couponsList;//for table view
@property (nonatomic,retain)NSArray *couponsOnMapList;//for map
@property (nonatomic)BOOL isListModel;
@property (nonatomic)BOOL isRequestForMap;

-(void)cancelAllRequest;

@end


@interface BussessScreenObject : NSObject

@property (nonatomic,retain)NSString * accountID;//帐号id default get from setting manage
@property (nonatomic,retain)NSString *name;//name 搜索 default -1
@property (nonatomic,retain)NSString *area;//区域
@property (nonatomic,retain)NSString *classify;//分类
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic)NSInteger lastPage;//defaul 1
@property (nonatomic)NSInteger page;//default 1
@property (nonatomic)NSInteger count;//default 20
@property (nonatomic)CLLocationCoordinate2D minCoordinate;
@property (nonatomic)CLLocationCoordinate2D maxCoordinate;

-(NSDictionary *)dictionaryIsForMap:(BOOL)isMap;

@end
/*
@interface CouponsCircleVC : BasePullTableViewController<MKMapViewDelegate,CustomSegmentedControlDelegate,ScreenViewControllerDelegate>

@property (nonatomic,retain)NSArray *couponsList;


@property (nonatomic,retain)MKMapView *mapView;

@property (nonatomic)BOOL isListModel;//列表或者 地图模式

@end
*/