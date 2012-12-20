//
//  ChatManageUserCell.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-20.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ChatManageUserCell.h"
#import "BadgeView.h"

@interface ChatManageUserCell ()
{
    BadgeView *badgeView;
}

@end
@implementation ChatManageUserCell

-(void)dealloc{

    [badgeView release];
    [super dealloc];
}

-(void)setBadgeNumber:(NSInteger)badgeNumber{

    if (badgeNumber<0) {
        badgeNumber=0;
    }
    
    if (badgeNumber==_badgeNumber) {
        return;
    }
    _badgeNumber=badgeNumber;
    if (badgeNumber==0) {
        [badgeView removeFromSuperview];
        [badgeView release];
        badgeView=nil;
    }else
    {
        if (!badgeView) {
            badgeView=[[BadgeView alloc]initWithFrame:CGRectZero];
            badgeView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
            [self.contentView addSubview:badgeView];
        }
        badgeView.number=badgeNumber;
        badgeView.frame=CGRectMake(self.contentView.frame.size.width-5.f-badgeView.frame.size.width, self.contentView.frame.size.height/2-badgeView.frame.size.height/2, badgeView.frame.size.width, badgeView.frame.size.height);
    }
}

@end
