//
//  DXSegmenetControl.h
//  DXQ
//
//  Created by 黄修勇 on 13-1-28.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXSegmenetControl : UIControl

@property (nonatomic,retain)NSArray *items;

-(id)initWithItems:(NSArray *)items;

@property (nonatomic)NSInteger selectIndex;

@end
