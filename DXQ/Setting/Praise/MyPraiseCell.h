//
//  MyPraiseCell.h
//  DXQ
//
//  Created by 黄修勇 on 12-12-2.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPraiseCell : UITableViewCell

@property (nonatomic,retain)UIImageView *praiseImageView;
@property (nonatomic,retain)UILabel *praiseNameLabel;
@property (nonatomic,retain)UILabel *praiseDateLabel;
@property (nonatomic,retain)UILabel *praiseTypeLabel;
@property (nonatomic,retain)NSDate *opDate;

@end
