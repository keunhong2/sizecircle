//
//  UIFont+Height.m
//  DXQ
//
//  Created by Yuan on 12-10-20.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UIFont+Height.h"

@implementation UIFont(stringHeight)

+(CGSize)sizeofText:(NSString *)text font:(UIFont*)font width:(CGFloat)width
{
    return [text sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
}

@end
