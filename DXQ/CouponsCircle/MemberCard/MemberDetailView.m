//
//  MemberDetailView.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "MemberDetailView.h"
#import "UIColor+ColorUtils.h"

@implementation MemberBaseBgView

-(id)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if (self) {
        
        UIImage *bgImg=[UIImage imageNamed:@"detail_bg"];
        UIImage *scImg=[bgImg stretchableImageWithLeftCapWidth:bgImg.size.width/2 topCapHeight:bgImg.size.height/2];
        UIImageView *bgImgView=[[UIImageView alloc]initWithImage:scImg];
        bgImgView.frame=self.bounds;
        bgImgView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:bgImgView];
        [bgImgView release];

    }
    return self;
}

@end

@interface MemberDetailView ()
{
    UIButton *firstBtn;
    UIButton *secoundBtn;
    UILabel *firstLabel;
    UILabel *secoundLabel;
}
@end

@implementation MemberDetailView

@synthesize firstLineText=_firstLineText;
@synthesize secoundLineText=_secoundLineText;
@synthesize firstImage=_firstImage;
@synthesize secoundImage=_secoundImage;
@synthesize imageLocationLeft=_imageLocationLeft;
@synthesize delegate=_delegate;


-(void)dealloc{

    [_firstImage release];
    [_secoundImage release];
    [firstLabel release];
    [secoundLabel release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if (self) {
        _imageLocationLeft=YES;
        
        firstLabel=[[UILabel alloc]initWithFrame:CGRectMake(10.f, 10.f, self.frame.size.width-40.f, 16.f)];
        firstLabel.font=MiddleNormalDefaultFont;
        firstLabel.backgroundColor=[UIColor clearColor];
        firstLabel.textColor=GrayColorForTextColor;
        [self addSubview:firstLabel];
        
        secoundLabel=[[UILabel alloc]initWithFrame:CGRectMake(10.f, 38.f, self.frame.size.width-40.f, 16.f)];
        secoundLabel.font=MiddleNormalDefaultFont;
        secoundLabel.backgroundColor=[UIColor clearColor];
        secoundLabel.textColor=GrayColorForTextColor;
        [self addSubview:secoundLabel];
        
    }
    return self;
}


-(void)setFirstImage:(UIImage *)firstImage{

    if ([firstImage isEqual:_firstImage]) {
        return;
    }
    
    [_firstImage release];
    _firstImage=[firstImage retain];
    
    if (!firstBtn) {
        firstBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        firstBtn.adjustsImageWhenHighlighted=NO;
        [firstBtn setImage:firstImage forState:UIControlStateNormal];
        [firstBtn sizeToFit];
        
        if (_imageLocationLeft) {
            firstBtn.frame=CGRectMake(10.f, 10.f, firstBtn.frame.size.width, firstBtn.frame.size.height);
            firstBtn.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
            firstLabel.frame=CGRectMake(firstLabel.frame.origin.x+20.f, firstLabel.frame.origin.y,firstLabel.frame.size.width,firstLabel.frame.size.height);
        }else
        {
            firstBtn.frame=CGRectMake(self.frame.size.width-10.f-firstBtn.frame.size.width, 10.f, firstBtn.frame.size.width, firstBtn.frame.size.height);
            firstBtn.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        }
        [firstBtn addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:firstBtn];
    }
    
    if (firstImage) {
        [firstBtn setImage:firstImage forState:UIControlStateNormal];
    }else
    {
        [firstBtn removeFromSuperview];
        firstBtn=nil;
       
        if (firstLabel) {
            firstLabel.frame=CGRectMake(firstLabel.frame.origin.x-20.f, firstLabel.frame.origin.y, firstLabel.frame.size.width, firstLabel.frame.size.height);
        }
    }
}


-(void)setSecoundImage:(UIImage *)secoundImage{

    if ([secoundImage isEqual:_secoundImage]) {
        return;
    }
    [_secoundImage release];
    _secoundImage=[secoundImage retain];
    
    if (!secoundBtn) {
        secoundBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        secoundBtn.adjustsImageWhenHighlighted=NO;
        [secoundBtn setImage:secoundImage forState:UIControlStateNormal];
        [secoundBtn sizeToFit];
        
        if (_imageLocationLeft) {
            secoundBtn.frame=CGRectMake(10.f, 38.f, secoundBtn.frame.size.width, secoundBtn.frame.size.height);
            secoundBtn.autoresizingMask=UIViewAutoresizingFlexibleRightMargin;
            secoundLabel.frame=CGRectMake(secoundLabel.frame.origin.x+20.f, secoundLabel.frame.origin.y, secoundLabel.frame.size.width, secoundLabel.frame.size.height);
        }else
        {
            secoundBtn.frame=CGRectMake(self.frame.size.width-10.f-secoundBtn.frame.size.width, 38.f, secoundBtn.frame.size.width, secoundBtn.frame.size.height);
            secoundBtn.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin;
        }
        [secoundBtn addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:secoundBtn];
    }
    
    if (secoundImage) {
        [secoundBtn setImage:secoundImage forState:UIControlStateNormal];
    }else
    {
        [secoundBtn removeFromSuperview];
        secoundBtn=nil;
        
        
        if (secoundLabel) {
            secoundLabel.frame=CGRectMake(secoundLabel.frame.origin.x-20.f, secoundLabel.frame.origin.y, secoundLabel.frame.size.width, secoundLabel.frame.size.height);
        }
    }
}


-(void)setFirstLineText:(NSString *)firstLineText{

    firstLabel.text=firstLineText;
}

-(NSString *)firstLineText{

    return firstLabel.text;
}

-(void)setSecoundLineText:(NSString *)secoundLineText{

    secoundLabel.text=secoundLineText;
}

-(NSString *)secoundLineText{

    return secoundLabel.text;
}

-(void)setImageLocationLeft:(BOOL)imageLocationLeft{

    if (imageLocationLeft==self.imageLocationLeft) {
        return;
    }
    _imageLocationLeft=imageLocationLeft;
    
    CGRect firstBtnRect=CGRectZero;
    CGRect secoundBtnRect=CGRectZero;
    CGRect firstLabelRect=CGRectZero;
    CGRect secoundLabelRect=CGRectZero;
    
    if (imageLocationLeft) {
        if (firstBtn) {
            firstBtnRect=CGRectMake(10.f, 10.f, firstBtn.frame.size.width, firstBtn.frame.size.height);
            firstLabelRect=CGRectMake(30.f, 10.f, firstLabel.frame.size.width, firstLabel.frame.size.height);
        }else
            firstLabelRect=CGRectMake(10.f, 10.f, firstLabel.frame.size.width, firstLabel.frame.size.height);
        
        if (secoundBtn) {
            secoundBtnRect=CGRectMake(10.f, 38.f, secoundBtn.frame.size.width, secoundBtn.frame.size.height);
            secoundLabelRect=CGRectMake(30.f, 38.f, secoundLabel.frame.size.width, secoundLabel.frame.size.height);
        }else
            secoundLabelRect=CGRectMake(10.f, 38.f, secoundLabel.frame.size.width, secoundLabel.frame.size.height);
    }else
    {
        if (firstBtn) {
            firstBtnRect=CGRectMake(self.frame.size.width-10.f-firstBtn.frame.size.width, 10.f, firstBtn.frame.size.width, firstBtn.frame.size.height);
            firstLabelRect=CGRectMake(10.f, 10.f, firstLabel.frame.size.width, firstLabel.frame.size.height);
        }else
            firstLabelRect=CGRectMake(10.f, 10.f, firstLabel.frame.size.width, firstLabel.frame.size.height);
        
        if (secoundBtn) {
            secoundBtnRect=CGRectMake(self.frame.size.width-10.f-secoundBtn.frame.size.width, 38.f, secoundBtn.frame.size.width, secoundBtn.frame.size.height);
            secoundLabelRect=CGRectMake(10.f, 38.f, secoundLabel.frame.size.width, secoundLabel.frame.size.height);
        }else
            secoundLabelRect=CGRectMake(10.f, 38.f, secoundLabel.frame.size.width, secoundLabel.frame.size.height);
    }
}

-(void)btnDone:(UIButton *)btn{

    if (_delegate&&[_delegate respondsToSelector:@selector(memberDetailView:imageTapIsFirst:)]) {
        BOOL isFirst=NO;
        if ([btn isEqual:firstBtn]) {
            isFirst=YES;
        }
        [_delegate memberDetailView:self imageTapIsFirst:isFirst];
    }
}
@end
