//
//  TicketInfoHeaderView.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "TicketInfoHeaderView.h"
#import "UIImageView+WebCache.h"

@implementation TicketInfoHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        [headerView.businessImageView removeFromSuperview];
        headerView.businessImageView=nil;
        
        for (UIView *view in headerView.subviews) {
            float tempWidth=view.frame.size.width;
            
            if ([view isKindOfClass:[UILabel class]]) {
                tempWidth+=65.f;
            }
            view.frame=CGRectMake(view.frame.origin.x-65.f, view.frame.origin.y, tempWidth, view.frame.size.height);
        }
    }
    return self;
}

@end


@implementation TicketImagesView

@synthesize imageArray=_imageArray;


-(void)dealloc{

    [_scrollView release];
    [_pageControl release];
    for (UIView *view in _imageViewArray) {
        [view removeFromSuperview];
    }
    [_imageViewArray removeAllObjects];
    [_imageViewArray release];
    [_imageArray release];
    [super dealloc];
}


-(id)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    
    if (self) {
        
        _scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.pagingEnabled=YES;
        _scrollView.maximumZoomScale=1.f;
        _scrollView.minimumZoomScale=1.f;
        _scrollView.delegate=self;
        
        [self addSubview:_scrollView];
        
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(0.f, self.frame.size.height-36.f, self.frame.size.width, 36.f)];
        _pageControl.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _pageControl.numberOfPages=0;
        [self addSubview:_pageControl];
        
        _imageViewArray=[NSMutableArray new];
    }
    return self;
}

-(void)setImageArray:(NSArray *)imageArray{

    if ([imageArray isEqualToArray:_imageArray]) {
        return;
    }
    
    [_imageArray release];
    _imageArray=[imageArray retain];
    
    for (UIView *view in _imageViewArray) {
        [view removeFromSuperview];
    }
    [_imageViewArray removeAllObjects];
    
    for (int i=0; i<imageArray.count; i++) {
       // NSDictionary *dic=[imageArray objectAtIndex:i];
        //for test
        NSDictionary *dic=[imageArray objectAtIndex:i];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*i, 0.f, self.frame.size.width, self.frame.size.height)];
        imageView.contentMode=UIViewContentModeScaleAspectFit;
        imageView.tag=i+1;
        NSURL *imageURL=[NSURL URLWithString:[[dic objectForKey:@"ProductPhoto"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [imageView setImageWithURL:imageURL placeholderImage:nil];
        [_scrollView addSubview:imageView];
        [_imageViewArray addObject:imageView];
        [imageView release];
    }
    
    _pageControl.numberOfPages=imageArray.count;
    _pageControl.currentPage=0;
    
    _scrollView.contentSize=CGSizeMake(self.frame.size.width*imageArray.count, self.frame.size.height);
    [_scrollView scrollRectToVisible:CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height) animated:YES];
}


#pragma mark -UISrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    NSInteger number=scrollView.contentOffset.x/self.frame.size.width;
    _pageControl.currentPage=number;
}
@end