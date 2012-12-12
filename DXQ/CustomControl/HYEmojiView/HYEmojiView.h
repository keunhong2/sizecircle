
//  Created by Yuan on 12-11-14.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.

//*********************^^^^^^^**************************

// 作者: He Yuan

// 邮件: heyuan110@gmail.com

// 博客: http://www.heyuan110.com

// 备 注: 本部分使用图片均来自互联网，作者不对使用此源代码和图片产生的问题负责。


//*********************^^^^^^^**************************


#import <UIKit/UIKit.h>

#import "HYEmojiData.h"

@protocol HYEmojiViewDelegate;

@interface HYEmojiViewLayer : CALayer {
@private
    CGImageRef _showerBackGroundImage;;
}
@property (nonatomic, retain) UIImage* currentEmoji;
@end


@interface HYEmojiBoardView : UIView
{
@private
    NSInteger touchedIndex;
    
    NSInteger currentPage;
    
    NSArray *emojiArray;
    
    id<HYEmojiViewDelegate>delegate;
}
@property (nonatomic, retain) NSArray *emojiArray;

@property (nonatomic, retain)  HYEmojiViewLayer *emojiViewLayer;

@property (nonatomic) NSInteger currentPage;

@property (nonatomic) NSInteger touchedIndex;

@property (nonatomic,assign) id<HYEmojiViewDelegate>delegate;

@end

@interface HYEmojiBoardView(Private)
- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate_;
@end

@interface HYEmojiView: UIView<UIScrollViewDelegate>
{
@private
    UIPageControl *pageControl;
    
    UIScrollView *scrollView;
    
    EmojiType currentEmojiType;
    
    NSDictionary *emojiDictData;
    
    HYEmojiBoardView *emojiBoardView;
    
    id<HYEmojiViewDelegate>delegate;
    
    UIImageView *clickImageView;
}
@property(nonatomic,retain)UIImageView *clickImageView;

@property (nonatomic,assign) id<HYEmojiViewDelegate>delegate;

@property (nonatomic, readonly) NSDictionary *emojiDictData;

@property (nonatomic) EmojiType currentEmojiType;

@property (nonatomic, retain)  UIPageControl *pageControl;

@property (nonatomic, retain)  UIScrollView *scrollView;

@property (nonatomic, retain)  HYEmojiBoardView *emojiBoardView;

- (id)initWithFrame:(CGRect)frame superViewHeight:(CGFloat)superViewHeight delegate:(id)delegate;

@end

@protocol HYEmojiViewDelegate<NSObject>
@optional

-(void)showKeyBoard:(HYEmojiView *)emojiView;

@required
- (void)didSelectEmojiImage:(UIImage *)image EmojiString:(NSString*)emoji;
@end

