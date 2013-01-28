//
//  CustomSegmentedControl.m
//  DXQ
//
//  Created by Yuan on 12-10-17.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "CustomSegmentedControl.h"

@implementation CustomSegmentedControl
@synthesize items,delegate;

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items_ defaultSelectIndex:(NSUInteger)idx
{
    //idx from 0 to ...
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.items = items_;
        _selectedIndex=idx;
        CGFloat margin_left = 0.0f;
        CGFloat segment_height = 0.0f;
        for (int i = 0 ; i < [self.items count]; i++)
        {
            NSDictionary *item = [self.items objectAtIndex:i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTag:i+1];
            UIImage *normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal.png",[item objectForKey:@"img"]]];
            [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
            [btn setBackgroundImage:normalImage forState:UIControlStateHighlighted];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:MiddleBoldDefaultFont];
            [btn setTitle:[item objectForKey:@"title"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            CGRect rect = CGRectMake(margin_left, 0.0, normalImage.size.width, normalImage.size.height);
            [btn setFrame:rect];
            [self addSubview:btn];

            margin_left+=normalImage.size.width;
            
            segment_height = normalImage.size.height;
        }
        
        [self btnAction:(UIButton*)[self viewWithTag:idx+1]];
        
        frame.size.height = segment_height;
        
        frame.size.width = margin_left;
        
        self.frame = frame;
    }
    return self;
}

-(void)btnAction:(UIButton*)sender
{
    for (int i = 0 ; i < [self.items count]; i++)
    {
        UIButton *btn = (UIButton*)[self viewWithTag:i+1];
        NSDictionary *item = [self.items objectAtIndex:i];
        NSString *imageName = @"";
        if (i == sender.tag-1)
        {
            imageName = [NSString stringWithFormat:@"%@_highlighted.png",[item objectForKey:@"img"]];
        }
        else
        {
            imageName = [NSString stringWithFormat:@"%@_normal.png",[item objectForKey:@"img"]];
        }
        UIImage *image  =  [UIImage imageNamed:imageName];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn setBackgroundImage:image forState:UIControlStateHighlighted];
    }
    _selectedIndex=sender.tag-1;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectIndex:withSegmentControl:)])
    {
        objc_msgSend(self.delegate, @selector(didSelectIndex:withSegmentControl:),sender.tag-1,self);
    }
}

-(void)dealloc
{
    [items release];
    [super dealloc];
}

@end
