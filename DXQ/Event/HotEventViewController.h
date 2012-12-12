//
//  HotEventViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-20.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"

@interface HotEventViewController : BaseNavigationItemViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)UISearchBar *searchBar;
@property (nonatomic,retain)NSArray *hotEventArray;
@property (nonatomic,retain)NSArray *visibleArray;

@end


