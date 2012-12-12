//
//  BuyViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-28.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"

@interface BuyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,retain)NSDictionary *productDic;
@property (nonatomic,retain)UITableView *tableView;

//for input
@property (nonatomic,retain)UITextField *buyNumberTextField;
@property (nonatomic,retain)UITextField *nameTextField;
@property (nonatomic,retain)UITextField *addressTextField;
@property (nonatomic,retain)UITextField *postCodeTextField;
@property (nonatomic,retain)UITextField *phoneNumberTextField;

@property (nonatomic)BOOL canEditeBuyNumber;

@end



@interface TextFieldTableViewCell : UITableViewCell

@property (nonatomic,retain)UITextField *textFiled;

@end