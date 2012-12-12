//
//  NearByFriendsVC.h
//  DXQ
//
//  Created by Yuan on 12-10-16.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomSegmentedControl.h"
#import "BaseNavigationItemViewController.h"
#import "NearByUserListRequest.h"

@interface NearByFriendsVC : BaseNavigationItemViewController<MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,CustomSegmentedControlDelegate,NearByUserListRequestDelegate>

@end
