//
//  AcvityDetailViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-30.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"

@class PhotoDetailTopView;

@interface AcvityDetailViewController : BaseNavigationItemViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)PhotoDetailTopView *photoTopView;
@property (nonatomic,retain)NSDictionary *activityDic;
@property (nonatomic,retain)NSDictionary *simpleDic;
@property (nonatomic,retain)NSArray *commantList;

@end
