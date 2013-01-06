//
//  MyAttentionViewController.m
//  DXQ
//
//  Created by 黄修勇 on 13-1-5.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "MyAttentionViewController.h"
#import "UserProductViewController.h"

@interface MyAttentionViewController ()

@end

@implementation MyAttentionViewController

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
    
    [self setNavgationTitle:@"我的关注" backItemTitle:@"设置"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSegment:(UserProductSegmentControl *)segment{
    
    [super setSegment:segment];
    for (UIButton *btn in segment.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag==1) {
                [btn setTitle:@"关注的产品" forState:UIControlStateNormal];
            }else if (btn.tag==2)
            {
                [btn setTitle:@"关注的用户" forState:UIControlStateNormal];
            }
        }
    }
}

-(NSDictionary *)requestArgsDicByPage:(NSInteger)page{
    
    NSDictionary *pager=[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%d",page],@"PageIndex",
                         [NSString stringWithFormat:@"%d",20],@"ReturnCount", nil];
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSString *isUse=[self isSelectUntreatedType]==YES?@"0":@"1";
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       pager,@"Pager",
                       accountID,@"AccountId",
                       @"Y",@"ProductType",
                       @"1",@"IsPayed",
                       isUse,@"IsUsed", nil];
    return dic;
}

@end
