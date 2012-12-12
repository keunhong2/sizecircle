//
//  BeautyContestViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-24.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseImageTableViewController.h"

@interface BeautyContestViewController : BaseImageTableViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,getter = isCurrentPeriodical)BOOL currentPeriodical;//defaut YES

@property (nonatomic,retain)NSArray *oldPerImageArray;
@property (nonatomic,retain)NSDictionary *currentPerDic;

@end


@interface NumberView : UIView{
    
@private
    UIImageView *bgImgView;
    UILabel *numberLabel;
}
@property (nonatomic)NSInteger number;

@end

@interface NumberImageView : UIView

@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic)NSInteger number;

-(void)setImageByDic:(NSDictionary *)dic;

@end
