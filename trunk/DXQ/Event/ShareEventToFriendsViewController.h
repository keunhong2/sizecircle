//
//  ShareEventToFriendsViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-29.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"

@interface ShareEventToFriendsViewController : BaseNavigationItemViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)NSArray *friendList;
@property (nonatomic,retain)NSMutableArray *selectFriendList;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSDictionary *eventInfoDic;

@end
