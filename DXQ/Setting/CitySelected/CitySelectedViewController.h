//
//  CitySelectedViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-12-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"

@interface CitySelectedViewController : BaseNavigationItemViewController

@property (nonatomic,retain)NSString *defaultCity;
@property (nonatomic,retain)UIPickerView *pickerView;
@property (nonatomic,retain)NSArray *cityArray;

@end
