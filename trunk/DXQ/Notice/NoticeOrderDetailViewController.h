//
//  NoticeOrderDetailViewController.h
//  DXQ
//
//  Created by 黄修勇 on 13-1-2.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseViewController.h"

@interface NoticeOrderDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSDictionary *simpleDic;
@property (nonatomic,retain)NSDictionary *detailDic;

@end
