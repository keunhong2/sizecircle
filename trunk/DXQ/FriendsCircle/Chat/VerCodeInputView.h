//
//  VerCodeInputView.h
//  DXQ
//
//  Created by 黄修勇 on 13-2-10.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VerCodeInputView;

@protocol VerCodeInputViewDelegate <NSObject>

-(void)cancelVerCodeInputView:(VerCodeInputView *)view;
-(void)finishVerCodeInputView:(VerCodeInputView *)view;

@end
@interface VerCodeInputView : UIView

@property (nonatomic,retain)NSString *phone;
@property (nonatomic,assign)id<VerCodeInputViewDelegate>delegate;

@end
