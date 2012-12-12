//
//  TicketViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "TicketViewController.h"
#import "TicketDetailViewController.h"

@interface TicketViewController ()

@end

@implementation TicketViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=AppLocalizedString(@"优惠券");
        
    }
    return self;
}

-(ProductType)type{

    return ProductTypeTicket;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -

-(void)memberView:(UIView *)view tapForIndexPath:(NSIndexPath *)indexPath{

    NSInteger tempLocation=indexPath.row*2;
    NSInteger tempLength=2;
    if (tempLocation+2>self.productArray.count) {
        tempLength=1;
    }
    NSArray *array=[self.productArray subarrayWithRange:NSMakeRange(tempLocation, tempLength)];
    NSDictionary *dic=[array objectAtIndex:view.tag-1];
    
    TicketDetailViewController *ticket=[[TicketDetailViewController alloc]init];
    ticket.simpleInfoDic=dic;
    [self.navigationController pushViewController:ticket animated:YES];
    [ticket release];
}
@end
