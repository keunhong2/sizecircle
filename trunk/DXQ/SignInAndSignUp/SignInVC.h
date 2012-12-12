//
//  SignInVC.h
//  DXQ
//
//  Created by Yuan on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInRequest.h"

@interface SignInVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SignInRequestDelegate>

@property (nonatomic)BOOL autoLoginAfterLoadView;//default is yes ,if don't want auto logo must set after init
@property (nonatomic,readonly)UITextField *accuntTextField;
@property (nonatomic,readonly)UITextField *pswTextField;
@property (nonatomic,readonly)UISwitch *isAutoLogin;

@end
