//
//  MyFriendsVC.h
//  DXQ
//
//  Created by Yuan on 12-10-23.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "CustomSegmentedControl.h"
#import "BaseNavigationItemViewController.h"

@interface MyFriendsVC : BaseNavigationItemViewController<CustomSegmentedControlDelegate>

-(void)viewUserDetailInfo:(NSDictionary *)info;

-(void)chatWithUserInfo:(NSDictionary *)info;

@end