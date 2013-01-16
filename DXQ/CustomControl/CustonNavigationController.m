//
//  CustonNavigationController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "CustonNavigationController.h"
#import "CustomNavigationBar.h"

@interface CustonNavigationController ()

@end

@implementation CustonNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CustomNavigationBar *navigatioBar=[[CustomNavigationBar alloc]init];
        [self setValue:navigatioBar forKey:@"navigationBar"];
        [navigatioBar release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
//    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
