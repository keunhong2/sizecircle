//
//  NearByListCell.m
//  DXQ
//
//  Created by Yuan on 12-10-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "NearByListCell.h"
#import "BadgeView.h"

@implementation NearByListCell
@synthesize avatarImg; 
@synthesize usernameLbl;
@synthesize ageImg;
@synthesize ageLbl;
@synthesize distanceLbl;
@synthesize statusLbl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code

        CGFloat margin_left = 8.0f;
        CGFloat avatarWidth = 56.0f;
		avatarImg = [UIButton buttonWithType:UIButtonTypeCustom];
        avatarImg.frame = CGRectMake(margin_left,margin_left, avatarWidth,avatarWidth);
		[self.contentView addSubview:avatarImg];        
        
        usernameLbl = [[UILabel alloc] initWithFrame:CGRectMake(75.0,margin_left-1.0, 225, 20)];
        [usernameLbl setAdjustsFontSizeToFitWidth:YES];
		usernameLbl.font = TitleDefaultFont;
		[usernameLbl setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:usernameLbl];
        
        ageImg = [[UIImageView alloc] initWithFrame:CGRectMake(75.0,30.0,28,15)];
		[self.contentView addSubview:ageImg];
		
        ageLbl = [[UILabel alloc] initWithFrame:CGRectMake(76.0,30.0,15, 15)];
        [ageLbl setAdjustsFontSizeToFitWidth:YES];
		ageLbl.font = NormalDefaultFont;
        [ageLbl setTextAlignment:UITextAlignmentCenter];
        ageLbl.textColor = [UIColor whiteColor];
		[ageLbl setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:ageLbl];
        
        distanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(115,30.0,180, 15)];
        [distanceLbl setAdjustsFontSizeToFitWidth:YES];
		distanceLbl.font = NormalDefaultFont;
        distanceLbl.textColor = [UIColor colorWithRed:1.000 green:0.538 blue:0.208 alpha:1.000];
		[distanceLbl setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:distanceLbl];

        statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(75.0,50,225,18)];
        [statusLbl setAdjustsFontSizeToFitWidth:NO];
        [statusLbl setNumberOfLines:1];
		statusLbl.font = NormalDefaultFont;
        statusLbl.textColor = [UIColor grayColor];
		[statusLbl setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:statusLbl];        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    [self setLabelSelect:selected];
    // Configure the view for the selected state
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    [super setHighlighted:highlighted animated:animated];
    [self setLabelSelect:highlighted];
}

-(void)setLabelSelect:(BOOL)selected{
    
    if (selected)
    {
        self.usernameLbl.textColor=[UIColor whiteColor];
        self.distanceLbl.textColor=[UIColor whiteColor];
        self.statusLbl.textColor=[UIColor whiteColor];
    }else
    {
        self.usernameLbl.textColor=[UIColor blackColor];
        distanceLbl.textColor = [UIColor colorWithRed:1.000 green:0.538 blue:0.208 alpha:1.000];
        self.statusLbl.textColor=[UIColor grayColor];
    }
}

-(void)layoutSubviews{

    [super layoutSubviews];
    [self reloadBadgeView];
}
-(void)reloadBadgeView
{
    badgeView.frame=CGRectMake(self.contentView.frame.size.width-badgeView.frame.size.width-10.f, self.contentView.frame.size.height/2-badgeView.frame.size.height/2, badgeView.frame.size.width, badgeView.frame.size.height);
}
- (void)dealloc
{
    [avatarImg release];
    [usernameLbl release];
    [ageImg release];
    [ageLbl release];
	[distanceLbl release];
	[statusLbl release];
    [badgeView release];
    [super dealloc];
}

-(void)setBadgeNumber:(NSInteger)badgeNumber{

    if (badgeNumber<=0) {
        badgeNumber=0;
    }
    if (badgeNumber==_badgeNumber) {
        return;
    }
    _badgeNumber=badgeNumber;
    if (badgeNumber==0) {
        [badgeView release];
        [badgeView removeFromSuperview];
        badgeView=nil;
    }else
    {
        if (!badgeView) {
            badgeView=[[BadgeView alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:badgeView];
        }
        badgeView.number=badgeNumber;
        [self reloadBadgeView];
    }
}
@end
