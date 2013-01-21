//
//  FansView.m
//  DXQ
//
//  Created by Yuan on 12-10-19.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "FansView.h"

@implementation FansView

@synthesize starImageView = _starImageView;

@synthesize fansCountLbl = _fansCountLbl;

-(void)dealloc
{
    [_starImageView release];_starImageView = nil;
    
    [_fansCountLbl release]; _fansCountLbl = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _fansCount=0;
        _isFans=NO;
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *bgimg = [UIImage imageNamed:@"pyq_fans_bg.png"];
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bgimg.size.width, bgimg.size.height)];
        [bgImageView setImage:bgimg];
        [self addSubview:bgImageView];
        [bgImageView release];
        
        UIImage *starimg = [UIImage imageNamed:@"pyq_fans.png"];
        _starImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8,bgimg.size.height/2-starimg.size.height/2, starimg.size.width, starimg.size.height)];
        [_starImageView setImage:starimg];
        [_starImageView setTag:1];
        [_starImageView setUserInteractionEnabled:YES];
        [self addSubview:_starImageView];

        UITapGestureRecognizer *_starImageViewTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
        [_starImageView addGestureRecognizer:_starImageViewTap];
        [_starImageViewTap release];
            
        _fansCountLbl = [[UILabel alloc]initWithFrame:CGRectMake(starimg.size.width+10,0,bgimg.size.width-starimg.size.width - 14, bgimg.size.height)];
        [_fansCountLbl setAdjustsFontSizeToFitWidth:YES];
        [_fansCountLbl setTextColor:[UIColor whiteColor]];
        [_fansCountLbl setTextAlignment:UITextAlignmentCenter];
        [_fansCountLbl setBackgroundColor:[UIColor clearColor]];
        [_fansCountLbl setFont:[UIFont systemFontOfSize:12.0]];
        [_fansCountLbl setUserInteractionEnabled:YES];
        [_fansCountLbl setTag:2];
        _fansCountLbl.text=[NSString stringWithFormat:@"粉丝:%d",_fansCount];
        [self addSubview:_fansCountLbl];

        UITapGestureRecognizer *_fansCountLblTap = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
        [_fansCountLbl addGestureRecognizer:_fansCountLblTap];
        [_fansCountLblTap release];
        
        frame.size = bgimg.size;
        self.frame = frame;
        
        self.userInteractionEnabled = YES;
    }
    
    return self;
}

-(void)setIsFans:(BOOL)isFans
{
    if (isFans==self.isFans) {
        return;
    }
    _isFans=isFans;
    
    NSString *imgname = !isFans?@"pyq_fans.png":@"pyq_fans_hot.png";
    [_starImageView setImage:[UIImage imageNamed:imgname]];
}

-(void)setFansCount:(NSInteger)fansCount
{
    if (fansCount==_fansCount) {
        return;
    }
    _fansCount = fansCount;
    
    _fansCountLbl.text=[NSString stringWithFormat:@"粉丝:%d",fansCount];
}

@end


@implementation LikesView

-(id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action
{
    self=[super initWithFrame:frame target:target action:action];
    if (self) {
        self.starImageView.image=nil;
        self.fansCountLbl.text=[NSString stringWithFormat:@"关注:%d",[self fansCount]];
    }
    return self;
}


-(void)setIsFans:(BOOL)isFans
{
    
}

-(void)setFansCount:(NSInteger)fansCount
{
    if (fansCount==self.fansCount) {
        return;
    }
    
    [super setFansCount:fansCount];
    
    self.fansCountLbl.text=[NSString stringWithFormat:@"关注:%d",fansCount];
}
@end