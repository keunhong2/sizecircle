//
//  UnderLineButton.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UnderLineButton.h"
#import "SingleUnderLineLabel.h"

@interface UnderLineButton ()
{
    BOOL isTouch;
    UIColor *normalColor;
    UIColor *hightedColor;
    SingleUnderLineLabel *titleLabel;
}

-(void)setButtonHighted:(BOOL)isHighted;

@end
@implementation UnderLineButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        normalColor=[[UIColor blackColor]retain];
        hightedColor=[[UIColor blueColor]retain];
        titleLabel=[[SingleUnderLineLabel alloc]initWithFrame:CGRectZero];
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.font=[UIFont boldSystemFontOfSize:17.f];
        [self addSubview:titleLabel];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(void)dealloc{

    [normalColor release];
    [hightedColor release];
    [titleLabel release];
    [super dealloc];
}

-(void)setTitle:(NSString *)title{

    titleLabel.text=title;
    [titleLabel sizeToFit];
    titleLabel.frame=CGRectMake(self.frame.size.width/2-titleLabel.frame.size.width/2.f, self.frame.size.height/2-titleLabel.frame.size.height/2, titleLabel.frame.size.width, titleLabel.frame.size.height);
}

-(NSString *)title{

    return titleLabel.text;
}

-(void)sizeToFit{

    [super sizeToFit];
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, titleLabel.frame.size.width, titleLabel.frame.size.height);
    titleLabel.frame=self.bounds;
}

#pragma mark - View Touch  Method

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [super touchesBegan:touches withEvent:event];
    isTouch=YES;
    [self setButtonHighted:YES];
}


-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

    [super touchesCancelled:touches withEvent:event];
    isTouch=NO;
    [self setButtonHighted:NO];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    [super touchesEnded:touches withEvent:event];
    isTouch=NO;
    [self setButtonHighted:NO];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    [super touchesMoved:touches withEvent:event];
    if (!isTouch) {
        return;
    }
    CGPoint point=[[touches anyObject]locationInView:self];
    CGRect rect=CGRectMake(-20.f, -20.f, self.frame.size.width+40.f, self.frame.size.height+40.f);
    if (CGRectContainsPoint(rect, point)) {
        [self setButtonHighted:YES];
    }else
    {
        [self setButtonHighted:NO];
    }
}

#pragma mark -


-(void)setButtonHighted:(BOOL)isHighted{

    if (isHighted) {
        titleLabel.textColor=hightedColor;
    }else
    {
        titleLabel.textColor=normalColor;
    }
}
@end
