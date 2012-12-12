//
//  BusinessCircleListCell.m
//  DXQ
//
//  Created by Yuan on 12-10-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BusinessListCell.h"
#import "UIColor+ColorUtils.h"

@interface BusinessListCell ()

-(void)setLabelSelect:(BOOL)selected;

@end

@implementation BusinessListCell
@synthesize businessImageView = _businessImageView;
@synthesize businessNameLbl = _businessNameLbl;
@synthesize businessLastestInfoLbl = _businessLastestInfoLbl;
@synthesize distanceLbl = _distanceLbl;

-(void)dealloc
{    
    [_businessImageView release];_businessImageView = nil;
    [_businessNameLbl release];_businessNameLbl = nil;
    [_businessLastestInfoLbl release]; _businessLastestInfoLbl = nil;
    [_distanceLbl release];_distanceLbl = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.businessImageView = [[[UIImageView alloc]initWithFrame:CGRectMake(10.f,5.f, 60.f, 60.f)] autorelease];
        self.businessImageView.contentMode=UIViewContentModeScaleAspectFit;
        self.businessImageView.layer.borderColor=[UIColor colorWithRed:1. green:1. blue:1. alpha:0.4f].CGColor;
        self.businessImageView.layer.borderWidth=3.f;
        self.businessImageView.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:self.businessImageView];
        
        self.businessNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(80.f, 5.f, self.contentView.frame.size.width-90.f, 20.f)];
        self.businessNameLbl.backgroundColor=[UIColor clearColor];
        self.businessNameLbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        self.businessNameLbl.font= TitleDefaultFont;
        [self.contentView addSubview:self.businessNameLbl];
        
        self.businessLastestInfoLbl=[[UILabel alloc]initWithFrame:CGRectMake(80.f, 25.f+5.f/2, self.contentView.frame.size.width-90.f, 20.f)];
        self.businessLastestInfoLbl.backgroundColor=[UIColor clearColor];
        self.businessLastestInfoLbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        self.businessLastestInfoLbl.font= MiddleBoldDefaultFont;
        self.businessLastestInfoLbl.textColor=[UIColor colorWithString:@"#D18E3F"];
        [self.contentView addSubview:self.businessLastestInfoLbl];
        
        self.distanceLbl=[[UILabel alloc]initWithFrame:CGRectMake(80.f, 46.f, self.contentView.frame.size.width-90.f, 20.f)];
        self.distanceLbl.backgroundColor=[UIColor clearColor];
        self.distanceLbl.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        self.distanceLbl.font= NormalDefaultFont;
        self.distanceLbl.textColor=[UIColor grayColor];
        [self.contentView addSubview:self.distanceLbl];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    [self setLabelSelect:selected];
    // Configure the view for the selected state
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{

    [super setHighlighted:highlighted animated:animated];
    [self setLabelSelect:highlighted];
}


-(void)setLabelSelect:(BOOL)selected{

    if (selected)
    {
        self.businessNameLbl.textColor=[UIColor whiteColor];
        self.businessLastestInfoLbl.textColor=[UIColor whiteColor];
        self.distanceLbl.textColor=[UIColor whiteColor];
    }else
    {
        self.businessNameLbl.textColor=[UIColor blackColor];
        self.businessLastestInfoLbl.textColor=[UIColor colorWithString:@"#D18E3F"];
        self.distanceLbl.textColor=[UIColor grayColor];
    }
}
@end
