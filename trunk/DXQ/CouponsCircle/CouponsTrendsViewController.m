//
//  CouponsTrendsViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "CouponsTrendsViewController.h"
#import "CouponsTrendsCell.h"
#import "ThumbImageCell.h"
#import "CounponsAboutCell.h"
#import "UIColor+ColorUtils.h"
#import "CouponsBottomBar.h"
#import "PhotoDetailViewController.h"
#import "ShopDetailRequest.h"
#import "UIImageView+WebCache.h"
#import "GetShopActivityLiseet.h"
#import "PhotoListRequest.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "LoadMoreView.h"
#import "AcvityDetailViewController.h"
#import "PhotoDetailVC.h"

#define COUPONS_TRENDS_CELL_FONT                        [UIFont systemFontOfSize:16.f]


@interface CouponsTrendsViewController ()<BusessRequestDelegate>{
    
    ShopDetailRequest *detailRequest;
    GetShopActivityLiseet *activityListRequest;
    PhotoListRequest *shopPhotoList;
    BOOL isShowLoadMoreView;
    BOOL isRefresh;
    NSInteger currentPage;
    LoadMoreView *loadMoreView;
}

-(UITableViewCell *)trendCellForIndexPath:(NSIndexPath *)indexPath;

-(CGFloat)aboutHeighteForIndexPath:(NSIndexPath *)indexPath;

-(UITableViewCell *)aboutCellForIndexPath:(NSIndexPath *)indexPath;

//request

@end

@implementation CouponsTrendsViewController
@synthesize tableView=_tableView;
@synthesize bottomBar=_bottomBar;

-(void)dealloc{
    
    [_tableView release];
    [_bottomBar release];
    [_shopDetailInfoDic release];
    [_shopSimpleInfoDic release];
    [_activiryArray release];
    [_photoListArray release];
    [loadMoreView release];
    [super dealloc];
}

-(id)initWithShopSimpleDic:(NSDictionary *)dic{
    
    self=[super init];
    if (self) {
        self.shopSimpleInfoDic=dic;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        currentPage=1;
    }
    return self;
}

-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    [self.view setNeedsDisplay];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.0f, rect.size.width,rect.size.height-49.f) style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    
    loadMoreView=[[LoadMoreView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 60.f)];
    [loadMoreView setLoadMoreBlock:^{
        
        [self requestActivityListByPage:currentPage+1];
    }];
    _bottomBar=[[CouponsBottomBar alloc]initWithFrame:CGRectMake(0.f, self.view.frame.size.height-49.f, self.view.frame.size.width, 49.f)];
    _bottomBar.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_bottomBar];
    [_bottomBar addTarget:self action:@selector(couponsChange:) forControlEvents:UIControlEventValueChanged];
    _bottomBar.selectIndex=0;
    _showType=CouponsTypeAbout;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"商家") backItemTitle:AppLocalizedString(@"返回")];
}

-(void)viewDidUnload{
    
    [super viewDidUnload];
    [loadMoreView release];
    loadMoreView=nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_shopDetailInfoDic&&_showType==CouponsTypeAbout) {
        [self requestShopInfo];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self cancelAllRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark -Set Method

-(void)setShowType:(CouponsContentType)showType{
    
    if (showType==_showType) {
        return;
    }
    _showType=showType;
    [self cancelAllRequest];
    
    [_tableView reloadData];
    [_tableView scrollRectToVisible:CGRectMake(0.f, 0.f, _tableView.frame.size.width, _tableView.frame.size.height) animated:YES];
    switch (_showType) {
        case CouponsTypeAbout:
            self.title=AppLocalizedString(@"商家");
            [self.tableView setPullToRefreshHandler:^{
                [self requestShopInfo];
            }];
            self.tableView.tableFooterView=nil;
            break;
        case CouponsTypeTrends:
            self.title=AppLocalizedString(@"商家动态");
        {
            [self.tableView setPullToRefreshHandler:^{
                [self requestActivityListByPage:1];
            }];
            if (isShowLoadMoreView) {
                self.tableView.tableFooterView=loadMoreView;
            }else
                self.tableView.tableFooterView=nil;
            if (_activiryArray.count==0) {
                [self.tableView pullToRefresh];
            }
        }
            break;
        case CouponsTypePhoto:
        {
            self.title=AppLocalizedString(@"商家照片");
            [self.tableView setPullToRefreshHandler:^{
                [self requestPhotList];
            }];
            self.tableView.tableFooterView=nil;
            if (_photoListArray.count==0) {
                [self.tableView pullToRefresh];
            }
        }
        default:
            break;
    }
}

-(void)setShopSimpleInfoDic:(NSDictionary *)shopSimpleInfoDic{
    
    if ([_shopSimpleInfoDic isEqualToDictionary:shopSimpleInfoDic]) {
        return;
    }
    [_shopSimpleInfoDic release];
    _shopSimpleInfoDic=[shopSimpleInfoDic retain];
    if (_showType==CouponsTypeAbout) {
        [self.tableView reloadData];
    }
}

-(void)setShopDetailInfoDic:(NSDictionary *)shopDetailInfoDic{
    if ([_shopDetailInfoDic isEqualToDictionary:shopDetailInfoDic]) {
        return;
    }
    [_shopDetailInfoDic release];
    _shopDetailInfoDic=[shopDetailInfoDic retain];
    
    if (_showType==CouponsTypeAbout) {
        [self.tableView reloadData];
    }
}

-(void)setActiviryArray:(NSArray *)activiryArray{
    
    if ([_activiryArray isEqualToArray:activiryArray]) {
        return;
    }
    [_activiryArray release];
    _activiryArray=[activiryArray retain];
    if (_showType==CouponsTypeTrends) {
        [self.tableView reloadData];
    }
}

-(void)setPhotoListArray:(NSArray *)photoListArray{
    
    if ([_photoListArray isEqualToArray:photoListArray]) {
        return;
    }
    [_photoListArray release];
    _photoListArray=[photoListArray retain];
    if (_showType==CouponsTypePhoto) {
        [self.tableView reloadData];
    }
}

-(void)couponsChange:(CouponsBottomBar *)couponsBar{
    self.showType=couponsBar.selectIndex;
}


-(void)imageViewTapIndex:(NSIndexPath *)indexPath imageView:(UIImageView *)imageView{
    NSInteger location=indexPath.row*4;
    NSInteger length=4;
    if ([self photoListArray].count-indexPath.row*4<4) {
        length=[self photoListArray].count-indexPath.row*4;
    }
    NSArray *array=[_photoListArray subarrayWithRange:NSMakeRange(location, length)];
    NSDictionary *dic=[array objectAtIndex:imageView.tag-1];
//    PhotoDetailViewController *photo=[[PhotoDetailViewController alloc]initWithImageInfoDic:dic];
//    [self.navigationController pushViewController:photo animated:YES];
//    [photo release];
    
    PhotoDetailVC *photo=[[PhotoDetailVC alloc]initWithUserInfo:dic];
    [self.navigationController pushViewController:photo animated:YES];
    [photo release];
}
#pragma mark -Request

-(void)cancelAllRequest{
    [[ProgressHUD sharedProgressHUD]hide];
    [self.tableView refreshFinished];
    [self.tableView loadMoreFinished];
    
    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release];
        detailRequest=nil;
    }
    if (activityListRequest) {
        [activityListRequest cancel];
        [activityListRequest release];
        activityListRequest=nil;
    }
    if (shopPhotoList) {
        [shopPhotoList cancel];
        [shopPhotoList release];
        shopPhotoList=nil;
    }
}

-(void)requestShopInfo{
    
    if (!_shopSimpleInfoDic) {
        HYLog(@"商家id无法获取");
        return;
    }
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    
    NSString *shopID=[_shopSimpleInfoDic objectForKey:@"AccountId"];
    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release];
        detailRequest=nil;
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       shopID,@"AccountId",
                       [[SettingManager sharedSettingManager]loggedInAccount],@"AccountFrom", nil];
    detailRequest=[[ShopDetailRequest alloc]initWithRequestWithDic:dic];
    detailRequest.delegate=self;
    [detailRequest startAsynchronous];
}

-(void)requestActivityListByPage:(NSInteger)page{
    
    if (activityListRequest) {
        [activityListRequest cancel];
        [activityListRequest release];
        activityListRequest=nil;
    }
    
    NSString *shopID=nil;
    if(!_shopSimpleInfoDic){
        return;
    }
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    
    if (page==1) {
        isRefresh=YES;
    }else
        isRefresh=NO;
    shopID=[_shopSimpleInfoDic objectForKey:@"AccountId"];
    NSDictionary *pageDic=[NSDictionary dictionaryWithObjectsAndKeys:
                           [NSString stringWithFormat:@"%d",page],@"PageIndex",
                           [NSString stringWithFormat:@"%d",DEFAULT_REQUEST_PAGE_COUNT],@"ReturnCount", nil];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:shopID,@"AccountId",pageDic,@"Pager", nil];
    activityListRequest=[[GetShopActivityLiseet alloc]initWithRequestWithDic:dic];
    activityListRequest.delegate=self;
    [activityListRequest startAsynchronous];
}

-(void)requestPhotList{
    
    if (shopPhotoList) {
        [shopPhotoList cancel];
        [shopPhotoList release];
        shopPhotoList=nil;
    }
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[_shopSimpleInfoDic objectForKey:@"AccountId"],@"AccountId", nil];
    shopPhotoList=[[PhotoListRequest alloc]initWithRequestWithDic:dic];
    shopPhotoList.delegate=self;
    [shopPhotoList startAsynchronous];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (_showType==CouponsTypeAbout) {
        return 3;
    }else
        return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (_showType) {
        case CouponsTypeAbout:
            return 1;
            break;
        case CouponsTypePhoto:
        {
            NSInteger tempNumer=_photoListArray.count/4;
            if (_photoListArray.count%4!=0) {
                tempNumer+=1;
            }
            return tempNumer;
        }
            break;
        case CouponsTypeTrends:
            return _activiryArray.count;
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (_showType) {
        case CouponsTypeAbout:
        {
            return [self aboutHeighteForIndexPath:indexPath];
        }
            break;
        case CouponsTypePhoto:
            return 83.f;
            break;
        case CouponsTypeTrends:
            return 260.f;
        default:
            return 0.f;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (_showType==CouponsTypeAbout) {
        if (section==0) {
            return 0.f;
        }else
            return 22.f;
    }else
        return 0.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_showType==CouponsTypeAbout) {
        if (section==0) {
            return nil;
        }else
        {
            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.0f, tableView.frame.size.width, 22.f)];
            view.backgroundColor=[UIColor colorWithRed:242.f/255.f green:242.f/255.f blue:242.f/255.f alpha:1.f];
            view.autoresizingMask=UIViewAutoresizingFlexibleWidth;
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10.f, 0.f, view.frame.size.width-20.f, 22.f)];
            label.backgroundColor=[UIColor clearColor];
            label.textColor=[UIColor colorWithString:@"#ADADAD"];
            label.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            if (section==1) {
                label.text=AppLocalizedString(@"简介");
            }else
                label.text=AppLocalizedString(@"营业时间");
            label.font=[UIFont systemFontOfSize:15.f];
            [view addSubview:label];
            [label release];
            
            //top line
            
            UIColor *lineColor=[UIColor colorWithRed:194.f/255.f green:194.f/255.f blue:194.f/255.f alpha:1.f];
            
            UIView *topLine=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, view.frame.size.width, 1.f)];
            topLine.backgroundColor=lineColor;
            topLine.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
            [view addSubview:topLine];
            [topLine release];
            
            //bottom libne
            
            UIView *bottomLine=[[UIView alloc]initWithFrame:CGRectMake(0.f, view.frame.size.height-1.f, view.frame.size.width, 1.f)];
            bottomLine.backgroundColor=lineColor;
            bottomLine.autoresizingMask=UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
            [view addSubview:bottomLine];
            [bottomLine release];
            
            return [view autorelease];
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_showType) {
        case CouponsTypeAbout:
        {
            return [self aboutCellForIndexPath:indexPath];
        }
            break;
        case CouponsTypeTrends:
        {
            return [self trendCellForIndexPath:indexPath];
        }
            break;
        case CouponsTypePhoto:
        {
            return [self photoCellForIndexPath:indexPath];
        }
            break;
        default:
            return nil;
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_showType==CouponsTypeTrends) {
        AcvityDetailViewController *acvity=[[AcvityDetailViewController alloc]init];
        [self.navigationController pushViewController:acvity animated:YES];
        acvity.simpleDic=[_activiryArray objectAtIndex:indexPath.row];
        [acvity release];
    }
}
#pragma mark - Table view delegate

-(UITableViewCell *)trendCellForIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    CouponsTrendsCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell=[[[CouponsTrendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dic=[_activiryArray objectAtIndex:indexPath.row];
    cell.businessHeadImageView.image=nil;
    NSString *url=[dic objectForKey:@"PhotoUrl"];
    NSString *encodeUrl=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.businessHeadImageView setImageWithURL:[NSURL URLWithString:encodeUrl]];
    cell.eventInfoImageView.image=nil;
    NSString *eventUrl=[dic objectForKey:@"PictureUrl"];
    NSString *enEventUrl=[eventUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.eventInfoImageView setImageWithURL:[NSURL URLWithString:enEventUrl]];
    cell.businessNameLabel.text=[dic objectForKey:@"Title"];
    cell.detailInfoLabel.text=[dic objectForKey:@"Content"];
    cell.releaseDateLabel.text=[Tool convertTimestampToNSDate:[[dic objectForKey:@"OpTime"] integerValue]];
    cell.releaseDateLabel.frame=CGRectMake(cell.releaseDateLabel.frame.origin.x, 10.f, cell.releaseDateLabel.frame.size.width, 20.f);
    return cell;
}

-(CGFloat)aboutHeighteForIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            return 85.f;
        }
            break;
        case 1:
        {
            NSString *intro=@"";
            if (_shopDetailInfoDic) {
                intro=[_shopDetailInfoDic objectForKey:@"Content"];
            }
            
            CGSize size=[intro sizeWithFont:COUPONS_TRENDS_CELL_FONT constrainedToSize:CGSizeMake(260.f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
            return size.height+40.f;
        }
            break;
        case 2:
        {
            NSString *openTime=@"";
            if (_shopDetailInfoDic) {
                openTime=[_shopDetailInfoDic objectForKey:@"BusinessHours"];
            }
            CGSize size=[openTime sizeWithFont:COUPONS_TRENDS_CELL_FONT constrainedToSize:CGSizeMake(260.f, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
            return size.height+40.f;
        }
            break;
        default:
            return 0.f;
            break;
    }
}

-(UITableViewCell *)aboutCellForIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            CounponsAboutCell *cell=[[[CounponsAboutCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"About"] autorelease];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            NSString *name=@"";
            NSString *location=@"";
            NSString *phone=@"";
            NSString *photoUrl=nil;
            
            if (_shopDetailInfoDic) {
                name=[_shopDetailInfoDic objectForKey:@"AccountName"];
                location=[_shopDetailInfoDic objectForKey:@"Address"];
                phone=[_shopDetailInfoDic objectForKey:@"Telephone"];
                photoUrl=[_shopDetailInfoDic objectForKey:@"PhotoUrl"];
            }else if(_shopSimpleInfoDic){
                name=[_shopSimpleInfoDic objectForKey:@"AccountName"];
                photoUrl=[_shopSimpleInfoDic objectForKey:@"PhotoUrl"];
            }
            cell.counponsName=name;
            if (photoUrl) {
                NSString *enUrl=[photoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [cell.businessImageView setImageWithURL:[NSURL URLWithString:enUrl] placeholderImage:nil];
            }
            cell.counponsLocation=location;
            cell.counponsTel=phone;
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell *cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"about"] autorelease];
            if (_shopDetailInfoDic) {
                cell.textLabel.text=[_shopDetailInfoDic objectForKey:@"Content"];
            }else
                cell.textLabel.text=@"";
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines=0;
            cell.textLabel.font=COUPONS_TRENDS_CELL_FONT;
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"about"] autorelease];
            if (_shopDetailInfoDic) {
                cell.textLabel.text=@"";
            }else
                cell.textLabel.text=[_shopDetailInfoDic objectForKey:@"BusinessHours"];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.numberOfLines=0;
            cell.textLabel.font=COUPONS_TRENDS_CELL_FONT;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

-(UITableViewCell *)photoCellForIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *photoIdent = @"thumbImage";
    ThumbImageCell *cell = [_tableView dequeueReusableCellWithIdentifier:photoIdent];
    
    if (!cell)
    {
        cell=[[[ThumbImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:photoIdent] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell addTapTarget:self action:@selector(imageViewTapIndex:imageView:)];
    }
    NSInteger location=indexPath.row*4;
    NSInteger length=location+4;
    if (_photoListArray.count<=length) {
        length=_photoListArray.count;
    }
    NSArray *array=[_photoListArray subarrayWithRange:NSMakeRange(location, length)];
    cell.imageSourceArray=array;
    return cell;
}

#pragma mark -RequestDelegate

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg
{
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]done:YES];
    loadMoreView.state=LoadMoreStateNormal;
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{
    
    [[ProgressHUD sharedProgressHUD]hide];
    [self.tableView refreshFinished];
    loadMoreView.state=LoadMoreStateNormal;
    
    if ([request isEqual:detailRequest]) {
        self.shopDetailInfoDic=data;
    }else if ([request isEqual:activityListRequest]){
        if (isRefresh) {
            self.activiryArray=data;
        }else{
            NSMutableArray *tempArray=[NSMutableArray arrayWithArray:_activiryArray];
            [tempArray addObjectsFromArray:data];
            self.activiryArray=tempArray;
            if ([data count]==DEFAULT_REQUEST_PAGE_COUNT) {
                isShowLoadMoreView=NO;
                self.tableView.tableFooterView=nil;
                currentPage=1;
            }else{
                isShowLoadMoreView=YES;
                currentPage++;
                self.tableView.tableFooterView=loadMoreView;
            }
        }
    }else if ([request isEqual:shopPhotoList]){
        self.photoListArray=data;
    }
}
@end
