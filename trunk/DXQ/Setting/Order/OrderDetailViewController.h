//
//  OrderDetailViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-12-3.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"

@interface OrderDetailViewController : BaseNavigationItemViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSDictionary *orderDic;
@property (nonatomic,retain)NSDictionary *productDic;
@property (nonatomic)BOOL isMemberCard;
@end
