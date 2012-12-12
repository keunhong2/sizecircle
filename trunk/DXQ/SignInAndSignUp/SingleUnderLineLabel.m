//
//  SingleUnderLineLabel.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "SingleUnderLineLabel.h"

@implementation SingleUnderLineLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0.f, self.frame.size.height-2.f);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height-2.f);
    CGContextSetStrokeColorWithColor(context, self.textColor.CGColor);
    CGContextStrokePath(context);
}
@end
