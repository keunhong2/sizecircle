//
//  ZoomImageView.h
//  MuseumDesign
//
//  Created by Yuan.He on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZoomImageView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView  *scrollView;
    UIImageView   *imgView;
    CGRect originRect;
}
@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)UIImageView *imgView;

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)img delegate:(UIViewController*)pController_ withUrl:(NSString *)url withOriginRect:(CGRect)orect;
-(void)resizeImageView:(UIImage*)img withUrl:(NSString*)url;
@end
