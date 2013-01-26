//
//  ScreenViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-22.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseScreenViewController.h"
#import "AreaSelectView.h"

typedef NS_ENUM(NSInteger, ScreenType) {
    ScreenTypeDefault,
    ScreenTypeWithName,
};

@interface ScreenViewController : BaseScreenViewController

@property (nonatomic,readonly)ScreenType screenType;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *selectLocationName;
@property (nonatomic,retain)NSString *selectClassName;

-(id)initWithScreenType:(ScreenType )type;

@end



@interface ClassSelectView : AreaSelectView

@end