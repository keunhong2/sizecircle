//
//  AllOrderViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-1.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "AllOrderViewController.h"
#import "UserProductViewController.h"

@interface AllOrderViewController ()

@end

@implementation AllOrderViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"我的订单") backItemTitle:AppLocalizedString(@"返回")];
}

#pragma mark -

-(void)setSegment:(UserProductSegmentControl *)segment{

    [super setSegment:segment];
    for (UIButton *btn in segment.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag==1) {
                [btn setTitle:AppLocalizedString(@"未处理订单") forState:UIControlStateNormal];
            }else if (btn.tag==2)
            {
                [btn setTitle:AppLocalizedString(@"已处理订单") forState:UIControlStateNormal];
            }
        }
    }
}

-(NSDictionary *)requestArgsDicByPage:(NSInteger)page{

    NSDictionary *pager=[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%d",page],@"PageIndex",
                         [NSString stringWithFormat:@"%d",20],@"ReturnCount", nil];
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSString *isUsed=[self isSelectUntreatedType]==YES?@"0":@"1";
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       pager,@"Pager",
                       accountID,@"AccountId",
                       @"-1",@"ProductType",
                       @"1",@"IsPayed",
                       isUsed,@"IsUsed", nil];
    return dic;
}

@end
