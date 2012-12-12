//
//  CustomSearchBar.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "CustomSearchBar.h"

@interface CustomSearchBar ()

-(void)setDefault;

@end

@implementation CustomSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDefault];
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{

    self=[super initWithCoder:aDecoder];
    if (self) {
        [self setDefault];
    }
    return self;
}


-(void)setDefault
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            UIImage *searchBarBgImg=[UIImage imageNamed:@"search_bg"];
            UIImageView *bgImgView=[[UIImageView alloc]initWithImage:searchBarBgImg];
            bgImgView.frame=self.bounds;
            bgImgView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [self insertSubview:bgImgView atIndex:[self.subviews indexOfObject:view]];
            [view removeFromSuperview];
            [bgImgView release];
            break;
        }
    }
}
@end
