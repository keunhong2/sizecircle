//
//  UserCommentCell.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UserCommentCell.h"
#import "UIColor+ColorUtils.h"


@interface UserCommentCell ()

-(void)setLabelSelected:(BOOL)selected;

@end
@implementation UserCommentCell

@synthesize userImageView=_userImageView;
@synthesize userNameLabel=_userNameLabel;
@synthesize commentLabel=_commentLabel;
@synthesize dateLabel=_dateLabel;

-(void)dealloc{

    [_userImageView release];
    [_userNameLabel release];
    [_commentLabel release];
    [_dateLabel release];
    [super dealloc];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIColor *grayColor=GrayColorForTextColor;
        
        _userImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10.f, 7.5f, 45.f, 45.f)];
        _userImageView.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:_userImageView];
        
        _userNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(60.f, 7.5f, 200.f, 20.f)];
        _userNameLabel.backgroundColor=[UIColor clearColor];
        _userNameLabel.font=MiddleBoldDefaultFont;
        [self.contentView addSubview:_userNameLabel];
        
        _commentLabel=[[UILabel alloc]initWithFrame:CGRectMake(60.f, 30.f, self.contentView.frame.size.width-70.f, 20.f)];
        _commentLabel.backgroundColor=[UIColor clearColor];
        _commentLabel.textColor=grayColor;
        _commentLabel.font=MiddleNormalDefaultFont;
        [self.contentView addSubview:_commentLabel];
        
        _dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(130.f, 7.5, 180.f, 20.f)];
        _dateLabel.backgroundColor=[UIColor clearColor];
        _dateLabel.textColor=grayColor;
        _dateLabel.textAlignment=UITextAlignmentRight;
        _dateLabel.font=MiddleNormalDefaultFont;
        _dateLabel.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self setLabelSelected:selected];
}


-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

    [super setHighlighted:highlighted animated:animated];
    
    [self setLabelSelected:highlighted];
}


-(void)setLabelSelected:(BOOL)selected
{
    if (selected) {
        _userNameLabel.textColor=[UIColor whiteColor];
        _commentLabel.textColor=[UIColor whiteColor];
        _dateLabel.textColor=[UIColor whiteColor];
    }else
    {
        UIColor *grayColor=GrayColorForTextColor;
        
        _userNameLabel.textColor=grayColor;
        _commentLabel.textColor=grayColor;
        _dateLabel.textColor=grayColor;
    }
}
@end
