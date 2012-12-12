//
//  ForgorPswViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseViewController.h"
#import "ForgotPswRequest.h"

@interface ForgorPswViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ForgotPswRequestDelegate>

@property (nonatomic,readonly)UITextField *emailTextFiled;

@end
