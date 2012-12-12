//
//  UserActionToolBar.m
//  DXQ
//
//  Created by Yuan on 12-10-20.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UserActionToolBar.h"

@implementation UIButtonUserInfoAction

- (id)initWithFrame:(CGRect)frame image:(UIImage*)img title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self && img)
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-img.size.width/2, 0, img.size.width, img.size.height)];
        [_imageView setImage:img];
        [self addSubview:_imageView];
        [_imageView release];
        
        CGFloat titleHeight = 20.0f;
        UILabel * _titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, img.size.height,frame.size.width,titleHeight)];
        [_titleLbl setAdjustsFontSizeToFitWidth:YES];
        [_titleLbl setTextColor:[UIColor grayColor]];
        [_titleLbl setText:title];
        [_titleLbl setTag:1];
        [_titleLbl setTextAlignment:UITextAlignmentCenter];
        [_titleLbl setBackgroundColor:[UIColor clearColor]];
        [_titleLbl setFont:NormalDefaultFont];
        [self addSubview:_titleLbl];
        [_titleLbl release];
        
        frame.size.height = img.size.height + titleHeight;
        self.frame = frame;
    }
    return self;
}
@end

@implementation UserActionToolBar

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action items:(NSArray *)itemsArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];

        CGFloat itemWidth = frame.size.width/[itemsArray count];
        CGFloat itemHeight = 0.0f;
        CGFloat itemMarginTop = 5.0f;
        for(int i = 0; i < [itemsArray count]; i++)
        {
            NSDictionary *item = [itemsArray objectAtIndex:i];
            
            UIButtonUserInfoAction *btn = [[UIButtonUserInfoAction alloc]initWithFrame:CGRectMake(i*itemWidth,5.0f, itemWidth,itemHeight) image:[UIImage imageNamed:[item objectForKey:@"img"]] title:[item objectForKey:@"title"]];
            [btn setTag:i+1];
            [self addSubview:btn];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
            [btn addGestureRecognizer:tap];
            [tap release];
            
            if (itemHeight<1)itemHeight = btn.frame.size.height+2*itemMarginTop;
            
            [btn release];
        }
        frame.size.height = itemHeight;
        self.frame = frame;
    }
    return self;
}

@end
