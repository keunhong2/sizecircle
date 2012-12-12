//
//  HotEventCell.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-22.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "HotEventCell.h"
#import "UIColor+ColorUtils.h"
#import <QuartzCore/QuartzCore.h>

@interface HotEventCell (){

    UIButton *leftBtn;
    UIButton *rightBtn;
    CGRect _eventImgViewRect;
}

@end

@implementation HotEventCell


-(void)dealloc{

    [_eventNameLabel release];
    [_eventDateLabel release];
    [_eventLocationLabel release];
    [_eventTypeLabel release];
    [_evengImageView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        float bgImgOrX=15.f;
        float bgImgOrY=5.f;
        
        UIImage *bgImg=[UIImage imageNamed:@"detail_bg"];
        UIImage *newImg=[bgImg stretchableImageWithLeftCapWidth:bgImg.size.width/2 topCapHeight:bgImg.size.height/2];
        UIImageView *bgImgView=[[UIImageView alloc]initWithImage:newImg];
        bgImgView.frame=CGRectMake(bgImgOrX, bgImgOrY, self.contentView.frame.size.width-bgImgOrX*2, self.contentView.frame.size.height-bgImgOrY*2);
        bgImgView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:bgImgView];
        [bgImgView release];
        
        float labelWidth=160.f;
        float labelOrX=bgImgOrX+7.f;
        float labelOrY=bgImgOrY+7.f;
        _eventNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelOrX,labelOrY, labelWidth, 25.f)];
        _eventNameLabel.backgroundColor=[UIColor clearColor];
        _eventNameLabel.font=[UIFont boldSystemFontOfSize:18.f];
        [self.contentView addSubview:_eventNameLabel];
        
        labelOrY+=30.f;
        
        UIFont *otherFont=[UIFont systemFontOfSize:14.f];
        
        _eventDateLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelOrX, labelOrY, labelWidth, 20.f)];
        _eventDateLabel.backgroundColor=[UIColor clearColor];
        _eventDateLabel.font=otherFont;
        _eventDateLabel.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:_eventDateLabel];
        
        labelOrY+=20.f;
        
        _eventLocationLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelOrX, labelOrY, labelWidth, 35.f)];
        _eventLocationLabel.backgroundColor=[UIColor clearColor];
        _eventLocationLabel.font=otherFont;
        [self.contentView addSubview:_eventLocationLabel];
        _eventLocationLabel.numberOfLines=0;
        
        labelOrY+=35.f;
        
        _eventTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(labelOrX, labelOrY, labelWidth, 20.f)];
        _eventTypeLabel.backgroundColor=[UIColor clearColor];
        _eventTypeLabel.font=otherFont;
        _eventTypeLabel.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:_eventTypeLabel];
        
        float imageOrX=labelOrX+labelWidth+5.0f;
        
        _eventImgViewRect=CGRectMake(imageOrX,15.f, 110.f, 160.f-20.f-15.f);//:CGRectMake(imageOrX,10.f, self.frame.size.width-imageOrX-labelOrX, self.frame.size.height-labelOrY*2
        _evengImageView=[[UIImageView alloc]initWithFrame:_eventImgViewRect];
        _evengImageView.layer.borderColor=[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.6f].CGColor;
        _evengImageView.layer.borderWidth=3.f;
        _evengImageView.backgroundColor=[UIColor grayColor];
        _evengImageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_evengImageView];
        
        
        UIColor *titleColor=[UIColor colorWithString:@"#687C93"];
        UIImage *leftImg=[UIImage imageNamed:@"act_btnl"];
        float btnOrY=_evengImageView.frame.origin.y+_evengImageView.frame.size.height-leftImg.size.height;
        leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setBackgroundImage:leftImg forState:UIControlStateNormal];
        [leftBtn sizeToFit];
        [leftBtn setTitleColor:titleColor forState:UIControlStateNormal];
        leftBtn.titleLabel.font=[UIFont systemFontOfSize:14.f];
        leftBtn.userInteractionEnabled=NO;
        [leftBtn setTitle:@"0人感兴趣" forState:UIControlStateNormal];
        leftBtn.frame=CGRectMake(labelOrX, btnOrY, leftBtn.frame.size.width, leftBtn.frame.size.height);
        [self.contentView addSubview:leftBtn];
        
        UIImage *rightImg=[UIImage imageNamed:@"act_btnr"];
        rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setBackgroundImage:rightImg forState:UIControlStateNormal];
        [rightBtn sizeToFit];
        rightBtn.titleLabel.font=[UIFont systemFontOfSize:14.f];
        [rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
        rightBtn.userInteractionEnabled=NO;
        [rightBtn setTitle:@"0人参加" forState:UIControlStateNormal];
        rightBtn.frame=CGRectMake(leftBtn.frame.origin.x+leftBtn.frame.size.width, leftBtn.frame.origin.y, rightBtn.frame.size.width, rightBtn.frame.size.height);
        [self.contentView addSubview:rightBtn];
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)prepareForReuse{

    [super prepareForReuse];
    _evengImageView.frame=_eventImgViewRect;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setInterestCount:(NSInteger)interestCount{

    if (interestCount==_interestCount) {
        return;
    }
    _interestCount=interestCount;
    NSString *title=[NSString stringWithFormat:@"%d人感兴趣",interestCount];
    [leftBtn setTitle:title forState:UIControlStateNormal];
}

-(void)setJoinCount:(NSInteger)joinCount{

    if (joinCount==_joinCount) {
        return;
    }
    _joinCount=joinCount;
    NSString *title=[NSString stringWithFormat:@"%d人参加",joinCount];
    [rightBtn setTitle:title forState:UIControlStateNormal];
}
@end