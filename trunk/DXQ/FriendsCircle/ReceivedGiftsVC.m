//
//  ReceivedGiftsVC.m
//  DXQ
//
//  Created by Yuan on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ReceivedGiftsVC.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "GetGiftListRequest.h"
#import "LoadMoreView.h"
#import "UIImageView+WebCache.h"

@interface ReceivedGiftsVC ()<GetGiftListRequestDelegate,UITableViewDelegate,UITableViewDataSource>{

    BOOL isRefresh;
    GetGiftListRequest *gigtRequest;
    UIImageView *nodataView;
    LoadMoreView *loadMoreView;
}

@end

@implementation ReceivedGiftsVC

-(void)dealloc{

    [self cancelAllRequest];
    [_tableView release];
    [_giftList release];
    [nodataView release];
    [loadMoreView release];
    [_userID release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)loadView{

    [super loadView];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView=tableView;
    [tableView release];
    
    
    if (!loadMoreView) {
        loadMoreView=[[LoadMoreView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 60.f)];
        [loadMoreView setLoadMoreBlock:^{
            [self getGiftListByPage:self.giftList.count/20+1];
        }];
    }
    if (!nodataView) {
        nodataView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodata"]];
    }
}

- (void)viewDidLoad
{
    [self setNavgationTitle:@"收到的礼物" backItemTitle:AppLocalizedString(@"返回")];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self cancelAllRequest];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if (!_giftList) {
        [self.tableView pullToRefresh];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Set method

-(void)setTableView:(UITableView *)tableView{

    if ([tableView isEqual:_tableView]) {
        return;
    }
    [_tableView removeFromSuperview];
    [_tableView release];
    _tableView=[tableView retain];
    [self.view addSubview:_tableView];
    [_tableView setPullToRefreshHandler:^{
    
        [self getGiftListByPage:1];
    }];
}

-(void)setGiftList:(NSArray *)giftList{

    if ([giftList isEqualToArray:_giftList]) {
        return;
    }
    [_giftList release];
    _giftList=[giftList retain];
    [self.tableView reloadData];
}

#pragma mark -UITableViewDatasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 85.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _giftList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellString=@"gift";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellString] autorelease];
        UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,10,65,65)];
        iconImageView.tag = 1;
        iconImageView.contentMode=UIViewContentModeScaleAspectFit;
        iconImageView.layer.cornerRadius = 4.0f;
        iconImageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:iconImageView];
        [iconImageView release];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *item=[_giftList objectAtIndex:indexPath.row];
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.000 green:0.180 blue:0.311 alpha:0.950];

    cell.detailTextLabel.text = [item objectForKey:@"Name"];
    cell.detailTextLabel.font = NormalDefaultFont;
    UIImageView *iconImageView =(UIImageView *)[cell.contentView viewWithTag:1];
    [iconImageView setImageWithURL:[NSURL URLWithString:[[item objectForKey:@"Url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"demo_gift"]];
    cell.indentationWidth=75;
    cell.indentationLevel=1;
    return cell;
}
#pragma maek -request


-(void)cancelAllRequest{

    [self cancelGetGiftRequest];
}

-(void)getGiftListByPage:(NSInteger)page{

    [self cancelGetGiftRequest];
    if (page==1) {
        isRefresh=YES;
    }else
        isRefresh=NO;
    
    NSString *logId=[[SettingManager sharedSettingManager]loggedInAccount];
    
    NSDictionary *pager=[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%d",page],@"PageIndex",
                         [NSString stringWithFormat:@"%d",20],@"ReturnCount", nil];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       logId,@"AccountId",pager,@"Pager",
                       _userID,@"AccountFrom",@"-1",@"Kind", nil];
    [loadMoreView setState:LoadMoreStateRequesting];
    gigtRequest=[[GetGiftListRequest alloc]initRequestWithDic:dic];
    [gigtRequest setDelegate:self];
    [gigtRequest startAsynchronous];
    
}

-(void)cancelGetGiftRequest{

    if (gigtRequest) {
        [gigtRequest cancel];
        [gigtRequest release];
        gigtRequest=nil;
    }
}

-(void)getGiftListRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:errorMsg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [self.tableView refreshFinished];
    [loadMoreView setState:LoadMoreStateNormal];
}

-(void)getGiftListRequestDidFinishWithGiftList:(NSArray *)giftList{

    if (isRefresh) {
        self.giftList=giftList;
    }else
    {
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:_giftList];
        self.giftList=tempArray;
    }
    if (giftList.count==20) {
        self.tableView.tableFooterView=loadMoreView;
    }else
        self.tableView.tableFooterView=nodataView;
    
    [self.tableView refreshFinished];
    [loadMoreView setState:LoadMoreStateNormal];
}
@end
