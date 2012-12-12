//
//  UserRegisterVC.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseViewController.h"
#import "SignUpRequest.h"
#import "GenderSelectView.h"

@interface UserRegisterVC : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SignUpRequestDelegate,GenderSelectViewDelegate>

@property (nonatomic,readonly)UITextField *accountTextField;
@property (nonatomic,readonly)UITextField *pswTextFiled;
@property (nonatomic,readonly)UITextField *rePswTextFiled;

//@property (nonatomic,readonly)UITextField *trueNameTextField;
//@property (nonatomic)BOOL male;
@property (nonatomic,retain)NSDictionary *maleAndNameDic;

@end
