//
//  ZoomImageView.m
//  MuseumDesign
//
//  Created by Yuan.He on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ZoomImageView.h"
#import "UIImageView+WebCache.h"

@implementation ZoomImageView
@synthesize scrollView;
@synthesize imgView;


-(void)dealloc
{
    [imgView release];
    [scrollView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)img delegate:(UIViewController*)pController_ withUrl:(NSString *)url withOriginRect:(CGRect)orect
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        originRect = orect;

        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.80];
        
        scrollView = [[UIScrollView alloc]initWithFrame:frame];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setMaximumZoomScale:5.0f];
        [scrollView setMinimumZoomScale:1.0f];
        scrollView.bounces = YES;
        scrollView.delegate = self;
        [self addSubview:scrollView];
                
        UITapGestureRecognizer *singleTapOneFinger = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
        singleTapOneFinger.numberOfTapsRequired = 1;
        singleTapOneFinger.numberOfTouchesRequired = 1;
        singleTapOneFinger.delegate = self;
        [self.scrollView addGestureRecognizer:singleTapOneFinger];
        [singleTapOneFinger release];
        
        if (!CGRectIsNull(originRect))imgView  = [[UIImageView alloc]initWithFrame:originRect];
        else
        {
            CGRect orRect =  CGRectZero;
            imgView  = [[UIImageView alloc]initWithFrame:orRect];
        }
        [self resizeImageView:img withUrl:url];
        [imgView setUserInteractionEnabled:YES];
        [scrollView addSubview:imgView];        
    }
    return self;
}


-(CGSize)getFitSizeFromCGSize:(CGSize)fitSize withMaxWidth:(CGFloat)w withMaxHeight:(CGFloat)h
{
    float _originalWidth = fitSize.width;
    float _originalHeight = fitSize.height;
    float _resultWidth = 0.0f;
    float _resultHeight = 0.0f;
    if (_originalWidth <= w && _originalHeight <=h) {
        _resultWidth = _originalWidth;
        _resultHeight = _originalHeight;
    }
    else
    {
        if (_originalWidth/_originalHeight > w/h ) {
            if (_originalWidth >= w) {
                _resultWidth = w;
                _resultHeight = _resultWidth*_originalHeight/_originalWidth;
            }
            else
            {
                _resultWidth = _originalWidth;
                _resultHeight = _resultWidth*_originalHeight/_originalWidth;
            }
        }
        else
        {
            if (_originalHeight >= h) {
                _resultHeight = h;
                _resultWidth = _resultHeight*_originalWidth/_originalHeight;
            }
            else
            {
                _resultHeight = _originalHeight;
                _resultWidth = _resultHeight*_originalWidth/_originalHeight;
            }
        }
    }
    return CGSizeMake(_resultWidth, _resultHeight);
}

-(void)resizeImageView:(UIImage*)img withUrl:(NSString*)url
{
    
    if (url&&[url length]>0)
    {
        [imgView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"Info_icon_default.jpg"] success:^(UIImage *image ,BOOL iscache){
            [self resizeImageView:image withUrl:nil];
        } failure:^(NSError *error)
         {
             //
         }];
    }
    else 
    {
        [imgView setImage:img];
    }
    CGRect rect = imgView.frame;
    CGSize fitsize = [self getFitSizeFromCGSize:imgView.image.size withMaxWidth:320.0f withMaxHeight:self.scrollView.frame.size.height];
    //计算图片中心点的坐标
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)? 
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)? 
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint centerPoint = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, 
                                      scrollView.contentSize.height * 0.5 + offsetY);    
    rect.size.width = fitsize.width;
    rect.size.height = fitsize.height;
    rect.origin.x = centerPoint.x - rect.size.width/2;
    rect.origin.y = centerPoint.y - rect.size.height/2;
    NSLog(@"rect--->%@",NSStringFromCGRect(rect));
    
    if (CGRectIsNull(originRect))
    {
        imgView.frame = rect;
        self.userInteractionEnabled = YES;
        [scrollView setZoomScale:1.001f];
    }
    else
    {
        [UIView animateWithDuration:0.4f animations:^{
            imgView.frame = rect;
            self.userInteractionEnabled = NO;
        } completion:^(BOOL finished)
         {
             self.userInteractionEnabled = YES;
             [scrollView setZoomScale:1.001f];
         }];
    }
}

//让图片居中
- (void)scrollViewDidZoom:(UIScrollView *)aScrollView 
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)? 
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)? 
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    imgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, 
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma UIScrollViewDelegate Methord
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView_
{
    return imgView;
}

#pragma UIGestureRecognizerDelegate Methord
-(void)handleSingleTap:(UITapGestureRecognizer*)recognizer
{
    if (!CGRectIsNull(originRect))
    {
        [UIView animateWithDuration:0.4f animations:^{
            self.userInteractionEnabled = NO;
            [scrollView setZoomScale:1.00f];
            imgView.frame = originRect;
            self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
            imgView.alpha = 0.7f;
        } completion:^(BOOL finished)
         {
             self.userInteractionEnabled = YES;
             self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
             imgView.alpha = 0.0f;
             [self removeFromSuperview];
         }];
    }
    else
    {
        [UIView animateWithDuration:0.4f animations:^{
            self.userInteractionEnabled = NO;
            [scrollView setZoomScale:1.00f];
            self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
            imgView.alpha = 0.3f;
        } completion:^(BOOL finished)
         {
             self.userInteractionEnabled = YES;
             self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
             imgView.alpha = 0.0f;
             [self removeFromSuperview];
         }];
    }
}

@end
