//
//  PhotoDetailVC.h
//  DXQ
//
//  Created by Yuan on 12-11-29.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface PhotoDetailVC : BaseViewController<UniversalViewControlDelegate>
{
}

- (id)initWithUserInfo:(NSDictionary *)info;

@end
