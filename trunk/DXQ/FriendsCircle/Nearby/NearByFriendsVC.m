//
//  NearByFriendsVC.m
//  DXQ
//
//  Created by Yuan on 12-10-16.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "NearByFriendsVC.h"
#import "NearByListCell.h"
#import "ThumbImageCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "FriendFilterVC.h"
#import "UserDetailInfoVC.h"
#import "NearByUserListRequest.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "GPS.h"

#define ROWNUMBERS 4

@interface NearByFriendsVC ()<NearByUserListRequestDelegate>
{
    
    NearByUserListRequest *nearByUserListRequest;
    
    BOOL isNearByUserListRequesting;
    
    NSInteger currentPage;
}

@property (nonatomic,retain)NSMutableArray *friendsList;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)MKMapView *mapView;
@property (nonatomic)SegmentType showType;
@end

@implementation NearByFriendsVC
@synthesize friendsList = _friendsList;
@synthesize tableView=_tableView;
@synthesize mapView=_mapView;
@synthesize showType = _showType;

-(void)dealloc
{
    [_friendsList release];_friendsList = nil;
    [_mapView release];_mapView = nil;
    [_tableView release];_tableView = nil;
    [super dealloc];
}

-(void)viewDidUnload
{
    self.tableView = nil;
    self.mapView = nil;
    [super viewDidUnload];
}

-(id)init
{
    if (self = [super init])
    {
        _showType=SegmentTypeList;
        
        _friendsList = [[NSMutableArray alloc]init];
        
        currentPage = 1;
    }
    return  self;
}

-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];

    //custom segment
    NSDictionary *item1 = [NSDictionary dictionaryWithObjectsAndKeys:@"列表",@"title",@"pyq_l",@"img", nil];
    NSDictionary *item2 = [NSDictionary dictionaryWithObjectsAndKeys:@"宫格",@"title",@"pyq_m",@"img", nil];
    NSDictionary *item3 = [NSDictionary dictionaryWithObjectsAndKeys:@"地图",@"title",@"pyq_r",@"img", nil];
    NSArray *items = [NSArray arrayWithObjects:item1,item2,item3, nil];
    CustomSegmentedControl *segment = [[CustomSegmentedControl alloc]initWithFrame:CGRectZero items:items defaultSelectIndex:0];
    segment.delegate = self;
    self.navigationItem.titleView=segment;
    [segment release];
    
    [self.view insertSubview:[self tableView] atIndex:0];
}

-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView setSeparatorColor:TABLEVIEW_SEPARATORCOLOR];
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [_tableView setPullToRefreshHandler:^{
            [self refreshStart];
        }];
        
//        [_tableView setPullToLoadMoreHandler:^{
//            [self loadMore];
//        }];

        [_tableView setPullToLoadMoreViewPullingText:@"继续上拉加载更多"];

//        UIView *footer = [[UIView alloc]initWithFrame:CGRectZero];
//        _tableView.tableFooterView = footer;
//        [footer release];
        _tableView.delegate=self;
        _tableView.dataSource=self;
    }
    return _tableView;
}

-(void)loadMore
{
    [self refreshStart];
}

-(MKMapView *)mapView
{
    if (!_mapView)
    {
        _mapView=[[MKMapView alloc]initWithFrame:self.view.bounds];
        _mapView.delegate=self;
        _mapView.mapType = MKMapTypeStandard;
        _mapView.showsUserLocation=YES;
    }
    
    return _mapView;
}

- (void)viewDidLoad
{
    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    [rightBtn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:AppLocalizedString(@"筛选") forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:MiddleBoldDefaultFont];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    [rightItem release];
    
    if (![[GPS gpsManager]islocationServicesEnabled])
    {
        //未打开定位
    }
    [_tableView pullToRefresh];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void)refreshStart
{
    currentPage = 1;
    [_friendsList removeAllObjects];
    [_tableView reloadData];
    [self nearByUserListRequest];
}

-(void)nearByUserListRequest
{
    if (isNearByUserListRequesting)return;
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
    NSString *lat =   [[GPS gpsManager]getLocation:GPSLocationLatitude];
    NSString *lon =   [[GPS gpsManager]getLocation:GPSLocationLongitude];    
    [parametersDic setObject:lon forKey:@"JingDu"];
    [parametersDic setObject:lat forKey:@"WeiDu"];
    [parametersDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",currentPage],@"PageIndex",@"20",@"ReturnCount", nil] forKey:@"Pager"];
    
    NSDictionary *config = [[SettingManager sharedSettingManager]getNearByFriendsListFilterConfig];
    NSNumber *sex = [NSNumber numberWithInt:-1];
    NSNumber *time = [NSNumber numberWithInt:900];
    if (config && [config isKindOfClass:[NSDictionary class]])
    {
        if ([config objectForKey:@"sex"])sex = [config objectForKey:@"sex"];
        if ([config objectForKey:@"time"])time = [config objectForKey:@"time"];
    }
    [parametersDic setObject:[sex stringValue] forKey:@"Sex"];
    [parametersDic setObject:[time stringValue] forKey:@"LogInDate"];
    [parametersDic setObject:[[SettingManager sharedSettingManager]loggedInAccount] forKey:@"AccountId"];
    currentPage++;
    isNearByUserListRequesting = YES;
    nearByUserListRequest = [[NearByUserListRequest alloc] initRequestWithDic:parametersDic];
    nearByUserListRequest.delegate = self;
    [nearByUserListRequest startAsynchronous];
}

-(void)finishedNearByUserListRequestSuccessed:(BOOL)isSuccessed withMessage:(NSString *)msg
{
    if (!isSuccessed)
    {
        [[ProgressHUD sharedProgressHUD]setText:msg];
        [[ProgressHUD sharedProgressHUD]showInView:self.view];
        [[ProgressHUD sharedProgressHUD]done:NO];
    }
    isNearByUserListRequesting = NO;
    nearByUserListRequest.delegate = nil,
    [nearByUserListRequest release];
    nearByUserListRequest = nil;
    [_tableView refreshFinished];
    [_tableView loadMoreFinished];
}


-(void)nearByUserListRequestDidFinishedWithParamters:(NSArray *)result
{
    if (result && [result count]>0)
    {
        [_friendsList addObjectsFromArray:result];
        [self.tableView reloadData];
    }
    [self finishedNearByUserListRequestSuccessed:YES withMessage:nil];
}

-(void)nearByUserListRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    [self finishedNearByUserListRequestSuccessed:NO withMessage:errorMsg];
}

#pragma mark
#pragma UniversalViewControlDelegate Methord
-(void)didCancelViewViewController
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

-(void)didFinishedAction:(UIViewController *)viewController
{
    HYLog(@"finsihed");
    [_tableView pullToRefresh];
    [self didCancelViewViewController];
}


-(void)filterAction:(UIButton*)sender
{
    FriendFilterVC *vc = [[FriendFilterVC alloc]initWithDelegate:self];
    CustonNavigationController *nav = [[CustonNavigationController alloc]initWithRootViewController:vc];
    [self.navigationController presentModalViewController:nav animated:YES];
    [vc release];
    [nav release];
}

-(void)setCurrentSegmentType:(SegmentType)type_
{
    if (self.showType == type_) return;
    
    [self.view.superview setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];    
	[UIView commitAnimations];
    
    if (type_ == SegmentTypeMap)
    {
        _showType=type_;
        [self.tableView removeFromSuperview];
        [self.view insertSubview:[self mapView] atIndex:0];
    }
    else
    {
        if (_showType == SegmentTypeMap)
        {
            _showType=type_;
            [self.mapView removeFromSuperview];
            [self.view insertSubview:[self tableView] atIndex:0];
        }
        else _showType=type_;
        [_tableView reloadData];
    }
}

#pragma mark
#pragma CustomSegmentedControl Methord
-(void)didSelectIndex:(NSUInteger)selectedIndex withSegmentControl:(CustomSegmentedControl*)segmentControl;
{
    [self setCurrentSegmentType:selectedIndex];    
}

-(void)imageViewTapIndex:(NSIndexPath *)indexPath imageView:(UIImageView *)imageView
{
    NSInteger idx = indexPath.row*ROWNUMBERS+imageView.tag-1;
    if (idx>=[_friendsList count])return;
    NSDictionary *item = [_friendsList objectAtIndex:idx];
    UserDetailInfoVC *vc=[[UserDetailInfoVC alloc]initwithUserInfo:item];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark -UITableViewDataSourceAndDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showType == SegmentTypeGrid) return 83.f;
    return 72.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_showType == SegmentTypeGrid)
    {
        return  ceil((float)[_friendsList count]/ROWNUMBERS);

    }
    return [_friendsList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_showType == SegmentTypeGrid)
    {
        return [self GridCellForIndexPath:indexPath];
    }
    else if(_showType == SegmentTypeList)
    {
        return [self ListCellForIndexPath:indexPath];
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserDetailInfoVC *vc=[[UserDetailInfoVC alloc]initwithUserInfo:[_friendsList objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(UITableViewCell *)ListCellForIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *cellIdentifier=@"NearByListCell";    
    NearByListCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[NearByListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *item = [_friendsList objectAtIndex:indexPath.row];
    NSString *picurl = [NSString stringWithFormat:@"%@%@",[item objectForKey:@"PhotoUrl"],THUMB_IMAGE_SUFFIX];
    if (!picurl)picurl = @"";
    [cell.avatarImg setImageWithURL:[NSURL URLWithString:picurl]placeholderImage:[UIImage imageNamed:@"tx_gray.png"]];
    cell.usernameLbl.text = [item objectForKey:@"MemberName"];
    NSString  *ageImgName = ([[item objectForKey:@"Sex"] intValue]==0)?@"pyq_girl.png":@"pyq_boy.png";
    cell.ageImg.image = [UIImage imageNamed:ageImgName];
    cell.ageLbl.text = [[item objectForKey:@"Age"] stringValue];
    cell.distanceLbl.text = [NSString stringWithFormat:@"%@  |  当前在线",[[GPS gpsManager] getDistanceFromLat:[item objectForKey:@"WeiDu"] Lon:[item objectForKey:@"JingDu"]]];
    NSString *statusString = [item objectForKey:@"Introduction"];
    if (!statusString || [statusString isEqual:[NSNull null]]  || [statusString length]<1 )
    {
        statusString = AppLocalizedString(@"这家伙很懒...");
    }
    else
    {
        statusString = [Tool decodeBase64:statusString];
    }
    cell.statusLbl.text = statusString;

    return cell;
}

-(UITableViewCell *)GridCellForIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"ThumbImageCell";
    ThumbImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[ThumbImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell addTapTarget:self action:@selector(imageViewTapIndex:imageView:)];
    }
    NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:nil, nil];
    for (int i = 0 ; i < ROWNUMBERS; i++)
    {
        NSInteger idx = indexPath.row*ROWNUMBERS+i;
        if (idx>=[_friendsList count])break;
        NSDictionary *item = [_friendsList objectAtIndex:idx];
        NSString *picurl = [NSString stringWithFormat:@"%@%@",[item objectForKey:@"PhotoUrl"],THUMB_IMAGE_SUFFIX];
        [dataArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:picurl,@"PhotoUrl", nil]];
    }
    cell.imageSourceArray=dataArray;
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
               
               

