//
//  EventRemindViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-12-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"

@interface EventRemindViewController : BaseNavigationItemViewController

@property (nonatomic,retain)UIPickerView *pickerView;
@property (nonatomic)NSInteger maxDays;
@property (nonatomic)NSInteger selectDay;//default 5
@end
