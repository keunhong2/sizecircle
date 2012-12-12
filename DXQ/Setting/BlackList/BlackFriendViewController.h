//
//  BlackFriendViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-12-8.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"

@interface BlackFriendViewController : BaseNavigationItemViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSArray *blackList;

@end
