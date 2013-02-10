//
//  MemberDetailViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductDetailRequest.h"
#import "AdmireRequest.h"
#import "RelationMakeRequest.h"

@interface MemberDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,BusessRequestDelegate>{

    ProductDetailRequest *detailRequest;
    AdmireRequest *admireRequest;
    RelationMakeRequest *relationRequest;
}

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)UIView *memberInfoView;
@property (nonatomic,retain)UIView *detailView;
@property (nonatomic,retain)UIView *businessInfoView;

@property (nonatomic,retain)NSDictionary *infoDic;

@property (nonatomic,retain)NSDictionary *simpleInfoDic;
@property (nonatomic,getter = isCanBuy)BOOL canBuy;//Defaule YES;

-(void)cancelAllRequest;

-(void)imageTap;

-(void)showFullImageByUrl:(NSString *)picurl;
@end
