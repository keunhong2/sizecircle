//
//  UserMemberViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UserMemberViewController.h"
#import "CustomSearchBar.h"
#import "UserMemberCell.h"
#import "MemberDetailViewController.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "UserProductViewController.h"
#import "LoadMoreView.h"

@interface UserMemberViewController (){
    
    BOOL pullFootViewVisible;//
    LoadMoreView *loadMoreView;
}

@end

@implementation UserMemberViewController

@synthesize searchBar=_searchBar;
@synthesize tableView=_tableView;


-(void)dealloc{
    
    [_searchBar release];
    [_tableView release];
    [self cancelAllRequest];
    [screenObj release];
    [_productArray release];
    [loadMoreView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        screenObj=[[ProductScreenObj alloc]initWithProductType:self.type];
        isRefresh=NO;
        isFirstRefresh=YES;
        
        self.title=AppLocalizedString(@"会员卡");
    }
    return self;
}

-(ProductType)type{
    
    return ProductTypeMemberCard;
}

-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    CustomSearchBar *searchBar=[[CustomSearchBar alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 44.f)];
    [self.view addSubview:searchBar];
    searchBar.placeholder=AppLocalizedString(@"搜索");
    searchBar.delegate=self;
    self.searchBar=searchBar;
    [searchBar release];
    
    UITableView *tempTableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 44.f, self.view.frame.size.width, self.view.frame.size.height-44.f) style:UITableViewStylePlain];
    tempTableView.backgroundColor=[UIColor clearColor];
    tempTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tempTableView.delegate=self;
    tempTableView.dataSource=self;
    [self.view addSubview:tempTableView];
    self.tableView=tempTableView;
    [tempTableView release];
    
    loadMoreView=[[LoadMoreView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 60.f)];
    [loadMoreView setLoadMoreBlock:^{
     
        [self productRequestByPage:screenObj.page+1];
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIImage *btnFitImg=[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:btnFitImg forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    NSString *btnTitle=nil;
    if (self.type==ProductTypeTicket) {
        btnTitle=AppLocalizedString(@"我的优惠券");
    }else if(self.type==ProductTypeTuan){
        btnTitle=AppLocalizedString(@"我的团购");
    }else
        btnTitle=AppLocalizedString(@"我的会员卡");
    
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.frame=CGRectMake(btn.frame.origin.x, btn.frame.origin.y, btn.frame.size.width+10.f,bgImage.size.height);
    [btn addTarget:self action:@selector(myProductBtnDone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem=item;
    [item release];
    
    [self.tableView setPullToRefreshHandler:^{
        
        [self productRequestByPage:1];
    }];
}

-(void)viewDidUnload{
    
    [_searchBar release];
    _searchBar=nil;
    
    [_tableView release];
    _tableView=nil;
    
    [loadMoreView release];
    loadMoreView=nil;
    
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if (isFirstRefresh) {
        [self.tableView pullToRefresh];
        isFirstRefresh=NO;
    }
}

- (void)didReceiveMemoryWarning
{
    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)screenByText:(NSString *)text
{
    
    // over write
}

-(void)myProductBtnDone:(UIButton *)btn{
    
    //over write
    [self goProductManageViewController];
}

-(void)setVisibleArray:(NSArray *)visibleArray{
    
    if ([visibleArray isEqualToArray:_visibleArray]) {
        return;
    }
    [_visibleArray release];
    _visibleArray=[visibleArray retain];
    [self.tableView reloadData];
}


-(void)goProductManageViewController{

    NSString *controlClass=nil;
    switch (self.type) {
        case ProductTypeEvent:
            controlClass=@"MyEventViewController";
            break;
        case ProductTypeMemberCard:
            controlClass=@"MyCardViewController";
            break;
        case ProductTypeTicket:
            controlClass=@"MyTicketViewController";
            break;
        case ProductTypeTuan:
            controlClass=@"MyTuanViewController";
        default:
            break;
    }
    UIViewController *user=[[NSClassFromString(controlClass) alloc]init];
    [self.navigationController pushViewController:user animated:YES];
    [user release];
}
#pragma mark -Cell ImageView is tap

-(void)memberView:(UIView *)view tapForIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger tempLocation=indexPath.row*2;
    NSInteger tempLength=2;
    if (tempLocation+2>_productArray.count) {
        tempLength=1;
    }
    NSArray *array=[_productArray subarrayWithRange:NSMakeRange(tempLocation, tempLength)];
    NSDictionary *dic=[array objectAtIndex:view.tag-1];
    MemberDetailViewController *member=[[MemberDetailViewController alloc]init];
    member.simpleInfoDic=dic;
    [self.navigationController pushViewController:member animated:YES];
    [member release];
}

-(NSArray *)searchProductByText:(NSString *)text
{
    if (text.length==0) {
        return _productArray;
    }
    NSMutableArray *tempArray=[NSMutableArray new];
    for (int i=0; i<_productArray.count; i++) {
        NSDictionary *dic=[_productArray objectAtIndex:i];
        NSString *title=[dic objectForKey:@"Title"];
        if ([title rangeOfString:text options:NSCaseInsensitiveSearch].location!=NSNotFound) {
            [tempArray addObject:dic];
        }
    }
    return [tempArray autorelease];
}

#pragma mark -UISearchBarDelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    //do search
    if (searchText.length==0) {
        [(UIView *)[self.tableView pullToLoadMoreView]setHidden:pullFootViewVisible];
    }else
    {
        pullFootViewVisible=[(UIView *)[self.tableView pullToLoadMoreView]isHidden];
        [(UIView *)[self.tableView pullToLoadMoreView]setHidden:YES];
    }
    self.visibleArray=[self searchProductByText:searchText];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}

#pragma mark -UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 135.f;
}

#pragma mark-UITableViewDataSource And Delgate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_visibleArray.count%2==0) {
        return _visibleArray.count/2;
    }else
        return _visibleArray.count/2+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndent=@"member";
    UserMemberCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndent];
    if (!cell) {
        cell=[[[UserMemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndent] autorelease];
        [cell setTarget:self action:@selector(memberView:tapForIndexPath:)];
    }
    NSInteger tempLocation=indexPath.row*2;
    NSInteger tempLength=2;
    if (tempLocation+2>_visibleArray.count) {
        tempLength=1;
    }
    NSArray *array=[_visibleArray subarrayWithRange:NSMakeRange(tempLocation, tempLength)];
    cell.userMemberArray=array;
    return cell;
}

#pragma mark -Request

-(void)cancelAllRequest{
    
    if (productRequest) {
        [productRequest cancel];
        [productRequest release];
        productRequest=nil;
    }
}

-(void)productRequestByPage:(NSInteger)page{
    
    if (productRequest) {
        [productRequest cancel];
        [productRequest release];
        productRequest=nil;
    }
    
    if (page==1) {
        isRefresh=YES;
    }else
        isRefresh=NO;
    screenObj.page=page;
    NSDictionary *dic=[screenObj screenDic];
    productRequest=[[ProductListRequest alloc]initWithRequestWithDic:dic];
    productRequest.delegate=self;
    loadMoreView.state=LoadMoreStateRequesting;
    [productRequest startAsynchronous];
}

#pragma mark -RequstDelegate

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{
    
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [self.tableView refreshFinished];
    loadMoreView.state=LoadMoreStateNormal;
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{
        
    if ([request isEqual:productRequest]) {
        self.searchBar.text=@"";
        if (isRefresh) {
            self.productArray=data;
            screenObj.page=1;
        }else{
            screenObj.page+=1;
            NSMutableArray *tempArray=[NSMutableArray arrayWithArray:_productArray];
            [tempArray addObjectsFromArray:data];
            self.productArray=tempArray;
        }
        if ([data count]==screenObj.count) {
            self.tableView.tableFooterView=loadMoreView;
        }else{
            self.tableView.tableFooterView=nil;
        }
        
        self.visibleArray=_productArray;
        [self.tableView refreshFinished];
        loadMoreView.state=LoadMoreStateNormal;
    }
    
}
@end


@implementation ProductScreenObj

-(id)init{
    
    return [self initWithProductType:ProductTypeTicket];
}

-(id)initWithProductType:(ProductType)type{
    
    self=[super init];
    if (self) {
        _type=type;
        self.area=@"-1";
        self.classify=@"-1";
        _coordinate.latitude=80;
        _coordinate.longitude=100;
        _orderType=OrderTypeReleaseDate;
        _isAscendingOrder=NO;
        _page=1;
        _count=20;
        _isValid=YES;
        _lastPage=1;
    }
    return self;
}

-(void)setPage:(NSInteger)page{
    if (page==_page) {
        return;
    }
    _lastPage=_page;
    _page=page;
}

-(NSDictionary *)screenDic{
    
    NSDictionary *pager=[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%d",_page],@"PageIndex",
                         [NSString stringWithFormat:@"%d",_count],@"ReturnCount", nil];
    
    NSString *typeText=nil;
    switch (_type) {
        case ProductTypeMemberCard:
            typeText=@"H";
            break;
        case ProductTypeTicket:
            typeText=@"Y";
            break;
        case ProductTypeTuan:
            typeText=@"T";
            break;
        case ProductTypeEvent:
            typeText=@"A";
        default:
            break;
    }
    NSString *orderText=nil;
    switch (_orderType) {
        case OrderTypePopularity:
            orderText=@"1";
            break;
        case OrderTypeDistance:
            orderText=@"2";
            break;
        case OrderTypeReleaseDate:
            orderText=@"3";
            break;
        default:
            break;
    }
    NSString *ordereDir=_isAscendingOrder==YES?@"1":@"0";
    NSString *isValidText=[self isValid]==YES?@"-1":@"0";
    return [NSDictionary dictionaryWithObjectsAndKeys:
            typeText,@"ProductType",
            _area,@"Area",
            _classify,@"Classify",
            [[GPS gpsManager]getLocation:GPSLocationLongitude] ,@"JingDu",
            [[GPS gpsManager]getLocation:GPSLocationLatitude] ,@"WeiDu",
            @"100",@"JingDu",
            @"80",@"WeiDu",
            orderText,@"Order",
            ordereDir,@"OrderDirection"
            ,pager,@"Pager",isValidText,@"IsValid", nil];
}
@end

