//
//  BaseNavigationItemViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseNavigationItemViewController : BaseViewController

+(UIBarButtonItem *)defaultItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
