//
//  MyAttenListViewController.h
//  DXQ
//
//  Created by 黄修勇 on 13-1-21.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseViewController.h"
#import "LoadMoreView.h"

@interface MyAttenListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>{

    UIImageView *noDataImgView;
    LoadMoreView *loadMoreView;
    BOOL isRefresh;
}

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSArray *list;


@end
