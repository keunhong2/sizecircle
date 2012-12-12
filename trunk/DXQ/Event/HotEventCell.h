//
//  HotEventCell.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-22.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotEventCell : UITableViewCell

@property (nonatomic,readonly)UILabel *eventNameLabel;
@property (nonatomic,readonly)UILabel *eventDateLabel;
@property (nonatomic,readonly)UILabel *eventLocationLabel;
@property (nonatomic,readonly)UILabel *eventTypeLabel;
@property (nonatomic)NSInteger interestCount;
@property (nonatomic)NSInteger joinCount;
@property (nonatomic,readonly)UIImageView *evengImageView;

@end