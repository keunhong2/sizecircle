//
//  UITextField+InputTextFiled.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UITextField+InputTextFiled.h"

@implementation UITextField (InputTextFiled)


+(UITextField *)creatTextFiledWithFrame:(CGRect)frame{

    UITextField *textFiled=[[UITextField alloc]initWithFrame:frame];
    textFiled.borderStyle=UITextBorderStyleNone;
    textFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    textFiled.returnKeyType=UIReturnKeyNext;
    return textFiled;
}
@end
