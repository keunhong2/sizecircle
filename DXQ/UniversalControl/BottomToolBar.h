//
//  BottomToolBar.h
//  DXQ
//
//  Created by Yuan on 12-10-20.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomToolBar : UIControl

typedef enum
{
    BottomToolBarItemTypeAbout,
    BottomToolBarItemTypeActivity,
    BottomToolBarItemTypePhotos
}BottomToolBarItemType;

@property (nonatomic)NSInteger selectIndex;

@end
