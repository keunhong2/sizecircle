//
//  InputProfesionVC.m
//  DXQ
//
//  Created by Yuan on 12-11-20.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "InputProfesionVC.h"

@interface InputProfesionVC ()

@end

@implementation InputProfesionVC

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
    [self setNavgationTitle:AppLocalizedString(@"职位信息") backItemTitle:AppLocalizedString(@"返回")];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
