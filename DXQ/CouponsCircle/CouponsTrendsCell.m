//
//  CouponsTrendsCell.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "CouponsTrendsCell.h"
#import "UIColor+ColorUtils.h"

@implementation CouponsTrendsCell

@synthesize businessHeadImageView=_businessHeadImageView;
@synthesize businessNameLabel=_businessNameLabel;
@synthesize eventInfoImageView=_eventInfoImageView;
@synthesize releaseDateLabel=_releaseDateLabel;
@synthesize detailInfoLabel=_detailInfoLabel;

-(void)dealloc{

    [_businessHeadImageView release];_businessHeadImageView=nil;
    [_businessNameLabel release];_businessNameLabel=nil;
    [_eventInfoImageView release];_eventInfoImageView=nil;
    [_releaseDateLabel release];_releaseDateLabel=nil;
    [_detailInfoLabel release];_detailInfoLabel=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //init head image view
        
        UIImage *headImageBgImage=[UIImage imageNamed:@"image_bg"];
        UIImageView *headImgBgView=[[UIImageView alloc]initWithImage:headImageBgImage];
        [headImgBgView sizeToFit];
        UIView *headContentView=[[UIView alloc]initWithFrame:CGRectMake(5.f, 5.f, headImgBgView.frame.size.width, headImgBgView.frame.size.height)];
        [self.contentView addSubview:headContentView];
        [headContentView addSubview:headImgBgView];
        _businessHeadImageView=[[UIImageView alloc]initWithFrame:CGRectMake(4.f, 4.f, headContentView.frame.size.width-9.f, headContentView.frame.size.height-10.f)];
        _businessHeadImageView.backgroundColor=[UIColor grayColor];
        _businessHeadImageView.contentMode=UIViewContentModeScaleAspectFit;
        [headContentView addSubview:_businessHeadImageView];
        [headImgBgView release];
        [headContentView release];
        
        //init about detail info view
        
        UIImage *detailBgImg=[UIImage imageNamed:@"dt_bg"];
        UIImageView *detailBgImgView=[[UIImageView alloc]initWithImage:detailBgImg];
        [detailBgImgView sizeToFit];
        UIView *detailContentView=[[UIView alloc]initWithFrame:CGRectMake(5.f, headContentView.frame.origin.y+headContentView.frame.size.height, self.contentView.frame.size.width-10.f, detailBgImg.size.height)];
        detailContentView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [detailContentView addSubview:detailBgImgView];
        [self.contentView addSubview:detailContentView];
        
        _eventInfoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5.f, 12.f, detailContentView.frame.size.width-12.f, 115.f)];
        _eventInfoImageView.contentMode=UIViewContentModeScaleAspectFill;
        _eventInfoImageView.clipsToBounds = YES;
        _eventInfoImageView.backgroundColor=[UIColor grayColor];
        [detailContentView addSubview:_eventInfoImageView];
        _detailInfoLabel=[[UILabel alloc]initWithFrame:CGRectMake(5.f, 130.f, detailContentView.frame.size.width-12.f, 40.f)];
        _detailInfoLabel.backgroundColor=[UIColor clearColor];
        _detailInfoLabel.textColor=[UIColor colorWithString:@"#868686"];
        _detailInfoLabel.font=MiddleNormalDefaultFont;
        _detailInfoLabel.numberOfLines=0;
        [detailContentView addSubview:_detailInfoLabel];
        [detailBgImgView release];
        [detailContentView release];
        
        //
        _businessNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(headContentView.frame.origin.x+headContentView.frame.size.width+5.f, headContentView.frame.origin.y,160.f, headContentView.frame.size.height)];
        _businessNameLabel.numberOfLines=0;
        _businessNameLabel.backgroundColor=[UIColor clearColor];
        _businessNameLabel.font=TitleDefaultFont;
        [self.contentView addSubview:_businessNameLabel];
        
        //
        _releaseDateLabel=[[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-170.f-10.f, headContentView.frame.origin.y, 170.f, headContentView.frame.size.height)];
        _releaseDateLabel.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        _releaseDateLabel.backgroundColor=[UIColor clearColor];
        _releaseDateLabel.textAlignment=UITextAlignmentRight;
        _releaseDateLabel.textColor=[UIColor colorWithString:@"#939393"];
        _releaseDateLabel.font=NormalDefaultFont;
        _releaseDateLabel.shadowColor=[UIColor colorWithString:@"#FFFFFF"];
        _releaseDateLabel.shadowOffset=CGSizeMake(0.f, 1.f);
        [self.contentView addSubview:_releaseDateLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
