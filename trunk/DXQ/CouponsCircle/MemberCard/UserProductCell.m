//
//  UserProductCell.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-16.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UserProductCell.h"

@implementation UserProductCell

@synthesize productImageView=_productImageView;
@synthesize productNameLabel=_productNameLabel;
@synthesize exdateLabel=_exdateLabel;

-(void)dealloc{

    [_productNameLabel release];
    [_productImageView release];
    [_exdateLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float height=75.f-10.f;
        _productImageView=[[UIImageView alloc]initWithFrame:CGRectMake(15.f, 5.f, height, height)];
        _productImageView.contentMode=UIViewContentModeScaleAspectFit;
        _productImageView.layer.borderColor=[UIColor colorWithRed:1. green:1. blue:1. alpha:0.4f].CGColor;
        _productImageView.layer.borderWidth=2;
        _productImageView.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:_productImageView];
        
        _productNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(90.f, 7.f, self.contentView.frame.size.width-100.f, 40.f)];
        _productNameLabel.backgroundColor=[UIColor clearColor];
        _productNameLabel.font=[UIFont boldSystemFontOfSize:18.f];
        _productNameLabel.numberOfLines=0;
        [self.contentView addSubview:_productNameLabel];
        
        _exdateLabel=[[UILabel alloc]initWithFrame:CGRectMake(90.f, 45.f, self.contentView.frame.size.width-100.f, 30.f)];
        _exdateLabel.backgroundColor=[UIColor clearColor];
        _exdateLabel.textColor=[UIColor grayColor];
        _exdateLabel.font=[UIFont systemFontOfSize:14.f];
        _exdateLabel.numberOfLines=0;
        [self.contentView addSubview:_exdateLabel];
    }
    return self;
}

-(void)prepareForReuse{

    [super prepareForReuse];
    float height=75.f-10.f;
    _productImageView.frame=CGRectMake(15.f, 5.f, height, height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setViewSelect:selected];
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

    [super setHighlighted:highlighted animated:animated];
    [self setViewSelect:highlighted];
}

-(void)setViewSelect:(BOOL)selected{

    if (selected) {
        self.productNameLabel.textColor=[UIColor whiteColor];
        self.exdateLabel.textColor=[UIColor whiteColor];
    }else{
        self.productNameLabel.textColor=[UIColor blackColor];
        self.exdateLabel.textColor=[UIColor grayColor];
    }
}

@end
