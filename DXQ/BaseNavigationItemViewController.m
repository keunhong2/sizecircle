//
//  BaseNavigationItemViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"
#import "PPRevealSideViewController.h"

@interface BaseNavigationItemViewController ()

@end

@implementation BaseNavigationItemViewController

+(UIBarButtonItem *)defaultItemWithTitle:(NSString *)title target:(id)target action:(SEL)action{

    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img=[UIImage imageNamed:@"btn_back_default"];
    [btn setBackgroundImage:img forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.f]];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 5.f, 0.f, 0.f)];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    return [item autorelease];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIImage *tempItemImage=[UIImage imageNamed:@"nav_menu_icon"];
    UIImage *itemImage=[UIImage imageWithCGImage:tempItemImage.CGImage scale:2. orientation:UIImageOrientationUp];
    UIButton *leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [leftBtn setImage:itemImage forState:UIControlStateNormal];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    [leftBtn sizeToFit];
    [leftBtn addTarget:self action:@selector(showleft) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=leftItem;
    [leftItem release];
    
    /*
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [rightBtn setImage:itemImage forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(showRighte) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn sizeToFit];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    [rightItem release];
     */
}

@end
