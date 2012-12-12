//
//  OrderViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-12-1.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"

@class UserProductSegmentControl;

@interface OrderViewController : BaseNavigationItemViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)UserProductSegmentControl *segment;
@property (nonatomic,retain)NSArray *visibleArray;
@property (nonatomic,retain)NSArray *untreatedArray;
@property (nonatomic,retain)NSArray *treatedArray;
@property (nonatomic,readonly)BOOL finishGetUntreated;
@property (nonatomic,readonly)BOOL finishGetTreated;
@property (nonatomic)BOOL isSelectUntreatedType;

-(NSDictionary *)requestArgsDicByPage:(NSInteger)page;//must over write in subclass

@end
