//
//  MyAttenListViewController.m
//  DXQ
//
//  Created by 黄修勇 on 13-1-21.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "MyAttenListViewController.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "DXQBusessBaseRequest.h"
#import "UserLoadFriendList.h"

@interface MyAttenListViewController ()<BusessRequestDelegate>

@end

@implementation MyAttenListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    if (!loadMoreView) {
        loadMoreView=[[LoadMoreView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 60.f)];
        [loadMoreView setLoadMoreBlock:^{
            [self requestMyAttenByPage:_list.count/20+1];
        }];
    }
    
    if (noDataImgView) {
        noDataImgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodata"]];
    }
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [tableView release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavgationTitle:@"我的关注" backItemTitle:@"返回"];
	// Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_list==nil) {
        [self.tableView pullToRefresh];
    }
}

- (void)didReceiveMemoryWarning
{
//    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark set

-(void)setTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_tableView]) {
        return;
    }
    [_tableView removeFromSuperview];
    [_tableView release];
    _tableView=[tableView retain];
    [self.view addSubview:_tableView];
    [_tableView setPullToRefreshHandler:^{
    
        [self requestMyAttenByPage:1];
    }];
}

#pragma mark -Request

-(void)cancelAllRequest
{
    [self cancelRequestMyAttenList];
    [self.tableView refreshFinished];
}

-(void)requestMyAttenByPage:(NSInteger)page
{
    [self cancelRequestMyAttenList];
    
    if (page==1) {
        isRefresh=YES;
    }else
        isRefresh=NO;
    
    NSDictionary *pager=[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%d",page],@"PageIndex",
                         [NSString stringWithFormat:@"%d",20],@"ReturnCount", nil];
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    [loadMoreView setState:LoadMoreStateRequesting];
}

-(void)cancelRequestMyAttenList{

    
}

-(void)finishGetData:(NSArray *)data
{
    if (isRefresh) {
        self.list=data;
    }else
    {
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:_list];
        [tempArray addObjectsFromArray:data];
        self.list=tempArray;
    }
    
    if (data.count==20) {
        self.tableView.tableFooterView=loadMoreView;
    }else
        self.tableView.tableFooterView=noDataImgView;
    [self finishRequest];
}

-(void)finishRequest
{
    [self.tableView refreshFinished];
    [loadMoreView setState:LoadMoreStateNormal];
}


-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg
{
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [self finishRequest];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data
{
    [self finishGetData:data];
    [self finishRequest];
}

#pragma mark -UITableViewDataSourceAndDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellText=@"my atten";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellText];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellText] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic=[_list objectAtIndex:indexPath.row];
    return cell;
}

@end
