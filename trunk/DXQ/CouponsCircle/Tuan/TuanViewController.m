//
//  TuanViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "TuanViewController.h"
#import "TuanDetailViewController.h"

@interface TuanViewController ()

@end

@implementation TuanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=AppLocalizedString(@"团购");
    }
    return self;
}

-(ProductType)type{

    return ProductTypeTuan;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//

-(void)memberView:(UIView *)view tapForIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger tempLocation=indexPath.row*2;
    NSInteger tempLength=2;
    if (tempLocation+2>self.productArray.count) {
        tempLength=1;
    }
    NSArray *array=[self.productArray subarrayWithRange:NSMakeRange(tempLocation, tempLength)];
    NSDictionary *dic=[array objectAtIndex:view.tag-1];
    
    TuanDetailViewController *tuan=[[TuanDetailViewController alloc]init];
    tuan.simpleInfoDic=dic;
    [self.navigationController pushViewController:tuan animated:YES];
    [tuan release];
}
@end
