//
//  CouponsTrendsViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class CouponsBottomBar;

typedef NS_ENUM(NSInteger, CouponsContentType)
{
    CouponsTypeAbout,
    CouponsTypeTrends,
    CouponsTypePhoto,
};

@interface CouponsTrendsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic)CouponsContentType showType;
@property (nonatomic,readonly)CouponsBottomBar *bottomBar;

@property (nonatomic,retain)NSDictionary *shopSimpleInfoDic;

@property (nonatomic,retain)NSDictionary *shopDetailInfoDic;
@property (nonatomic,retain)NSArray *activiryArray;
@property (nonatomic,retain)NSArray *photoListArray;

-(id)initWithShopSimpleDic:(NSDictionary *)dic;

@end
