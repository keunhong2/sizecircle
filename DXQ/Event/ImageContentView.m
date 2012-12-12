//
//  ImageContentView.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-24.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ImageContentView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"

@interface ImageContentView (){
    
    UIImageView *_bgImgView;
    NSMutableArray *_imgViewArray;
}

@end
@implementation ImageContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float _orX=7.0f;
        float _orY=7.0f;
        
        UIImage *bgImg=[UIImage imageNamed:@"detail_bg"];
        UIImage *newImg=[bgImg stretchableImageWithLeftCapWidth:bgImg.size.width/2 topCapHeight:bgImg.size.height/2];
        _bgImgView=[[UIImageView alloc]initWithFrame:CGRectMake(_orX,_orY, self.frame.size.width-_orX*2, self.frame.size.height-_orY)];
        _bgImgView.image=newImg;
        _bgImgView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:_bgImgView];
        _imgViewArray=[NSMutableArray new];
    }
    return self;
}

-(void)dealloc{
    
    [_bgImgView release];
    [_imageArray release];
    [_imgViewArray release];
    _delegate=nil;
    [super dealloc];
}

-(void)setImageArray:(NSArray *)imageArray{
    
    if ([imageArray isEqualToArray:_imageArray]) {
        return;
    }
    
    [_imageArray release];
    _imageArray=[imageArray retain];
    
    for (UIView *view in _imgViewArray) {
        [view removeFromSuperview];
    }
    [_imgViewArray removeAllObjects];
    
    UIImage *imgBgImg=[UIImage imageNamed:@"image_bg"];
    CGSize viewSize=imgBgImg.size;
    float lastWidth=self.frame.size.width-7.f*2-viewSize.width*4-10.f;
    float marginWidth=lastWidth/3;
    
    for (int i=0; i<imageArray.count+1; i++) {
        
        float _viewOrX=i%4*(viewSize.width+marginWidth)+5.f+7.f;
        float _viewOrY=i/4*(viewSize.height+5.f)+5.f+7.f;
        CGRect viewRect=CGRectMake(_viewOrX, _viewOrY, viewSize.width, viewSize.height);
        UIView *view=[[UIView alloc]initWithFrame:viewRect];
        view.backgroundColor=[UIColor clearColor];
        UIImageView *bgImgView=[[UIImageView alloc]initWithImage:imgBgImg];
        [view addSubview:bgImgView];
        [bgImgView release];
        UIImageView *contentImgView=[[UIImageView alloc]initWithFrame:CGRectMake(3.f, 2.f, viewSize.width-7.f, viewSize.height-7.f)];
        contentImgView.layer.cornerRadius=2.f;
        contentImgView.backgroundColor=[UIColor grayColor];
        contentImgView.contentMode=UIViewContentModeScaleAspectFit;
        if (i==imageArray.count) {
            contentImgView.image=[UIImage imageNamed:@"image_add"];
        }else
        {
            NSDictionary *dic=[_imageArray objectAtIndex:i];
            NSString *url=[[dic objectForKey:@"FilePath"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [contentImgView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
        }
        [view addSubview:contentImgView];
        [contentImgView release];
        view.tag=i;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
        [view addGestureRecognizer:tap];
        [tap release];
        [self addSubview:view];
        [_imgViewArray addObject:view];
        [view release];
    }
    
    NSInteger horNumber=_imgViewArray.count%4==0?_imgViewArray.count/4:_imgViewArray.count/4+1;
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 14.f+(5.f+viewSize.height)*horNumber);
}

-(void)imageViewTap:(UITapGestureRecognizer *)tap{
    
    if (_delegate&&[_delegate respondsToSelector:@selector(imageContentView:imageViewIndex:)]) {
        UIView *view=[tap view];
        [_delegate imageContentView:self imageViewIndex:view.tag];
    }
}
@end
