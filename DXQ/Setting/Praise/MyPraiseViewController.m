//
//  MyPraiseViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-2.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "MyPraiseViewController.h"
#import "UserLoadPraiseList.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "LoadMoreView.h"
#import "MyPraiseCell.h"
#import "UIImageView+WebCache.h"
#import "PhotoDetailViewController.h"
#import "MemberDetailViewController.h"
#import "HotEventDetailViewController.h"

@interface MyPraiseViewController ()<BusessRequestDelegate>{

    UserLoadPraiseList *praiseListRequest;
    BOOL isRefresh;
    LoadMoreView *loadMoreView;
}

@end

@implementation MyPraiseViewController


-(void)dealloc{

    [_tableView release];
    [_visibleArray release];
    [loadMoreView release];
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
    
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    if (!loadMoreView) {
        loadMoreView=[[LoadMoreView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 60.f)];
        [loadMoreView setLoadMoreBlock:^{
        
            [self requestPraiseListByPage:self.visibleArray.count/20+1];
        }];
    }
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"我赞的") backItemTitle:AppLocalizedString(@"返回")];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    if (!_visibleArray) {
        [self.tableView pullToRefresh];
    }
}
-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self cancelAllRequest];
}

#pragma mark -Request

-(void)cancelAllRequest{

    [self cancelPraiseListRequest];
}

-(void)cancelPraiseListRequest{

    if (praiseListRequest) {
        [praiseListRequest cancel];
        [praiseListRequest release];
        praiseListRequest=nil;
    }
}

-(void)requestPraiseListByPage:(NSInteger)page{

    [self cancelPraiseListRequest];
    if (page==1) {
        isRefresh=YES;
    }else
        isRefresh=NO;
    
    NSDictionary *pager=[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%d",page],@"PageIndex",
                         [NSString stringWithFormat:@"%d",20],@"ReturnCount", nil];
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accountID,@"AccountId",pager,@"Pager", nil];
    praiseListRequest=[[UserLoadPraiseList alloc]initWithRequestWithDic:dic];
    praiseListRequest.delegate=self;
    [praiseListRequest startAsynchronous];
}

#pragma mark -

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [self.tableView refreshFinished];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{
    
    if (request==praiseListRequest) {
        [self.tableView refreshFinished];
        if (isRefresh) {
            self.visibleArray=data;
        }else
        {
            NSMutableArray *tempArray=[NSMutableArray arrayWithArray:_visibleArray];
            [tempArray addObjectsFromArray:data];
            self.visibleArray=tempArray;
        }
        if ([data count]==20) {
            self.tableView.tableFooterView=loadMoreView;
        }else
            self.tableView.tableFooterView=nil;
    }
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
    
        [self requestPraiseListByPage:1];
    }];
}

-(void)setVisibleArray:(NSArray *)visibleArray{

    if ([visibleArray isEqualToArray:_visibleArray]) {
        return;
    }
    [_visibleArray release];
    _visibleArray=[visibleArray retain];
    [self.tableView reloadData];
}

#pragma mark -UITableViewDataSouce And Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 75.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _visibleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ident=@"my praiser";
    MyPraiseCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell=[[[MyPraiseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident] autorelease];
    }
    NSDictionary *dic=[_visibleArray objectAtIndex:indexPath.row];
    [cell.praiseImageView setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"PictureUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"default_header"] success:^(UIImage *image,BOOL isCache){
        [Tool setImageView:cell.praiseImageView toImage:image];
    } failure:nil];
    cell.praiseNameLabel.text=[dic objectForKey:@"Title"];
    cell.opDate=[NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"OpTime"] floatValue]];
    NSString *kindText=[dic objectForKey:@"ObjectKind"];
    if ([kindText isEqualToString:@"Product"]) {
        NSString *productType=[dic objectForKey:@"ProductKind"];
        NSString *_productName=nil;
        if ([productType isEqualToString:@"Y"]) {
            _productName=AppLocalizedString(@"优惠券");
        }else if ([productType isEqualToString:@"H"]){
            _productName=AppLocalizedString(@"会员卡");
        }else if ([productType isEqualToString:@"T"]){
            _productName=AppLocalizedString(@"团购");
        }else
            _productName=AppLocalizedString(@"产品");
        cell.praiseTypeLabel.text=_productName;
    }else if ([kindText isEqualToString:@"MemberFile"]){
        cell.praiseTypeLabel.text=AppLocalizedString(@"照片");
    }else
        cell.praiseTypeLabel.text=AppLocalizedString(@"未知");
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic=[_visibleArray objectAtIndex:indexPath.row];
    NSString *objectKind=[dic objectForKey:@"ObjectKind"];
    if ([objectKind isEqualToString:@"MemberFile"]) {
        PhotoDetailViewController *photo=[[PhotoDetailViewController alloc]initWithImageInfoDic:dic];
        photo.imageIdKey=@"ObjectNo";
        [self.navigationController pushViewController:photo animated:YES];
        [photo release];
    }else if([objectKind isEqualToString:@"Product"])
    {
        NSString *productType=[dic objectForKey:@"ProductKind"];
        if ([productType isEqualToString:@"A"]) {
            HotEventDetailViewController *detail=[[HotEventDetailViewController alloc]init];
            [self.navigationController pushViewController:detail animated:YES];
            detail.simpleDic=dic;
            [detail release];
        }else
        {
            NSString *controllClass=nil;
            if ([productType isEqualToString:@"Y"]) {
                controllClass=@"TicketDetailViewController";
            }else if ([productType isEqualToString:@"H"]){
                controllClass=@"MemberDetailViewController";
            }else if ([productType isEqualToString:@"T"]){
                controllClass=@"TuanDetailViewController";
            }
            MemberDetailViewController *detail=[[NSClassFromString(controllClass) alloc]init];
            detail.simpleInfoDic=dic;
            [self.navigationController pushViewController:detail animated:YES];
            [detail release];
        }
    }
}
@end
