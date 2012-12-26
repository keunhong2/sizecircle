//
//  UserInforViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseViewController.h"
#import "GenderSelectView.h"

@interface UserInforViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,GenderSelectViewDelegate>

@property (nonatomic,readonly)UITextField *trueNameTextField;
@property (nonatomic)BOOL male;
@property (nonatomic,retain)NSMutableDictionary *accountAndPsdInfoDic;


@property (nonatomic,retain)NSString *phoneNumber;
@property (nonatomic,retain)UITextField *authCodeTextField;
@property (nonatomic,retain)UITextField *pswTextField;
@property (nonatomic,retain)UITextField *rePswTextField;

@end
