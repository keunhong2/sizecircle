//
//  UserProductViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-14.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"
#import "UserMemberViewController.h"
#import "GetLoadUserProductRequest.h"
#import "CouponsBottomBar.h"

@interface UserProductViewController : BaseNavigationItemViewController<BusessRequestDelegate,UITableViewDataSource,UITableViewDelegate>{

    GetLoadUserProductRequest *userProductRequest;
}

@property (nonatomic,readonly)ProductType type;
@property (nonatomic,retain)NSArray *isUseArray;
@property (nonatomic,retain)NSArray *notUserArray;
@property (nonatomic,assign)NSArray *visibleArray;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic)BOOL isUsed;

-(id)initWithType:(ProductType)type;

-(void)cancelAllRequest;

@end


@interface UserProductSegmentControl : CouponsBottomBar

-(id)initWithType:(ProductType)type;

@end