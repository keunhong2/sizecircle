//
//  BaseScreenViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-22.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//


//筛选类的基类

#import "CustonNavigationController.h"

@class BaseScreenViewController;

@protocol ScreenViewControllerDelegate <NSObject>

@optional

-(void)didCancelScrennViewController:(BaseScreenViewController *)screenViewController;

-(void)screenViewController:(BaseScreenViewController *)screenViewController didDoneScreenWithInfo:(NSDictionary *)screenInfo;

@end

@interface BaseScreenViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,assign)id<ScreenViewControllerDelegate>screenDelegate;

@property (nonatomic,readonly)UITableView *tableView;

@property (nonatomic,readonly)NSDictionary *screenInfo;

@end
