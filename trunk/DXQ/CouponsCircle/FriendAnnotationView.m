//
//  FriendAnnotationView.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "FriendAnnotationView.h"

@interface FriendAnnotationView (){

    FriendSexAndAgeView *_sexAndAgeView;
}

@end
@implementation FriendAnnotationView

-(void)dealloc{

    [_headerImageView release];
    [_sexAndAgeView release];
    [super dealloc];
}

-(id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{

    self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *bgImg=[UIImage imageNamed:@"dt_zz"];
        UIImageView *bgImgView=[[UIImageView alloc]initWithImage:bgImg];
        [self addSubview:bgImgView];
        [bgImgView release];
        
        _headerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(4.f, 4.f, 54.f-8.f, 54.f-8.f)];
        _headerImageView.backgroundColor=[UIColor grayColor];
        [self addSubview:_headerImageView];
        
//        _sexAndAgeView=[[FriendSexAndAgeView alloc]initWithGender:YES];
//        _sexAndAgeView.frame=CGRectMake(0.f, _headerImageView.frame.size.height-_sexAndAgeView.frame.size.height, _sexAndAgeView.frame.size.width, _sexAndAgeView.frame.size.height);
//        _sexAndAgeView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin;
//        [_headerImageView addSubview:_sexAndAgeView];
        self.centerOffset=CGPointMake(-27.f, -70.f);
    }
    return self;
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{

    NSMethodSignature *signatrue=[super methodSignatureForSelector:aSelector];
    if (!signatrue) {
        return [_sexAndAgeView methodSignatureForSelector:aSelector];
    }
    return signatrue;
}

@end

@implementation FriendSexAndAgeView

-(void)dealloc{
    
    [_genderImageView release];
    [_ageLabel release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        UIImage *sexImg=nil;
        _age=18;
        if (_male) {
            sexImg=[UIImage imageNamed:@"pyq_boy"];
        }else
            sexImg=[UIImage imageNamed:@"pyq_girl"];
        _genderImageView=[[UIImageView alloc]initWithImage:sexImg];
        _genderImageView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_genderImageView];
        
        _ageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width-2.f, self.frame.size.height)];
        _ageLabel.backgroundColor=[UIColor clearColor];
        _ageLabel.font=NormalDefaultFont;
        _ageLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _ageLabel.textColor=[UIColor whiteColor];
        [self addSubview:_ageLabel];
        _ageLabel.text=[NSString stringWithFormat:@"%d",_age];
    }
    return self;
}

-(id)initWithGender:(BOOL)male{

    _male=male;
    return [self initWithFrame:CGRectMake(0.f, 0.f, 28.f, 15.f)];
}

-(void)setAge:(NSInteger)age{

    if (age==_age) {
        return;
    }
    _age=age;
    _ageLabel.text=[NSString stringWithFormat:@"%d",age];
}

-(void)setMale:(BOOL)male{

    if (male==_male) {
        return;
    }
    _male=male;
    if (male) {
        _genderImageView.image=[UIImage imageNamed:@"pyq_boy"];
    }else
        _genderImageView.image=[UIImage imageNamed:@"pyq_girl"];
}
@end
