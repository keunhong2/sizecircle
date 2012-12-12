//
//  CustomSegmentedControl.h
//  DXQ
//
//  Created by Yuan on 12-10-17.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

typedef enum
{
    SegmentTypeList,
    SegmentTypeGrid,
    SegmentTypeMap
}SegmentType;

@protocol CustomSegmentedControlDelegate <NSObject>
@end
@interface CustomSegmentedControl : UIView
{
    NSArray *items;
}
@property(nonatomic,assign)id<CustomSegmentedControlDelegate>delegate;
@property(nonatomic,retain) NSArray *items;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items_ defaultSelectIndex:(NSUInteger)idx;

@end

@protocol CustomSegmentedControl <NSObject>

@optional
-(void)didSelectIndex:(NSUInteger)selectedIndex withSegmentControl:(CustomSegmentedControl*)segmentControl;

@end