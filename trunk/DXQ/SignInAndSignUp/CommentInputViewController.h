//
//  CommentInputViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-9.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"

@class CommentInputViewController;
@protocol CommentInputDelegate <NSObject>

@optional
-(void)commentInputViewController:(CommentInputViewController *)inputViewController cancelBtnDone:(UIButton *)btn;
-(void)commentInputViewController:(CommentInputViewController *)inputViewController doneBtnDone:(UIButton *)btn;
@end
@interface CommentInputViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (assign, nonatomic) id <CommentInputDelegate> delegate;
@end
