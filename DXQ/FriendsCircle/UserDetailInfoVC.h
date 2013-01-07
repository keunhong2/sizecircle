//
//  UserDetailInfoVC.h
//  DXQ
//
//  Created by Yuan on 12-10-19.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomToolBar.h"

@interface UserDetailInfoVC : BaseViewController

- (id)initwithUserInfo:(NSDictionary *)item;

-(void)showType:(BottomToolBarItemType)type;

@end
