//
//  ChangePswViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-12-26.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangePswViewController : BaseViewController

@property (nonatomic,retain)NSString *phoneNumber;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)UITextField *authCodeTextField;
@property (nonatomic,retain)UITextField *pswTextField;
@property (nonatomic,retain)UITextField *rePswTextField;

@end
