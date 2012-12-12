//
//  ImageContentView.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-24.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageContentView;
@protocol ImageContentDelegate <NSObject>

@optional
-(void)imageContentView:(ImageContentView *)imageContentView imageViewIndex:(NSInteger)index;

@end
@interface ImageContentView : UIView

@property (nonatomic,retain)NSArray *imageArray;
@property (nonatomic,assign)id <ImageContentDelegate>delegate;
@end
