//
//  LikeListVC.m
//  DXQ
//
//  Created by 黄修勇 on 13-1-21.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "LikeListVC.h"

@interface LikeListVC ()

@end

@implementation LikeListVC

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
    [self setNavgationTitle:@"我的关注" backItemTitle:@"返回"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
//    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)startRefreshFriends
{
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
    [parametersDic setObject:@"1" forKey:@"FriendType"];
    [parametersDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"PageIndex",@"200",@"ReturnCount", nil] forKey:@"Pager"];
    [parametersDic setObject:accountID forKey:@"AccountId"];
    isUserLoadFriendListRequesting = YES;
    userLoadFriendListRequest = [[UserLoadFriendListRequest alloc]initWithRequestWithDic:parametersDic ];
    userLoadFriendListRequest.delegate = self;
    [userLoadFriendListRequest startAsynchronous];
}

@end
