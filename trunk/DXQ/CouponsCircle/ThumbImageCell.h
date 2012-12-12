//
//  ThumbImageCell.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-16.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//   83

#import <UIKit/UIKit.h>


@interface ThumbImageCell : UITableViewCell
{
    @private
    id  actionTarget;
    SEL _action;
}

@property (nonatomic,readonly)NSInteger maxNumberOfImage;

@property (nonatomic,retain)NSArray *imageSourceArray;

-(void)addTapTarget:(id)target action:(SEL)action;

@end
