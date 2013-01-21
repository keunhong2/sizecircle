//
//  FansView.h
//  DXQ
//
//  Created by Yuan on 12-10-19.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FansView : UIView

@property(nonatomic,readonly)UILabel *fansCountLbl;

@property(nonatomic,readonly)UIImageView *starImageView;

@property (nonatomic)NSInteger fansCount;

@property (nonatomic)BOOL isFans;

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

@end


@interface LikesView : FansView

@end