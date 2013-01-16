//
//  UserProductViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-14.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UserProductViewController.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "UIColor+ColorUtils.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "UserProductCell.h"
#import "UIImageView+WebCache.h"
#import "MemberDetailViewController.h"
#import "LoadMoreView.h"

@interface UserProductViewController (){

    UIImageView *nodataImageView;
    BOOL isRefresh;
    BOOL isUseDoneData;
    BOOL isNotUseDoneData;
    LoadMoreView *loadMoreView;
}
@property (nonatomic,retain)UserProductSegmentControl *segmentControl;

@end

@implementation UserProductViewController

-(void)dealloc{

    [_isUseArray release];
    [_notUserArray release];
    [_segmentControl release];
    [loadMoreView release];
    [super dealloc];
}

-(id)initWithType:(ProductType)type{
    _type=type;
    _isUsed=NO;
    return [super init];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSString *title=nil;
        switch (_type) {
            case ProductTypeMemberCard:
                title=AppLocalizedString(@"我的会员卡");
                break;
            case ProductTypeTicket:
                title=AppLocalizedString(@"我的优惠券");
                break;
            case ProductTypeTuan:
                title=AppLocalizedString(@"我的团购");
            default:
                break;
        }
        self.title=title;
    }
    return self;
}

-(void)loadView{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    UserProductSegmentControl *segment=[[UserProductSegmentControl alloc]initWithType:_type];
    [self.view addSubview:segment];
    [segment addTarget:self action:@selector(selectChange:) forControlEvents:UIControlEventValueChanged];
    self.segmentControl=segment;
    [segment release];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 50.f, self.view.frame.size.width, self.view.frame.size.height-50.f) style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [self.tableView setPullToRefreshHandler:^{
        [self getUserProductListWithPage:1];
    }];
    
    loadMoreView=[[LoadMoreView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 60.f)];
    [loadMoreView setLoadMoreBlock:^{
        
        [self getUserProductListWithPage:_visibleArray.count/DEFAULT_REQUEST_PAGE_COUNT +1];
    }];
    
    [tableView release];
    if (!nodataImageView) {
        nodataImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nodata"]];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavgationTitle:self.title backItemTitle:AppLocalizedString(@"返回")];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    if (self.visibleArray==nil) {
        [self.tableView pullToRefresh];
    }
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self cancelAllRequest];
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    self.segmentControl=nil;
    self.tableView=nil;
    [loadMoreView release];
    loadMoreView=nil;
}

- (void)didReceiveMemoryWarning
{
    // [super didReceiveMemoryWarning];
}

-(void)setIsUsed:(BOOL)isUsed{
    
    if (isUsed==_isUsed) {
        return;
    }
    [self cancelAllRequest];
    [self.tableView refreshFinished];
    
    _isUsed=isUsed;
    if (isUsed) {
        self.visibleArray=_isUseArray;
    }else
        self.visibleArray=_notUserArray;
    [self.tableView reloadData];
    
    if (isUsed) {
        [self setPullToLoadVisible:!isUseDoneData];
    }else
    {
        [self setPullToLoadVisible:!isNotUseDoneData];
    }
    
    if (self.visibleArray==nil) {
        [self.tableView pullToRefresh];
    }
}

-(void)setVisibleArray:(NSArray *)visibleArray{
    
    if ([visibleArray isEqualToArray:_visibleArray]) {
        return;
    }
    [_visibleArray release];
    _visibleArray=[visibleArray retain];
    
    if ([_visibleArray count]==0) {
        [self.tableView addSubview:nodataImageView];
    }else
        [nodataImageView removeFromSuperview];
    [self.tableView reloadData];
}

#pragma mark - Private

-(void)setPullToLoadVisible:(BOOL)visible{

    if (!visible) {
        self.tableView.tableFooterView=nodataImageView;
    }else
    {
        self.tableView.tableFooterView=loadMoreView;
    }
}
#pragma mark -Request And Delegate

-(void)cancelAllRequest{

    if (userProductRequest) {
        [userProductRequest cancel];
        [userProductRequest release];
        userProductRequest=nil;
    }
    loadMoreView.state=LoadMoreStateNormal;
}

-(void)getUserProductListWithPage:(NSInteger)page{

    if (userProductRequest) {
        [userProductRequest cancel];
        [userProductRequest release];
        userProductRequest=nil;
    }
    if (page==1) {
        isRefresh=YES;
    }else
        isRefresh=NO;
    
    NSDictionary *pageDic=[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"%d",page],@"PageIndex",
                            [NSString stringWithFormat:@"%d",DEFAULT_REQUEST_PAGE_COUNT],@"ReturnCount", nil];
    NSString *productText=nil;
    switch (_type) {
        case ProductTypeMemberCard:
            productText=@"H";
            break;
        case ProductTypeTuan:
            productText=@"T";
            break;
        case ProductTypeTicket:
            productText=@"Y";
            break;
        default:
            productText=@"-1";
            break;
    }
    NSString *isUserText=nil;
    if (_isUsed) {
        isUserText=@"1";
    }else
        isUserText=@"0";
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       pageDic,@"Pager",
                       [[SettingManager sharedSettingManager]loggedInAccount],@"AccountId",
                       isUserText,@"IsUsed",
                       @"-1",@"IsPayed",
                       productText,@"ProductType", nil];
    userProductRequest=[[GetLoadUserProductRequest alloc]initWithRequestWithDic:dic];
    userProductRequest.delegate=self;
    loadMoreView.state=LoadMoreStateRequesting;
    [userProductRequest startAsynchronous];
}

//
-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    loadMoreView.state=LoadMoreStateNormal;
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    [self.tableView refreshFinished];
    loadMoreView.state=LoadMoreStateNormal;

    if (isRefresh) {
        if (_isUsed) {
            self.isUseArray=data;
        }else
            self.notUserArray=data;
    }else
    {
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:_visibleArray];
        [tempArray addObjectsFromArray:data];
        if (_isUsed) {
            self.isUseArray=tempArray;
        }else
            self.notUserArray=tempArray;
    }
    if (_isUsed) {
        self.visibleArray=_isUseArray;
    }else
        self.visibleArray=_notUserArray;
    
    if ([data count]==DEFAULT_REQUEST_PAGE_COUNT) {
        [self setPullToLoadVisible:YES];
    }else
    {
        [self setPullToLoadVisible:NO];
        if (_isUsed) {
            isUseDoneData=YES;
        }else
            isNotUseDoneData=YES;
    }
}


-(void)selectChange:(UserProductSegmentControl *)control{

    self.isUsed=control.selectIndex==0?NO:YES;
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
    [cell.productImageView setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"Url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil success:^(UIImage *image,BOOL isCache){
        [Tool setImageView:cell.productImageView toImage:image];
    } failure:nil];
    [cell.productNameLabel setText:[dic objectForKey:@"Name"]];
    [cell.exdateLabel setText:[Tool convertTimestampToNSDate:[[dic objectForKey:@"ExpiredDate"] integerValue]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dic=[_visibleArray objectAtIndex:indexPath.row];
    NSString *className=nil;
    switch (_type) {
        case ProductTypeMemberCard:
            className=@"MemberDetailViewController";
            break;
        case ProductTypeTicket:
            className=@"TicketDetailViewController";
            break;
        case ProductTypeTuan:
            className=@"TuanDetailViewController";
            break;
        default:
            break;
    }
    
    MemberDetailViewController *userProduct=[[NSClassFromString(className) alloc]init];
    userProduct.simpleInfoDic=dic;
    [self.navigationController pushViewController:userProduct animated:YES];
    userProduct.canBuy=NO;
    [userProduct release];
}
@end


@implementation UserProductSegmentControl

-(id)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    
    if (self) {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
    }
    return self;
}

-(id)initWithType:(ProductType)type{

    self=[self initWithFrame:CGRectMake(0.f, 0.f, 320.f, 50.f)];
    if (self) {
        
        UIButton *notUseBtn=[self btnWithPosition:CGPointMake(0.f, 0.f)];
        notUseBtn.tag=1;
        [self addSubview:notUseBtn];
        
        UIButton *useBtn=[self btnWithPosition:CGPointMake(notUseBtn.frame.size.width, 0.f)];
        useBtn.tag=2;
        [self addSubview:useBtn];
        
        NSString *notUserTitle=nil;
        NSString *userTitle=nil;
        switch (type) {
            case ProductTypeMemberCard:
            {
                notUserTitle=[NSString stringWithFormat:AppLocalizedString(@"有效的Product"),AppLocalizedString(@"会员卡")];
                userTitle=[NSString stringWithFormat:AppLocalizedString(@"已过期的Product"),AppLocalizedString(@"会员卡")];
                
            }
                break;
            case ProductTypeTicket:
            {
                notUserTitle=[NSString stringWithFormat:AppLocalizedString(@"有效的Product"),AppLocalizedString(@"优惠券")];
                userTitle=[NSString stringWithFormat:AppLocalizedString(@"已过期的Product"),AppLocalizedString(@"优惠券")];
            }
                break;
            case ProductTypeTuan:
            {
                notUserTitle=[NSString stringWithFormat:AppLocalizedString(@"有效的Product"),AppLocalizedString(@"团购")];
                userTitle=[NSString stringWithFormat:AppLocalizedString(@"已过期的Product"),AppLocalizedString(@"团购")];
            }
                break;
            default:
                break;
        }
        [notUseBtn setTitle:notUserTitle forState:UIControlStateNormal];
        [useBtn setTitle:userTitle forState:UIControlStateNormal];
     
        self.selectIndex=0;
    }
    return self;
}

-(UIButton *)btnWithPosition:(CGPoint)point{
    UIColor *normalTitlColor=[UIColor colorWithString:@"#605D58"];
    UIColor *hightedTitleColor=[UIColor colorWithString:@"#FFFFFF"];
    UIColor *shawnColorOne=[UIColor colorWithString:@"#414141"];
    UIColor *shawnColorTwo=[UIColor colorWithString:@"#FFFFFF"];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:normalTitlColor forState:UIControlStateNormal];
    [btn setTitleColor:hightedTitleColor forState:UIControlStateSelected];
    [btn setTitleShadowColor:shawnColorTwo forState:UIControlStateNormal];
    [btn setTitleShadowColor:shawnColorOne forState:UIControlStateSelected];
    UIImage *normalImg=[UIImage imageNamed:@"label"];
    UIImage *hightedImg=[UIImage imageNamed:@"label_hot"];
    [btn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [btn setBackgroundImage:hightedImg forState:UIControlStateSelected];
    [btn sizeToFit];
    btn.titleLabel.shadowOffset=CGSizeMake(0.f, 1.f);
    btn.titleLabel.font=[UIFont systemFontOfSize:16.f];
    btn.frame=CGRectMake(point.x, point.y, btn.frame.size.width, btn.frame.size.height);
    [btn addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
@end