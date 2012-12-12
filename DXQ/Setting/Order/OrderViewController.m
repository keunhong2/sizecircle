//
//  OrderViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-1.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "OrderViewController.h"
#import "LoadMoreView.h"
#import "GetLoadUserProductRequest.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "UserProductCell.h"
#import "UIImageView+WebCache.h"
#import "UserProductViewController.h"
#import "OrderDetailViewController.h"

@interface OrderViewController ()<BusessRequestDelegate>{

    UIImageView *nodataImageView;
    LoadMoreView *loadMoreView;
    GetLoadUserProductRequest *productRequest;
    BOOL isRefresh;
}

@end

@implementation OrderViewController

-(void)dealloc{

    [_tableView release];
    [_segment release];
    [_visibleArray release];
    [_untreatedArray release];
    [_treatedArray release];
    
    [nodataImageView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isSelectUntreatedType=YES;
    }
    return self;
}

-(void)loadView{

    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    UserProductSegmentControl *segment=[[UserProductSegmentControl alloc]initWithType:0];
    [self.view addSubview:segment];
    [segment addTarget:self action:@selector(selectChange:) forControlEvents:UIControlEventValueChanged];
    self.segment=segment;
    [segment release];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 50.f, self.view.frame.size.width, self.view.frame.size.height-50.f) style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    
    if (!nodataImageView) {
        nodataImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodata"]];
    }
    if (!loadMoreView) {
        loadMoreView=[[LoadMoreView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 60.f)];
        [loadMoreView setLoadMoreBlock:^{
            [self loadMore];
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setStateIsSelectUntreated:_isSelectUntreatedType];
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self cancelAllRequest];
}

-(void)loadMore{

    [self requestProductListByPage:_visibleArray.count/20+1];
}

-(void)setStateIsSelectUntreated:(BOOL)isUntreated{

    if (isUntreated) {
        self.visibleArray=[self untreatedArray];
        if (_finishGetUntreated) {
            self.tableView.tableFooterView=nodataImageView;
        }else
        {
            if ([self untreatedArray]) {
                self.tableView.tableFooterView=loadMoreView;
            }else
            {
                self.tableView.tableFooterView=nil;
                [self.tableView pullToRefresh];
            }
        }
    }else
    {
        self.visibleArray=[self treatedArray];
        if (_finishGetTreated) {
            self.tableView.tableFooterView=nodataImageView;
        }else
        {
            if ([self treatedArray]) {
                self.tableView.tableFooterView=loadMoreView;
            }else
            {
                self.tableView.tableFooterView=nil;
                [self.tableView pullToRefresh];
            }
        }
    }
}

-(void)selectChange:(UserProductSegmentControl *)segment{

    self.isSelectUntreatedType=segment.selectIndex==0?YES:NO;
}

-(NSDictionary *)requestArgsDicByPage:(NSInteger)page{

    return nil;
}

#pragma mark -Request

-(void)cancelAllRequest{

    [self.tableView refreshFinished];
    [self cancelOrderRequest];
}

-(void)cancelOrderRequest{

    if (productRequest) {
        [productRequest cancel];
        [productRequest release];
        productRequest=nil;
    }
}

-(void)requestProductListByPage:(NSInteger)page{

    [self cancelOrderRequest];
    NSDictionary *dic=[self requestArgsDicByPage:page];
    if (page==1) {
        isRefresh=YES;
    }else
        isRefresh=NO;
    productRequest=[[GetLoadUserProductRequest alloc]initWithRequestWithDic:dic];
    productRequest.delegate=self;
    loadMoreView.state=LoadMoreStateRequesting;
    [productRequest startAsynchronous];
}

#pragma mark -

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    loadMoreView.state=LoadMoreStateNormal;
    [self.tableView refreshFinished];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    [self.tableView refreshFinished];
    
    if (isRefresh) {
        self.visibleArray=data;
    }else
    {
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:_visibleArray];
        [tempArray addObjectsFromArray:data];
        self.visibleArray=tempArray;
    }
    
    if (_isSelectUntreatedType) {
        self.untreatedArray=_visibleArray;
    }else
        self.treatedArray=_visibleArray;
    
    if ([data count]==20) {
        if (_isSelectUntreatedType) {
            _finishGetUntreated=NO;
        }else
            _finishGetTreated=NO;
        self.tableView.tableFooterView=loadMoreView;
    }else
    {
        if (_isSelectUntreatedType) {
            _finishGetUntreated=YES;
        }else
            _finishGetTreated=YES;
        self.tableView.tableFooterView=nodataImageView;
    }
    loadMoreView.state=LoadMoreStateNormal;
}

#pragma mark -UITableViewDataSource And Delegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _visibleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier=@"user product";
    UserProductCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[[UserProductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    NSDictionary *dic=[_visibleArray objectAtIndex:indexPath.row];
    NSString *url=[[dic objectForKey:@"Url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.productImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil success:^(UIImage *image,BOOL isCache){
        [Tool setImageView:cell.productImageView toImage:image];
    } failure:nil];
    [cell.productNameLabel setText:[dic objectForKey:@"Name"]];
    [cell.exdateLabel setText:[Tool convertTimestampToNSDate:[[dic objectForKey:@"ExpiredDate"] integerValue]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    OrderDetailViewController *detail=[[OrderDetailViewController alloc]init];
    detail.orderDic=[self.visibleArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

#pragma mark -Set Methods

-(void)setTableView:(UITableView *)tableView{

    if ([tableView isEqual:_tableView]) {
        return;
    }
    [_tableView removeFromSuperview];
    [_tableView release];
    _tableView=[tableView retain];
    [self.view addSubview:_tableView];
    [self setStateIsSelectUntreated:_isSelectUntreatedType];
    [self.tableView setPullToRefreshHandler:^{
        [self requestProductListByPage:1];
    }];
}

-(void)setVisibleArray:(NSArray *)visibleArray{

    if ([_visibleArray isEqualToArray:visibleArray]) {
        return;
    }
    [_visibleArray release];
    _visibleArray=[visibleArray retain];
    [self.tableView reloadData];
}

-(void)setIsSelectUntreatedType:(BOOL)isSelectUntreatedType{

    if (_isSelectUntreatedType==isSelectUntreatedType) {
        return;
    }
    [self cancelAllRequest];
    _isSelectUntreatedType=isSelectUntreatedType;
    [self setStateIsSelectUntreated:isSelectUntreatedType];
}

-(void)setSegment:(UserProductSegmentControl *)segment{

    if ([segment isEqual:_segment]) {
        return;
    }
    [_segment removeFromSuperview];
    [_segment release];
    _segment=[segment retain];
    [self.view addSubview:_segment];
    _segment.selectIndex=_isSelectUntreatedType==YES?0:1;
}

@end
