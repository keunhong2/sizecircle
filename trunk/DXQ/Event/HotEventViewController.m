//
//  HotEventViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-20.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "HotEventViewController.h"
#import "CustomSearchBar.h"
#import "ProductListRequest.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "UserMemberViewController.h"
#import "HotEventCell.h"
#import "UIImageView+WebCache.h"
#import "HotEventDetailViewController.h"
#import "ScreenViewController.h"
#import "LoadMoreView.h"

@interface HotEventViewController ()<BusessRequestDelegate,ScreenViewControllerDelegate >{

    ProductListRequest *eventRequest;
    ProductScreenObj *screenObje;
    BOOL isRefrush;
    LoadMoreView *loadMoreView;
}

@end

@implementation HotEventViewController

-(void)dealloc{
    [self cancelAllRequest];
    [screenObje release];
    [_tableView release];
    [_searchBar release];
    [_hotEventArray release];
    [_visibleArray release];
    [loadMoreView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=AppLocalizedString(@"热门活动");
        screenObje=[[ProductScreenObj alloc]initWithProductType:ProductTypeEvent];
    }
    return self;
}


-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    CustomSearchBar *searchBar=[[CustomSearchBar alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 44.f)];
    searchBar.delegate=self;
    [self.view addSubview:searchBar];
    searchBar.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    searchBar.placeholder=AppLocalizedString(@"搜索");
    self.searchBar=searchBar;
    [searchBar release];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 44.f, self.view.frame.size.width, self.view.frame.size.height-44.f) style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.delegate =self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setPullToRefreshHandler:^{
    
        isRefrush=YES;
        screenObje.page=1;
        [self requestHotEvent];
    }];
    loadMoreView=[[LoadMoreView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 60.f)];
    [loadMoreView setLoadMoreBlock:^{
    
        screenObje.page+=1;
        [self requestHotEvent];
    }];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
}

-(void)viewDidUnload{
 
    [super viewDidUnload];
    self.tableView=nil;
    self.searchBar=nil;
    [loadMoreView release];
    loadMoreView=nil;
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    if (_hotEventArray==nil) {
        [self.tableView pullToRefresh];
    }
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self cancelAllRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark btn action

-(void)screenBtnDone
{
    ScreenViewController *screen=[[ScreenViewController alloc]initWithScreenType:ScreenTypeDefault];
    screen.screenDelegate=self;
    CustonNavigationController *navigation=[[CustonNavigationController alloc]initWithRootViewController:screen];
    screen.selectClassName=[screenObje.classify isEqualToString:@"-1"]?@"不限":screenObje.classify;
    screen.selectLocationName=[screenObje.area isEqualToString:@"-1"]?@"不限":screenObje.area;
    [self.navigationController presentModalViewController:navigation animated:YES];
    [screen release];
    [navigation release];
}

#pragma mark -

-(void)cancelAllRequest{

    [self.tableView refreshFinished];
    loadMoreView.state=LoadMoreStateNormal;
    
    if (eventRequest) {
        [eventRequest cancel];
        [eventRequest release];
        eventRequest=nil;
    }
}

-(void)requestHotEvent{

    if (eventRequest) {
        [eventRequest cancel];
        [eventRequest release];
        eventRequest=nil;
    }
    loadMoreView.state=LoadMoreStateRequesting;
    if (screenObje.page==1) {
        isRefrush=YES;
    }else
        isRefrush=NO;
    eventRequest=[[ProductListRequest alloc]initWithRequestWithDic:[screenObje screenDic]];
    eventRequest.delegate=self;
    [eventRequest startAsynchronous];
}


#pragma mark -RequestDelagte

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [self.tableView refreshFinished];
    loadMoreView.state=LoadMoreStateNormal;
    screenObje.page=screenObje.lastPage;
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    if ([request isEqual:eventRequest]) {
        if (isRefrush) {
            self.hotEventArray=data;
        }else
        {
            NSMutableArray *tempArray=[NSMutableArray arrayWithArray:_hotEventArray];
            [tempArray addObjectsFromArray:data];
            self.hotEventArray=tempArray;
        }
        
        if ([data count]==20) {
            self.tableView.tableFooterView=loadMoreView;
        }else
        {
            self.tableView.tableFooterView=nil;
        }
        self.searchBar.text=@"";
        self.visibleArray=_hotEventArray;
        [self.tableView refreshFinished];
        [self.tableView reloadData];
        loadMoreView.state=LoadMoreStateNormal;
    }
}

#pragma mark -ScreenViewControlleDelegate

-(void)didCancelScrennViewController:(BaseScreenViewController *)screenViewController{

    [screenViewController dismissModalViewControllerAnimated:YES];
}

-(void)screenViewController:(BaseScreenViewController *)screenViewController didDoneScreenWithInfo:(NSDictionary *)screenInfo{

    [screenViewController dismissModalViewControllerAnimated:YES];
    screenObje.area=[screenInfo objectForKey:@"Area"];
    screenObje.classify=[screenInfo objectForKey:@"Classify"];
    [self.tableView pullToRefresh];
}
#pragma mark -UITableViewDataSouce And Delegate


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _visibleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 160.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier=@"hot event";
    HotEventCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[[HotEventCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    NSDictionary *dic=[self.visibleArray objectAtIndex:indexPath.row];
    cell.eventNameLabel.text=[dic objectForKey:@"Title"];
    NSString *startDate=[Tool convertTimestampToNSDate:[[dic objectForKey:@"StartDate"] integerValue] dateStyle:@"YYYY-MM-dd"];
    NSString *endDate=[Tool convertTimestampToNSDate:[[dic objectForKey:@"EndDate"] integerValue]dateStyle:@"YYYY-MM-dd"];
    cell.eventDateLabel.text=[NSString stringWithFormat:@"%@-%@",startDate,endDate];
    cell.eventLocationLabel.text=[dic objectForKey:@"Address"];
    NSInteger classTag=[[dic objectForKey:@"Classify"] integerValue];
    NSString *classText=nil;
    switch (classTag) {
        case 1:
            classText=@"美食";
            break;
        case 2:
            classText=@"健康";
            break;
        case 3:
            classText=@"休闲";
            break;
        case 4:
            classText=@"娱乐";
            break;
        default:
            classText=nil;
            break;
    }
    cell.eventTypeLabel.text=classText;
    NSString *url=[[dic objectForKey:@"PhotoUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.evengImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil success:^(UIImage *image ,BOOL isCache){
        [Tool setImageView:cell.evengImageView toImage:image];
    } failure:nil];
    cell.interestCount=[[dic objectForKey:@"LinkCount"] integerValue];
    cell.joinCount=[[dic objectForKey:@"BuyerCount"] integerValue];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    HotEventDetailViewController *detail=[[HotEventDetailViewController alloc]init];
    [self.navigationController pushViewController:detail animated:YES];
    detail.simpleDic=[_visibleArray objectAtIndex:indexPath.row];
    [detail release];
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

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (searchText.length==0) {
        self.visibleArray=_hotEventArray;
        [self.tableView reloadData];
        return;
    }
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<self.visibleArray.count; i++) {
        NSDictionary *dic=[self.visibleArray objectAtIndex:i];
        NSString *title=[dic objectForKey:@"Title"];
        if ([title rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound) {
            [array addObject:dic];
            continue;
        }
        NSString *address=[dic objectForKey:@"Address"];
        if ([address rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound) {
            [array addObject:dic];
            continue;
        }
        NSString *classiify=[dic objectForKey:@"Classify"];
        if ([classiify rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound) {
            [array addObject:dic];
            continue;
        }
    }
    self.visibleArray=array;
    [self.tableView reloadData];
}
@end

