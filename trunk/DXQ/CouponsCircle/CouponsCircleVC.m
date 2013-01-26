//
//  CouponsCircleVC.m
//  DXQ
//
//  Created by Yuan on 12-10-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "CouponsCircleVC.h"
#import "BusinessListCell.h"
#import "CouponsTrendsViewController.h"
#import "PPRevealSideViewController.h"
#import "ScreenViewController.h"
#import "NearBusessRequest.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "UIImageView+WebCache.h"
#import "FriendAnnotation.h"
#import "FriendAnnotationView.h"
#import "UserLoadNearShopListForMap.h"
#import "LoadMoreView.h"

@interface CouponsCircleVC ()<BusessRequestDelegate,MKMapViewDelegate>
{
    NearBusessRequest *nearBusForTableViewRequest;
    UserLoadNearShopListForMap *mapRequest;
    BussessScreenObject *screenObj;//用来纪录筛选的东西
    BOOL isFirstRequest;
    BOOL isGetAllCoupons;
    BOOL isRefrush;
    BOOL isFirstGetLocatin;
    LoadMoreView *loadMoreView;
    UIView *mapTitleView;
    UILabel *mapTitleLabel;
    UIActivityIndicatorView *activity;
}
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)MKMapView *mapView;
@property (nonatomic,retain)NSArray *annArray;

@end

@implementation CouponsCircleVC
@synthesize couponsList=_couponsList;

-(void)dealloc{

    [self cancelAllRequest];
    [_couponsList release];
    [_couponsOnMapList release];
    [_tableView release];_tableView=nil;
    [_mapView release];_mapView=nil;
    [_annArray release];
    [loadMoreView release];
    [mapTitleLabel release];
    [mapTitleView release];
    [activity release];
    [super dealloc];
}

-(void)viewDidUnload{
    
    [_tableView release];_tableView=nil;
    [_mapView release];
    _mapView=nil;
    
    [loadMoreView release];
    loadMoreView=nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
//    // [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        screenObj=[[BussessScreenObject alloc]init];
        isFirstRequest=YES;
        isGetAllCoupons=NO;
        isFirstGetLocatin=YES;
    }
    return self;
}


-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];

    UITableView *tableView=[[UITableView alloc]initWithFrame:view_.bounds style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.dataSource=self;
    tableView.delegate=self;
    [tableView setSeparatorColor:TABLEVIEW_SEPARATORCOLOR];
    tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [tableView setPullToRefreshHandler:^{
        [self refreshStart];
    }];
    
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    
    //custom segment
    NSDictionary *item1 = [NSDictionary dictionaryWithObjectsAndKeys:@"列表",@"title",@"pyq_l",@"img", nil];
    NSDictionary *item2 = [NSDictionary dictionaryWithObjectsAndKeys:@"地图",@"title",@"pyq_r",@"img", nil];
    NSArray *items = [NSArray arrayWithObjects:item1,item2, nil];
    CustomSegmentedControl *segment = [[CustomSegmentedControl alloc]initWithFrame:CGRectZero items:items defaultSelectIndex:0];
    segment.delegate = self;
    self.navigationItem.titleView=segment;
    [segment release];
    
    _isListModel=YES;
   
    loadMoreView=[[LoadMoreView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 60.f)];
    [loadMoreView setLoadMoreBlock:^{
        [self loadMore];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_isListModel)
    {
        [self.view insertSubview:[self tableView] atIndex:0];
        
        UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
        UIButton *screenBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [screenBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [screenBtn sizeToFit];
        [screenBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
        [screenBtn setTitle:AppLocalizedString(@"筛选") forState:UIControlStateNormal];
        [screenBtn addTarget:self action:@selector(screenBtnDone) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:screenBtn];
        self.navigationItem.rightBarButtonItem=item;
        [item release];
        
    }else
        [self.view insertSubview:[self mapView] atIndex:0];
    
   
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (isFirstRequest) {
        [_tableView pullToRefresh];
        isFirstRequest=NO;
    }
}

-(void)screenBtnDone
{
    ScreenViewController *screen=[[ScreenViewController alloc]initWithScreenType:ScreenTypeWithName];
    screen.screenDelegate=self;
    CustonNavigationController *navigation=[[CustonNavigationController alloc]initWithRootViewController:screen];
    screen.name=[screenObj.name isEqualToString:@"-1"]?@"":screenObj.name;
    screen.selectClassName=screenObj.classify;
    screen.selectLocationName=screenObj.area;
    [self.navigationController presentModalViewController:navigation animated:YES];
    [screen release];
    [navigation release];
}

-(void)setAnnArray:(NSArray *)annArray{

    if ([annArray isEqualToArray:_annArray]) {
        return;
    }
    if (_annArray) {
        [_mapView removeAnnotations:_annArray];
    }
    [_annArray release];
    _annArray=[annArray retain];
    [_mapView addAnnotations:annArray];
}
#pragma mark -RequestMethod

-(void)cancelAllRequest{

    [[ProgressHUD sharedProgressHUD]hide];
    
    [nearBusForTableViewRequest cancel];
    [nearBusForTableViewRequest release];
    nearBusForTableViewRequest=nil;
    
    if (mapRequest) {
        [mapRequest cancel];
        [mapRequest release];
        mapRequest=nil;
    }
}

-(void)refreshStart{

    screenObj.page=1;
    [self requestCouponsForTable];
}

-(void)loadMore{

    screenObj.page+=1;
    [self requestCouponsForTable];
}

-(void)requestCouponsForTable{

    [nearBusForTableViewRequest cancel];
    [nearBusForTableViewRequest release];
    nearBusForTableViewRequest=nil;
    if (screenObj.page==1) {
        isRefrush=YES;
    }else
        isRefrush=NO;
    NSDictionary *dic=[screenObj dictionaryIsForMap:NO];
    nearBusForTableViewRequest=[[NearBusessRequest alloc]initWithRequestWithDic:dic];
    nearBusForTableViewRequest.delegate=self;
    loadMoreView.state=LoadMoreStateRequesting;
    [nearBusForTableViewRequest startAsynchronous];
}

-(void)requestForMap{

    if (mapRequest) {
        [mapRequest cancel];
        [mapRequest release];
        mapRequest=nil;
    }
    HYLog(@"map la %f long %f",_mapView.userLocation.coordinate.latitude,_mapView.userLocation.coordinate.longitude);
    CLLocationCoordinate2D minCoor=[_mapView convertPoint:CGPointMake(0.f, 0.f) toCoordinateFromView:_mapView];
    CLLocationCoordinate2D maxCoor=[_mapView convertPoint:CGPointMake(_mapView.frame.size.width, _mapView.frame.size.height) toCoordinateFromView:_mapView];
    
    HYLog(@"左上角 la %f lon%f",minCoor.latitude,minCoor.longitude);
    HYLog(@"右下角 la %f lon%f",maxCoor.latitude,maxCoor.longitude);
    screenObj.minCoordinate=minCoor;
    screenObj.maxCoordinate=maxCoor;
    self.isRequestForMap=YES;
    NSDictionary *dic=[screenObj dictionaryIsForMap:YES];
    mapRequest=[[UserLoadNearShopListForMap alloc]initWithRequestWithDic:dic];
    mapRequest.delegate=self;
    [mapRequest startAsynchronous];
}
#pragma mark -ScreenViewControllerDelegate method

-(void)screenViewController:(BaseScreenViewController *)screenViewController didDoneScreenWithInfo:(NSDictionary *)screenInfo{

    screenObj.name=[screenInfo objectForKey:@"Name"];
    screenObj.classify=[screenInfo objectForKey:@"Classify"];
    screenObj.area=[screenInfo objectForKey:@"Area"];
    screenObj.page=1;
    [screenViewController dismissModalViewControllerAnimated:YES];
    
    if (_isListModel) {
        [self.tableView performSelector:@selector(pullToRefresh) withObject:nil afterDelay:0.3f];
    }else
        [self requestForMap];
}

-(void)didCancelScrennViewController:(BaseScreenViewController *)screenViewController{

    [screenViewController dismissModalViewControllerAnimated:YES];
}
#pragma mark
#pragma CustomSegmentedControl Methord
-(void)didSelectIndex:(NSUInteger)selectedIndex withSegmentControl:(CustomSegmentedControl*)segmentControl;
{
    self.isListModel=selectedIndex==0?YES:NO;
    HYLog(@"%d",selectedIndex);
}


// get method

-(MKMapView *)mapView
{
    if (!_mapView)
    {
        _mapView=[[MKMapView alloc]initWithFrame:self.view.bounds];
        _mapView.delegate=self;
        _mapView.showsUserLocation=YES;
        mapTitleView=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, _mapView.frame.size.width, 30.f)];
        mapTitleView.backgroundColor=[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.4];
        mapTitleView.autoresizingMask=UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
        mapTitleLabel=[[UILabel alloc]initWithFrame:mapTitleView.bounds];
        mapTitleLabel.backgroundColor=[UIColor clearColor];
        mapTitleLabel.textAlignment=UITextAlignmentCenter;
        mapTitleLabel.textColor=[UIColor whiteColor];
        mapTitleLabel.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [mapTitleLabel setText:AppLocalizedString(@"")];
        mapTitleLabel.font=[UIFont boldSystemFontOfSize:15.f];
        [mapTitleView addSubview:mapTitleLabel];
        [_mapView addSubview:mapTitleView];
        activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activity.frame=CGRectMake(20.f, 30.f/2-activity.frame.size.height/2, activity.frame.size.width, activity.frame.size.height);
        [mapTitleView addSubview:activity];
        activity.hidesWhenStopped=YES;
        [activity stopAnimating];
    }
    
    return _mapView;
}

//set

-(void)setIsRequestForMap:(BOOL)isRequestForMap{

    if (isRequestForMap==_isRequestForMap) {
        return;
    }
    _isRequestForMap=isRequestForMap;
    if (isRequestForMap) {
        [activity startAnimating];
    }else
        [activity stopAnimating];
}

-(void)setIsListModel:(BOOL)isListModel{

    if (isListModel==_isListModel)
    {
        return;
    }
    _isListModel=isListModel;
    
    [self cancelAllRequest];
    
    if (isListModel)
    {
        
        UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
        UIButton *screenBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [screenBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [screenBtn sizeToFit];
        [screenBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
        [screenBtn setTitle:AppLocalizedString(@"筛选") forState:UIControlStateNormal];
        [screenBtn addTarget:self action:@selector(screenBtnDone) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:screenBtn];
        self.navigationItem.rightBarButtonItem=item;
        [item release];
        
        [self.mapView removeFromSuperview];
        [self.view insertSubview:[self tableView] atIndex:0];
    }
    else
    {
    
        self.navigationItem.rightBarButtonItem=nil;
        
        [self.tableView removeFromSuperview];
        [self.view insertSubview:[self mapView] atIndex:0];
    }
}


#pragma mark -UITableViewDataSourceAndDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _couponsList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *indentifier=@"coupons";
    BusinessListCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell)
    {
        cell=[[[BusinessListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *dic=[_couponsList objectAtIndex:indexPath.row];
    //only for test
    NSString *url=[dic objectForKey:@"PhotoUrl"];
    NSString *encodeUrl=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.businessImageView setImageWithURL:[NSURL URLWithString:encodeUrl]placeholderImage:[UIImage imageNamed:@"image_demo"] options:SDWebImageProgressiveDownload success:^(UIImage *img,BOOL isCache){
        [Tool setImageView:cell.businessImageView toImage:img];
    } failure:^(NSError *error){
    
    }];
    cell.businessNameLbl.text=[dic objectForKey:@"AccountName"];
    cell.businessLastestInfoLbl.text=[Tool checkData:[dic objectForKey:@"News"]];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude=[[dic objectForKey:@"WeiDu"] floatValue];
    coordinate.longitude=[[dic objectForKey:@"JingDu"] floatValue];
    float distance=[Tool getDistanceFromPoint:screenObj.coordinate toPoint:coordinate];
    if (distance<=300.f) {
        cell.distanceLbl.text=AppLocalizedString(@"小于300米");
    }else
        cell.distanceLbl.text=[NSString stringWithFormat:@"%.02fkm",distance/1000.f];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponsTrendsViewController *trends=[[CouponsTrendsViewController alloc]initWithShopSimpleDic:[_couponsList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:trends animated:YES];
    [trends release];
}

#pragma mark -BusessReqeustDelegate

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{
    
    [_tableView refreshFinished];
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    self.isRequestForMap=NO;
    if (request==nearBusForTableViewRequest) {
        if (isRefrush==NO) {
            screenObj.page--;
        }else
            screenObj.page=screenObj.lastPage;
    }
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    [_tableView refreshFinished];

    if (request==nearBusForTableViewRequest) {
        if (screenObj.page==1) {
            self.couponsList=data;
        }else
        {
            NSMutableArray *tempArray=[NSMutableArray arrayWithArray:_couponsList];
            [tempArray addObjectsFromArray:data];
            self.couponsList=tempArray;
        }
        if ([data count]==screenObj.count) {
            
            self.tableView.tableFooterView=loadMoreView;
        }else
            self.tableView.tableFooterView=nil;
       
        [self.tableView reloadData];
        loadMoreView.state=LoadMoreStateNormal;
    }else if ([request isEqual:mapRequest]){
    
        self.isRequestForMap=NO;
        NSMutableArray *tempAnno=[NSMutableArray new];
        for (NSDictionary *dic in data) {
            FriendAnnotation *ann=[[FriendAnnotation alloc]init];
            ann.dic=dic;
            [tempAnno addObject:ann];
            [ann release];
        }
        self.annArray=tempAnno;
        loadMoreView.state=LoadMoreStateNormal;
    }
}

#pragma mark -MapViewDelegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (isFirstGetLocatin) {
        [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
        isFirstGetLocatin=NO;
    }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{

    [self requestForMap];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    if ([annotation isKindOfClass:[FriendAnnotation class]]) {
        static NSString *friendIdentifier=@"Friend";
        FriendAnnotationView *view=(FriendAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:friendIdentifier];
        if (!view) {
            view=[[[FriendAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:friendIdentifier] autorelease];
        }
        view.headerImageView.image=nil;
        NSString *url=[[(FriendAnnotation *)annotation dic]objectForKey:@"PhotoUrl"];
        NSString *encodeUrl=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [view.headerImageView setImageWithURL:[NSURL URLWithString:encodeUrl] placeholderImage:nil];
        view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, view.headerImageView.frame.size.width,view.headerImageView.frame.size.height);
        return view;
    }else
        return nil;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[FriendAnnotation class]]) {
        CouponsTrendsViewController *trends=[[CouponsTrendsViewController alloc]initWithShopSimpleDic:[(FriendAnnotation*)(view.annotation) dic]];
        [self.navigationController pushViewController:trends animated:YES];
        [trends release];
    }
}


@end
@implementation BussessScreenObject

-(void)dealloc{

    [_accountID release];
    [_name release];
    [_area release];
    [_classify release];
    [super dealloc];
}
 
-(id)init{

    self=[super init];
    if (self) {
        self.accountID=[[SettingManager sharedSettingManager]loggedInAccount];
        self.area=@"-1";
        self.classify=@"-1";
        self.name=@"-1";
        _lastPage=1;
        _page=1;
        _count=20;
        _coordinate.latitude=80;
        _coordinate.longitude=100;
    }
    return self;
}

-(NSDictionary *)dictionaryIsForMap:(BOOL)isMap{
    
    NSDictionary *pager=nil;
    if (isMap) {
        pager=[NSDictionary dictionaryWithObjectsAndKeys:
               [NSString stringWithFormat:@"%d",1],@"PageIndex",
               [NSString stringWithFormat:@"%d",999],@"ReturnCount", nil];
    }else
        pager=[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%d",_page],@"PageIndex",
                         [NSString stringWithFormat:@"%d",_count],@"ReturnCount", nil];

    if (!_accountID) {
        self.accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    }
    
    NSMutableDictionary *tempDic=[NSMutableDictionary dictionary];
    [tempDic addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                       _accountID,@"AccountId",_name,@"Name",
                                       _area,@"Area",_classify,@"Classify",pager,@"Pager",nil]];
    
    if (isMap) {
        //for test
//        [tempDic setObject:@"20" forKey:@"Min_WeiDu"];
//        [tempDic setObject:@"110" forKey:@"Min_JingDu"];
//        [tempDic setObject:@"40" forKey:@"Max_WeiDu"];
//        [tempDic setObject:@"120" forKey:@"Max_JingDu"];

        [tempDic setObject:[NSString stringWithFormat:@"%f",_minCoordinate.latitude] forKey:@"Max_WeiDu"];
        [tempDic setObject:[NSString stringWithFormat:@"%f",_minCoordinate.longitude] forKey:@"Min_JingDu"];
        [tempDic setObject:[NSString stringWithFormat:@"%f",_maxCoordinate.latitude] forKey:@"Min_WeiDu"];
        [tempDic setObject:[NSString stringWithFormat:@"%f",_maxCoordinate.longitude] forKey:@"Max_JingDu"];
    }else
    {
        [tempDic setObject:[[GPS gpsManager]getLocation:GPSLocationLatitude] forKey:@"WeiDu"];
        [tempDic setObject:[[GPS gpsManager]getLocation:GPSLocationLongitude] forKey:@"JingDu"];
    }
    
    return tempDic;
}

-(void)setPage:(NSInteger)page{

    if (page==_page) {
        return;
    }
    _lastPage=page;
    _page=page;
}
@end