//
//  BasePullTableViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-23.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface BasePullTableViewController : BaseNavigationItemViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate>

@property (nonatomic,readonly)EGORefreshTableHeaderView *egoHeaderView;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,readonly)BOOL isLoading;
@property (nonatomic,readonly,retain)NSDate *lastUpdate;

//更改TableView ContentOffset 启动请求

-(void)changeTableViewState;

// 下拉刷新默认执行的函数 此函数需要继承类自定义重写

-(void)defaultRequest;

//请求结束 返还tableView的状态

- (void)doneLoadingTableViewData;
@end
