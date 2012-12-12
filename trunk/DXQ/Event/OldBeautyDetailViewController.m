//
//  OldBeautyDetailViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-27.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "OldBeautyDetailViewController.h"
#import "UserLoadChooseDetail.h"

@interface OldBeautyDetailViewController ()<BusessRequestDelegate>{

    UserLoadChooseDetail *detailRequest;
}

@end

@implementation OldBeautyDetailViewController


-(void)dealloc{

    [_beautyDic release];
    [super dealloc];
}

-(void)viewDidLoad{

    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"选美") backItemTitle:AppLocalizedString(@"返回")];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    if (self.visibleImageArray==nil) {
        [self requestDetail];
    }
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release];
        detailRequest=nil;
    }
}

-(void)requestDetail{

    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release];
        detailRequest=nil;
    }
 
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    NSString *accoundID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accoundID,@"AccountId",[_beautyDic objectForKey:@"Id"],@"ChooseId", nil];
    detailRequest=[[UserLoadChooseDetail alloc]initWithRequestWithDic:dic];
    detailRequest.delegate=self;
    [detailRequest startAsynchronous];
}
#pragma mark -

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    self.beautyDic=data;
    self.visibleImageArray=[data objectForKey:@"MemberList"];
    [[ProgressHUD sharedProgressHUD]done:YES];
}
@end
