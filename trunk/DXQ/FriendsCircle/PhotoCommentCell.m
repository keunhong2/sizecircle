//
//  PhotoCommentCell.m
//  DXQ
//
//  Created by Yuan on 12-11-29.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "PhotoCommentCell.h"

@implementation PhotoCommentCell
@synthesize iconButton;//头像
@synthesize aliasLable; //昵称
@synthesize timeLbl; //时间
@synthesize contentLbl;//评论

-(void)dealloc
{
    [aliasLable release];aliasLable = nil;
    [timeLbl release];timeLbl = nil;
    [contentLbl release];contentLbl = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat margin_top = 7.0f;
    
        iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [iconButton setFrame:CGRectMake(10,margin_top, 40,40)];
        iconButton.layer.cornerRadius = 6.0;
        [iconButton setUserInteractionEnabled:YES];
        iconButton.layer.masksToBounds = YES;
        [self.contentView addSubview:iconButton];
        
        aliasLable = [[UILabel alloc]initWithFrame:CGRectMake(60.0f, margin_top-2.0, 150.0f, 25.0f)];
        [aliasLable setTextColor:[UIColor colorWithRed:0.720 green:0.225 blue:0.165 alpha:1.000]];
        [aliasLable setFont:[UIFont systemFontOfSize:14.0]];
        [aliasLable setContentMode:UIViewContentModeScaleAspectFit];
        [aliasLable setBackgroundColor:[UIColor clearColor]];
        [aliasLable setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:aliasLable];
        
        timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(210, margin_top-2, 100.0f, 25.0f)];
        [timeLbl setTextColor:[UIColor grayColor]];
        [timeLbl setFont:[UIFont systemFontOfSize:12.0]];
        [timeLbl setContentMode:UIViewContentModeScaleAspectFit];
        [timeLbl setBackgroundColor:[UIColor clearColor]];
        [timeLbl setAdjustsFontSizeToFitWidth:YES];
        [self.contentView addSubview:timeLbl];
        
        contentLbl = [[UITextView alloc] initWithFrame:CGRectMake(52.0f,30.0f,260.0f,80.0f)];
        [contentLbl setEditable:NO];
        [contentLbl setDataDetectorTypes:UIDataDetectorTypeAll];
        [contentLbl setFont:[UIFont systemFontOfSize:14.0]];
        [contentLbl setTextColor:[UIColor blackColor]];
        [contentLbl setUserInteractionEnabled:YES];
        [contentLbl setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:contentLbl];


    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect cRect = contentLbl.frame;
    cRect.size.height = contentLbl.contentSize.height;
    contentLbl.frame = cRect;
    
    self.clipsToBounds = YES;
    CGRect rect = self.contentView.frame;
    rect.size.height  = self.frame.size.height;
    self.contentView.frame = rect;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
