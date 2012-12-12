//
//  UserMemberViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseNavigationItemViewController.h"
#import "ProductListRequest.h"
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSInteger, ProductType)
{
    ProductTypeTicket,//优惠券
    ProductTypeTuan,//团购
    ProductTypeMemberCard,//会员卡
    ProductTypeEvent,//活动
};

@class ProductScreenObj;


@interface UserMemberViewController : BaseNavigationItemViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,BusessRequestDelegate>{

    @protected
    ProductScreenObj *screenObj;
    ProductListRequest *productRequest;
    BOOL isRefresh;
    BOOL isFirstRefresh;
}

@property (nonatomic,retain)UISearchBar *searchBar;
@property (nonatomic,retain)UITableView *tableView;


@property (nonatomic,readonly)ProductType type;//
@property (nonatomic,retain)NSArray *productArray;
@property (nonatomic,retain)NSArray *visibleArray;

-(void)screenByText:(NSString *)text;

-(void)myProductBtnDone:(UIButton *)btn;

-(void)cancelAllRequest;

-(void)memberView:(UIView *)view tapForIndexPath:(NSIndexPath *)indexPath;

-(void)goProductManageViewController;

@end


@interface ProductScreenObj : NSObject

-(id)initWithProductType:(ProductType)type;

@property (nonatomic,readonly)ProductType type;
@property (nonatomic,retain)NSString *area;//default -1 不限
@property (nonatomic,retain)NSString *classify;//default -1 不限
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic)OrderType orderType;//default release date
@property (nonatomic)BOOL isAscendingOrder;//default YES
@property (nonatomic)NSInteger page;//default 1
@property (nonatomic)NSInteger count;//default 20
@property (nonatomic)BOOL isValid;
@property (nonatomic)NSInteger lastPage;

-(NSDictionary *)screenDic;

@end
