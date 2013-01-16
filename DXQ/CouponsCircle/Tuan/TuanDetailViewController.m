//
//  TuanDetailViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "TuanDetailViewController.h"

@interface TuanDetailViewController ()

@end

@implementation TuanDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"团购详情") backItemTitle:AppLocalizedString(@"返回")];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
