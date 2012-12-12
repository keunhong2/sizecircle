//
//  BaseImageTableViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-25.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"

@interface BaseImageTableViewController : BaseNavigationItemViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSArray *visibleImageArray;

//called when image is touch

-(void)imageViewTapIndex:(NSIndexPath *)indexPath imageView:(UIImageView *)imageView;

@end
