//
//  UserMemberCell.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UserMemberCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+ColorUtils.h"
#import "UIImageView+WebCache.h"    

@interface UserMemberCell ()
{
    UserMemberView *leftMemberView;
    UserMemberView *rightMemberView;
}
@end

@implementation UserMemberCell

@synthesize userMemberArray=_userMemberArray;

-(void)dealloc{

    [_userMemberArray release];
    [leftMemberView release];
    [rightMemberView release];
    [super dealloc];
}

-(void)setUserMemberArray:(NSArray *)userMemberArray{

    if ([userMemberArray isEqualToArray:_userMemberArray]) {
        return;
    }
    [_userMemberArray release];
    _userMemberArray=[userMemberArray retain];
    
    if (userMemberArray.count>1) {
        if (!rightMemberView){
            rightMemberView=[[UserMemberView alloc]initWithFrame:CGRectMake(30.f+137.f, 15.f, 137.f, 120.f)];
            [rightMemberView addTarget:self action:@selector(memberViewTap:) forControlEvents:UIControlEventTouchUpInside];
            rightMemberView.tag=2;
            rightMemberView.memberImageView.contentMode=UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:rightMemberView];
        }
        NSDictionary *dic=[userMemberArray objectAtIndex:1];
        rightMemberView.memberImageView.image=nil;
        rightMemberView.memberImageView.frame=CGRectMake(0.f, 0.f, rightMemberView.frame.size.width, rightMemberView.frame.size.height-20.f);
        [rightMemberView.memberImageView setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"PhotoUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"pic_default"] success:^(UIImage *image ,BOOL isChache){
            [Tool setImageView:rightMemberView.memberImageView toImage:image];
        } failure:nil];
        rightMemberView.memberNameLabel.text=[dic objectForKey:@"Title"];
    }else
    {
        [rightMemberView removeFromSuperview];
        [rightMemberView release];
        rightMemberView=nil;
    }
    
    if (userMemberArray.count>0) {
        if (!leftMemberView){
            leftMemberView=[[UserMemberView alloc]initWithFrame:CGRectMake(15.f, 15.f, 137.f, 120.f)];
            leftMemberView.tag=1;
            [leftMemberView addTarget:self action:@selector(memberViewTap:) forControlEvents:UIControlEventTouchUpInside];
            leftMemberView.memberImageView.contentMode=UIViewContentModeScaleAspectFit;
            [self.contentView addSubview:leftMemberView];
        }
        
        NSDictionary *dic=[userMemberArray objectAtIndex:0];
        leftMemberView.memberImageView.frame=CGRectMake(0.f, 0.f, leftMemberView.frame.size.width, leftMemberView.frame.size.height-20.f);
        [leftMemberView.memberImageView setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"PhotoUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil success:^(UIImage *image ,BOOL isChache){
            [Tool setImageView:leftMemberView.memberImageView toImage:image];
        } failure:nil];
        leftMemberView.memberNameLabel.text=[dic objectForKey:@"Title"];
    }else
    {
        [leftMemberView removeFromSuperview];
        [leftMemberView release];
        leftMemberView=nil;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setTarget:(id)target action:(SEL)action{

    tapTarget=target;
    _action=action;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)memberViewTap:(UserMemberView *)view{

    NSIndexPath *indexPath=[(UITableView *)[self superview] indexPathForCell:self];
    
    [tapTarget performSelector:_action withObject:view withObject:indexPath];
}

@end


@implementation UserMemberView

@synthesize memberImageView=_memberImageView;
@synthesize memberNameLabel=_memberNameLabel;

-(void)dealloc{

    [_memberNameLabel release];
    [_memberImageView release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        
        _memberImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height-20.f)];
        _memberImageView.layer.borderWidth=2.f;
        _memberImageView.backgroundColor=[UIColor grayColor];
        _memberImageView.layer.masksToBounds=YES;
        _memberImageView.layer.borderColor=[UIColor whiteColor].CGColor;
        _memberImageView.layer.cornerRadius=2.f;
        _memberImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        [self addSubview:_memberImageView];
        
        _memberNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0.f, self.frame.size.height-20.f, self.frame.size.width, 20.f)];
        _memberNameLabel.backgroundColor=[UIColor clearColor];
        _memberNameLabel.textAlignment=UITextAlignmentCenter;
        _memberNameLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        _memberNameLabel.textColor=[UIColor colorWithString:@"#5B5B5B"];
        _memberNameLabel.shadowColor=[UIColor whiteColor];
        _memberNameLabel.font=NormalDefaultFont;
        _memberNameLabel.shadowOffset=CGSizeMake(0.f, 1.f);
        [self addSubview:_memberNameLabel];
    
    }
    return self;
}
@end