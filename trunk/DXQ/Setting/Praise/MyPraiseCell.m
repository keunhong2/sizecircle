//
//  MyPraiseCell.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-2.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "MyPraiseCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyPraiseCell

-(void)dealloc{

    [_praiseDateLabel release];
    [_praiseNameLabel release];
    [_praiseDateLabel release];
    [_praiseTypeLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _praiseImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5.f, 5.f, 75.f-10.f, 75.f-10.f)];
        _praiseImageView.layer.borderColor=[UIColor colorWithRed:1. green:1. blue:1. alpha:0.4f].CGColor;
        _praiseImageView.layer.borderWidth=3;
        _praiseImageView.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:_praiseImageView];
        
        _praiseNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(80.f, 5.f, self.contentView.frame.size.width-150.f, self.contentView.frame.size.height)];
        _praiseNameLabel.backgroundColor=[UIColor clearColor];
        _praiseNameLabel.font=TitleDefaultFont;
        _praiseNameLabel.numberOfLines=0;
        _praiseNameLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_praiseNameLabel];
        
        _praiseDateLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-90.f, 5.f, 80.f, 25.f)];
        _praiseDateLabel.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        _praiseDateLabel.backgroundColor=[UIColor clearColor];
        _praiseDateLabel.textColor=[UIColor grayColor];
        _praiseDateLabel.shadowColor=[UIColor whiteColor];
        _praiseDateLabel.shadowOffset=CGSizeMake(0.f, 1.f);
        _praiseDateLabel.textAlignment=UITextAlignmentRight;
        _praiseDateLabel.font=NormalDefaultFont;
        [self.contentView addSubview:_praiseDateLabel];
        
        _praiseTypeLabel=[[UILabel alloc]initWithFrame:CGRectMake(_praiseDateLabel.frame.origin.x, 35.f, 80.f, 25.f)];
        _praiseTypeLabel.backgroundColor=[UIColor clearColor];
        _praiseTypeLabel.textColor=[UIColor colorWithRed:46.f/255.f green:65.f/255.f blue:118.f/255.f alpha:1.f];
        _praiseTypeLabel.textAlignment=UITextAlignmentRight;
        _praiseTypeLabel.font=NormalDefaultFont;
        [self.contentView addSubview:_praiseTypeLabel];
        
    }
    return self;
}

-(void)prepareForReuse{

    [super prepareForReuse];
    _praiseImageView.frame=CGRectMake(5.f, 5.f, 75.f-10.f, 75.f-10.f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setViewSelected:selected];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

    [super setHighlighted:highlighted animated:animated];
    [self setViewSelected:highlighted];
}

-(void)setViewSelected:(BOOL)selected{

    if (selected) {
        _praiseNameLabel.textColor=[UIColor whiteColor];
        _praiseDateLabel.textColor=[UIColor whiteColor];
        _praiseTypeLabel.textColor=[UIColor whiteColor];
    }else
    {
        _praiseNameLabel.textColor=[UIColor blackColor];
        _praiseDateLabel.textColor=[UIColor grayColor];
        _praiseTypeLabel.textColor=[UIColor clearColor];
        _praiseTypeLabel.textColor=[UIColor colorWithRed:46.f/255.f green:65.f/255.f blue:118.f/255.f alpha:1.f];
    }
}


-(void)setOpDate:(NSDate *)opDate{

    if ([opDate isEqualToDate:_opDate]) {
        return;
    }
    [_opDate release];
    _opDate=[opDate retain];
    NSInteger time=-[_opDate timeIntervalSinceDate:[NSDate date]];
    if (time<60) {
        self.praiseDateLabel.text=AppLocalizedString(@"刚刚赞");
    }else if (time<60*60&&time>60){
    
        NSString *tempText=[NSString stringWithFormat:@"%d分钟前赞",time/60];
        self.praiseDateLabel.text=tempText;
    }else if (time<60*60*60&&time>60*60){
        NSString *tempText=[NSString stringWithFormat:@"%d小时前赞",time/60/60];
        self.praiseDateLabel.text=tempText;
    }else if (time<60*60*60*24&&time>60*60*60){
        NSString *tempText=[NSString stringWithFormat:@"%d天前赞",time/60/60/24];
        self.praiseDateLabel.text=tempText;
    }else
        self.praiseDateLabel.text=@"未知";
}
@end
