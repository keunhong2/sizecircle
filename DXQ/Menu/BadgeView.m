//
//  BadgeView.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BadgeView.h"

@interface BadgeView (){

    UIImageView *bgImgView;
    UILabel *badgeLabel;
}

@end
@implementation BadgeView


-(void)dealloc{

    [_badgeText release];
    [bgImgView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIImage *leftBageImg=[UIImage imageNamed:@"LeftSideBadgeValueBG"];
        UIImage *strImg=[leftBageImg stretchableImageWithLeftCapWidth:leftBageImg.size.width/2 topCapHeight:leftBageImg.size.height/2];
        bgImgView=[[UIImageView alloc]initWithImage:strImg];
        bgImgView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:bgImgView];
        
        badgeLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        badgeLabel.backgroundColor=[UIColor clearColor];
        badgeLabel.textColor=[UIColor whiteColor];
        badgeLabel.font=[UIFont boldSystemFontOfSize:14.f];
        badgeLabel.textAlignment=UITextAlignmentCenter;
        [self addSubview:badgeLabel];
    }
    return self;
}

-(void)setBadgeText:(NSString *)badgeText{
    
    if ([badgeText isEqualToString:_badgeText]) {
        return;
    }
    [_badgeText release];
    _badgeText=[badgeText retain];
    badgeLabel.text=_badgeText;
    [badgeLabel sizeToFit];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, badgeLabel.frame.size.width+10.f, badgeLabel.frame.size.height+5.f);
    bgImgView.frame=self.bounds;
    badgeLabel.frame=self.bounds;
}

-(void)setNumber:(NSInteger)number{

    if (number==_number) {
        return;
    }
    _number=number;
    self.badgeText=[NSString stringWithFormat:@"%d",_number];
}

@end
