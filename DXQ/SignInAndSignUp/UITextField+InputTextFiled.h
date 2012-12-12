//
//  UITextField+InputTextFiled.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (InputTextFiled)

//创建一个简单的UITextField 返回的对象如果不使用了 需要手工release一次

+(UITextField *)creatTextFiledWithFrame:(CGRect)frame;

@end
