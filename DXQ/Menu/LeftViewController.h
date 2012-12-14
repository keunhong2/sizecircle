//
//  LeftViewController.h
//  DXQ
//
//  Created by Yuan on 12-10-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : BaseViewController

@property (nonatomic)NSInteger noticeBadgeValue;
@property (nonatomic)NSInteger chatMsgValue;

-(void)addNoticeBadgeNumber:(NSInteger)addNumber;

-(void)removeNoticeBadgeNumber:(NSInteger)removeNumber;

//

-(void)reloadData;

@end


@interface LeftMenuCell  : UITableViewCell

@property (nonatomic)NSInteger badgeNumber;

@end