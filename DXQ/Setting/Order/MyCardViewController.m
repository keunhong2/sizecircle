//
//  MyCardViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-1.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "MyCardViewController.h"
#import "UserProductViewController.h"

@interface MyCardViewController ()

@end

@implementation MyCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"我的会员卡") backItemTitle:AppLocalizedString(@"返回")];
}

#pragma mark -

-(void)setSegment:(UserProductSegmentControl *)segment{
    
    [super setSegment:segment];
    for (UIButton *btn in segment.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag==1) {
                NSString *notUserTitle=[NSString stringWithFormat:AppLocalizedString(@"有效的Product"),AppLocalizedString(@"会员卡")];
                [btn setTitle:notUserTitle forState:UIControlStateNormal];
            }else if (btn.tag==2)
            {
                NSString *userTitle=[NSString stringWithFormat:AppLocalizedString(@"已过期的Product"),AppLocalizedString(@"会员卡")];
                [btn setTitle:userTitle forState:UIControlStateNormal];
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
                       @"H",@"ProductType",
                       @"1",@"IsPayed",
                       isUse,@"IsUsed", nil];
    return dic;
}

@end
