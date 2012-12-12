//
//  MemberDetailBusinessInfoView.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "MemberDetailBusinessInfoView.h"
#import "UIColor+ColorUtils.h"
#import "UIImageView+WebCache.h"

@implementation MemberDetailBusinessInfoView


@synthesize businessImageView=_businessImageView;
@synthesize businessNameLabel=_businessNameLabel;
@synthesize countDownLabel=_countDownLabel;
@synthesize outDateLabel=_outDateLabel;

-(void)dealloc{

    [_businessImageView release];
    [_businessNameLabel release];
    [_countDownLabel release];
    [_outDateLabel release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];

        _businessImageView=[[UIImageView alloc]initWithFrame:CGRectMake(5.f, 5.f, 65.f, 65.f)];
        _businessImageView.contentMode=UIViewContentModeScaleAspectFit;
        _businessImageView.backgroundColor=[UIColor grayColor];
        [self addSubview:_businessImageView];
        
        _businessNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(90.f, 5.f, self.frame.size.width-95.f, 23.f)];
        _businessNameLabel.backgroundColor=[UIColor clearColor];
        _businessNameLabel.font=TitleDefaultFont;
        _businessNameLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self addSubview:_businessNameLabel];
    
        UIImage *timeImg=[UIImage imageNamed:@"icon_time"];
        UIImageView *timeImageView=[[UIImageView alloc]initWithImage:timeImg];
        [timeImageView sizeToFit];
        timeImageView.frame=CGRectMake(73.f, 32.f, timeImageView.frame.size.width, timeImageView.frame.size.height);
        [self addSubview:timeImageView];
        [timeImageView release];
        
        UIImage *infoImg=[UIImage imageNamed:@"icon_info"];
        UIImageView *infoImageView=[[UIImageView alloc]initWithImage:infoImg];
        [infoImageView sizeToFit];
        infoImageView.frame=CGRectMake(73.f, 53.f, infoImageView.frame.size.width, infoImageView.frame.size.height);
        [self addSubview:infoImageView];
        [infoImageView release];
        
        _countDownLabel=[[UILabel alloc]initWithFrame:CGRectMake(90.f, 33.f, _businessNameLabel.frame.size.width, 15.f)];
        _countDownLabel.backgroundColor=[UIColor clearColor];
        _countDownLabel.textColor=[UIColor colorWithString:@"D18E3F"];
        _countDownLabel.font=MiddleNormalDefaultFont;
        _countDownLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self addSubview:_countDownLabel];
        
        _outDateLabel=[[UILabel alloc]initWithFrame:CGRectMake(90.f, 53.f, _businessNameLabel.frame.size.width, 15.f)];
        _outDateLabel.backgroundColor=[UIColor clearColor];
        _outDateLabel.font=MiddleNormalDefaultFont;
        _outDateLabel.textColor=GrayColorForTextColor;
        _outDateLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self addSubview:_outDateLabel];
    }
    return self;
}

@end



@implementation MemberActionView

@synthesize follwerBtn=_follwerBtn;
@synthesize praiseBtn=_praiseBtn;
@synthesize shareBtn=_shareBtn;

-(id)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if (self) {
        
        _follwerBtn=[self btnWithFrame:CGRectMake(40.f, 0.f, 81.f, 41.f)];
        [_follwerBtn setImage:[UIImage imageNamed:@"icon_attentive"] forState:UIControlStateNormal];
        [_follwerBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self addSubview:_follwerBtn];
        
        _praiseBtn=[self btnWithFrame:CGRectMake(40.f+81.f,0.f, 81.f, 41.f)];
        [_praiseBtn setImage:[UIImage imageNamed:@"icon_praise"] forState:UIControlStateNormal];
        [_praiseBtn setTitle:@"  赞 " forState:UIControlStateNormal];
        [self addSubview:_praiseBtn];
        
        _shareBtn=[self btnWithFrame:CGRectMake(40.f+81.f*2, 0.f, 81.f, 41.f)];
        [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
        [_shareBtn setImage:[UIImage imageNamed:@"icon_shear"] forState:UIControlStateNormal];
        [self addSubview:_shareBtn];
        
    }
    return self;
}


-(UIButton *)btnWithFrame:(CGRect)frame{

    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    btn.imageEdgeInsets=UIEdgeInsetsMake(0.f, 30.f, 20.f, 0.f);
    btn.titleEdgeInsets=UIEdgeInsetsMake(20.f, 0.f, 0.f, 22.f);
    [btn setTitleColor:GrayColorForTextColor forState:UIControlStateNormal];
    btn.titleLabel.font=NormalDefaultFont;
    return btn;
}

@end


@implementation MemberDetailHeaderView

@synthesize businessImageURL=_businessImageURL;
@synthesize businessName=_businessName;
@synthesize countDownTime=_countDownTime;
@synthesize outDate=_outDate;
@synthesize detail=_detail;

-(void)dealloc{

    [_businessImageURL release];
    [headerView release];
    [actionView release];
    [detailInfoLabel release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if (self) {
        
        UIImage *lineImg=[UIImage imageNamed:@"line2"];
        UIColor *lineColor=[UIColor colorWithPatternImage:lineImg];
        
        headerView=[[MemberDetailBusinessInfoView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, 73.f)];
        [self addSubview:headerView];
        
        UIView *firstLineView=[[UIView alloc]initWithFrame:CGRectMake(0.f, 73.f, self.frame.size.width, 1.f)];
        firstLineView.backgroundColor=lineColor;
        [self addSubview:firstLineView];
        [firstLineView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [firstLineView release];
        
        actionView=[[MemberActionView alloc]initWithFrame:CGRectMake(0.f, 74.f, self.frame.size.width, 39.f)];
        [self addSubview:actionView];
        
        UIView *secoundLineView=[[UIView alloc]initWithFrame:CGRectMake(0.f, 114.f, self.frame.size.width, 1.f)];
        secoundLineView.backgroundColor=lineColor;
        [self addSubview:secoundLineView];
        secoundLineView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [secoundLineView release];
        
        detailInfoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10.f, 115.f, self.frame.size.width-20.f,self.frame.size.height-115.f)];
        detailInfoLabel.backgroundColor=[UIColor clearColor];
        detailInfoLabel.textColor=GrayColorForTextColor;
        detailInfoLabel.font=NormalDefaultFont;
        [self addSubview:detailInfoLabel];
        detailInfoLabel.numberOfLines=0;
    }
    return self;
}

-(MemberActionView *)actionView{
    
    return actionView;
}

-(void)setBusinessImageURL:(NSURL *)businessImageURL{

    if ([businessImageURL isEqual:_businessImageURL]) {
        return;
    }
    [_businessImageURL release];
    _businessImageURL=[businessImageURL retain];
    headerView.businessImageView.frame=CGRectMake(5.f, 5.f, 65.f, 65.f);
    [headerView.businessImageView setImageWithURL:businessImageURL success:^(UIImage *image,BOOL isCache){
    
        [Tool setImageView:headerView.businessImageView toImage:image];
    } failure:nil];
}

-(void)setBusinessName:(NSString *)businessName{

    headerView.businessNameLabel.text=businessName;
}

-(NSString *)businessName{

    return headerView.businessNameLabel.text;
}

-(void)setCountDownTime:(NSString *)countDownTime{

    headerView.countDownLabel.text=countDownTime;
}

-(NSString *)countDownTime{

    return headerView.countDownLabel.text;
}

-(void)setOutDate:(NSString *)outDate{

    headerView.outDateLabel.text=outDate;
}

-(NSString *)outDate{

    return headerView.outDateLabel.text;
}

-(void)setDetail:(NSString *)detail{

    detailInfoLabel.text=detail;
}

-(NSString *)detail{

    return detailInfoLabel.text;
}
@end