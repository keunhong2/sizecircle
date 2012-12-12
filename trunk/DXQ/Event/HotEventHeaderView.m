//
//  HotEventHeaderView.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-23.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "HotEventHeaderView.h"
#import "UIColor+ColorUtils.h"

@interface HotEventHeaderView (){

    UIImageView *_bgImgView;
    UIImageView *_locationImgView;
    UIImageView *_dateImgView;
    UIImageView *_infoImgView;
}

@end

@implementation HotEventHeaderView


-(void)dealloc{

    [_bgImgView release];
    [_locationImgView release];
    [_dateImgView release];
    [_infoImgView release];
    [_imageView release];
    [_nameLabel release];
    [_locationLabel release];
    [_dateLabel release];
    [_infoLabel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];

        UIImage *bgImg=[UIImage imageNamed:@"detail_bg"];
        UIImage *newImg=[bgImg stretchableImageWithLeftCapWidth:bgImg.size.width/2 topCapHeight:bgImg.size.height/2];
        _bgImgView=[[UIImageView alloc]initWithFrame:CGRectMake(7.f, 7.f, self.frame.size.width-14.f, self.frame.size.height-14.f)];
        _bgImgView.image=newImg;
        _bgImgView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_bgImgView];
        
        float imageOrX=10.f+5.f;
        float imageOrY=10.f+3.f;
        float imageWidth=80.f;
        float imageHeight=80.f;
        _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(imageOrX, imageOrY, imageWidth, imageHeight)];
        _imageView.backgroundColor=[UIColor grayColor];
        [self addSubview:_imageView];
        
        float nameLabOrX=_imageView.frame.origin.x+_imageView.frame.size.width+5.f;
        float nameLabOrY=imageOrY;
        float nameLabWidth=self.frame.size.width-imageOrX-imageWidth-15.f;
        float nameLabHeight=18.f;
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(nameLabOrX, nameLabOrY, nameLabWidth, nameLabHeight)];
        _nameLabel.backgroundColor=[UIColor clearColor];
        _nameLabel.font=[UIFont boldSystemFontOfSize:18.f];
        [self addSubview:_nameLabel];
        
        float locationOrX=nameLabOrX;
        float locationOrY=20.f+nameLabOrY;
        _locationImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_position"]];
        _locationImgView.frame=CGRectMake(locationOrX, locationOrY, _locationImgView.frame.size.width, _locationImgView.frame.size.height);
        [self addSubview:_locationImgView];
        
        float labelOrX=locationOrX+_locationImgView.frame.size.width+5.f;
        float labelWidth=self.frame.size.width-labelOrX-15.f;
        _locationLabel=[self labelWithFrame:CGRectMake(labelOrX, _locationImgView.frame.origin.y,labelWidth,_locationImgView.frame.size.height)];
        _locationLabel.textColor=[UIColor colorWithString:@"#D18E3F"];
        [self addSubview:_locationLabel];
        
        float dateOrY=locationOrY+_locationImgView.frame.size.height+5.f;
        _dateImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_time"]];
        _dateImgView.frame=CGRectMake(locationOrX, dateOrY, _dateImgView.frame.size.width, _dateImgView.frame.size.height);
        [self addSubview:_dateImgView];
        
        _dateLabel=[self labelWithFrame:CGRectMake(labelOrX, dateOrY, labelWidth, _dateImgView.frame.size.height)];
        [self addSubview:_dateLabel];
        
        float infoOrY=dateOrY+_dateImgView.frame.size.height+5.f;
        _infoImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_info"]];
        _infoImgView.frame=CGRectMake(locationOrX, infoOrY, _infoImgView.frame.size.width, _infoImgView.frame.size.height);
        [self addSubview:_infoImgView];
        
        _infoLabel=[self labelWithFrame:CGRectMake(labelOrX, infoOrY, labelWidth, _infoImgView.frame.size.height)];
        [self addSubview:_infoLabel];
        
    }
    return self;
}

-(UILabel *)labelWithFrame:(CGRect)frame{

    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.backgroundColor=[UIColor clearColor];
    label.textColor=[UIColor grayColor];
    label.font=[UIFont systemFontOfSize:14.f];
    return label;
    
}
@end
