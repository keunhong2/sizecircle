//
//  YKNavigationBar.m
//  YouKo
//
//  Created by he yuan on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

-(id)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if (self) {
//        self.tintColor=[UIColor redColor];
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=5.0f) {
            UIImage *navigationBgImg=[UIImage imageNamed:@"nav_bg"];
            [self setBackgroundImage:navigationBgImg forBarMetrics:UIBarMetricsDefault];
        }
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
//    NSString *sourcePath = [SettingManager getImagePath:@"header_bg"];
    
    UIImage *navigationBgImg =[UIImage imageNamed:@"nav_bg"];;
    
    [navigationBgImg drawInRect:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height)];
}

@end



