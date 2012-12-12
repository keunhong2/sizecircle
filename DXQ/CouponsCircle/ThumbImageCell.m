//
//  ThumbImageCell.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-16.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ThumbImageCell.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#define THUMB_IMAGE_CELL_DEFAULT_SITE_MARGIN        4.f

@interface ThumbImageCell (){
    
    float imageWeidth;
    float imageHeight;
    float siteMargin;
    NSMutableArray *imageViewArray;
}

@end
@implementation ThumbImageCell

@synthesize maxNumberOfImage=_maxNumberOfImage;
@synthesize imageSourceArray=_imageSourceArray;


-(void)dealloc{
    
    [_imageSourceArray release];
    [imageViewArray release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier maxNumber:4];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier maxNumber:(NSInteger)number{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        siteMargin=THUMB_IMAGE_CELL_DEFAULT_SITE_MARGIN;
        
        imageWeidth=(self.frame.size.width-THUMB_IMAGE_CELL_DEFAULT_SITE_MARGIN*2-(number-1)*THUMB_IMAGE_CELL_DEFAULT_SITE_MARGIN)/number;
        imageHeight=imageWeidth;
        
        _maxNumberOfImage=number;
        
        imageViewArray=[NSMutableArray new];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)setImageSourceArray:(NSArray *)imageSourceArray
{
    if ([imageSourceArray isEqualToArray:_imageSourceArray])
    {
        return;
    }
    NSInteger value=imageSourceArray.count-_imageSourceArray.count;
    if (value>0)
    {
        for (int i=0; i<value; i++)
        {
            UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:imageView];
            [imageViewArray addObject:imageView];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            imageView.tag=imageViewArray.count;
            imageView.userInteractionEnabled=YES;
            imageView.layer.borderWidth=2.0f;
            imageView.layer.borderColor=[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.2f].CGColor;
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            [imageView addGestureRecognizer:tap];
            [tap release];
            [imageView release];
        }
    }else if (value<0)
    {
        NSArray *removeImageArray=[imageViewArray subarrayWithRange:NSMakeRange(imageViewArray.count+value, -value)];
        for (UIView *view in removeImageArray) {
            [view removeFromSuperview];
        }
        [imageViewArray removeObjectsInArray:removeImageArray];
    }
    for (int i=0; i<imageSourceArray.count; i++)
    {
        NSDictionary *item = [imageSourceArray objectAtIndex:i];
        UIImageView *imageView=[imageViewArray objectAtIndex:i];
        
        imageView.frame=CGRectMake(siteMargin+(siteMargin +imageWeidth)*i, siteMargin, imageWeidth, imageHeight);
        
        NSString *key=nil;
        if ([[item allKeys]containsObject:@"PhotoUrl"]) {
            key=@"PhotoUrl";
        }else if ([[item allKeys]containsObject:@"FilePath"])
            key=@"FilePath";
        NSString *url=[[item objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"tx_gray.png"]success:^(UIImage *image,BOOL isCache){
        
            [Tool setImageView:imageView toImage:image];
            
        } failure:nil];
    }
    [_imageSourceArray release];
    _imageSourceArray=[imageSourceArray retain];
}

-(void)addTapTarget:(id)target action:(SEL)action{
    
    actionTarget=target;
    _action=action;
}


-(void)tap:(UITapGestureRecognizer *)tap{
    
    UIView *view=[tap view];
    NSIndexPath *indexPath=[(UITableView *)[self superview] indexPathForCell:self];
    
    if (actionTarget) {
        [actionTarget performSelector:_action withObject:indexPath withObject:view];
    }
}
@end
