//
//  ChatBottomToolBar.h
//  DXQ
//
//  Created by Yuan on 12-10-22.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatBottomToolBar : UIView<UITextFieldDelegate>

@property(nonatomic,retain)UITextField *messageTextField;
@property(nonatomic,retain)UIButton *emojButton;
@property(nonatomic,retain)UIButton *sendButton;

- (id)initWithFrame:(CGRect)frame delegate:(UIViewController *)delegate;

@end
