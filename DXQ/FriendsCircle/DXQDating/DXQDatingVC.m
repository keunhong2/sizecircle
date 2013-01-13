//
//  DXQDatingVC.m
//  DXQ
//
//  Created by Yuan on 12-10-23.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "DXQDatingVC.h"
#import "UIImageView+WebCache.h"
#import "NearByListCell.h"
#import "CustomSearchBar.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "UserLoadUserListRequest.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "RelationMakeRequest.h"
#import "UserRemoveRelation.h"
#import "EditUserInfoVC.h"
#import "DatingFilterVC.h"

@interface DXQDatingVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,FriendsCircleRequestDelegate,RelationMakeRequestDelegate,UserRemoveRelationDelegate>
{
    NSMutableArray *datingList;
    
    UITableView *tableView;
    
    BOOL isUserLoadUserListRequesting;
    
    BOOL isCompleted;
    
    UserLoadUserListRequest *userLoadUserListRequest;
    
    BOOL isRequesting;
    
    RelationType relationType;
    
    RelationMakeRequest *relationMakeRequest;
    
    UserRemoveRelation  *userRemoveRelationRequest;
    
    NSInteger cIndexPath;
}

@property (nonatomic,retain)NSMutableArray *datingList;

@property (nonatomic,retain)UITableView *tableView;

@end

@implementation DXQDatingVC
@synthesize datingList = _datingList;
@synthesize tableView = _tableView;


-(void)dealloc
{
    [_datingList release];_datingList = nil;

    [_tableView release];_tableView = nil;
    
    [super dealloc];
}

-(void)viewDidUnload
{
    self.tableView = nil;
            
    [super viewDidUnload];
}



- (id)init
{
    self = [super init];
    if (self)
    {
        _datingList = [[NSMutableArray alloc]init];
        //        for (int i = 0 ; i < 20; i++)
        //        {
        //            NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:@"http://www.51netu.com/uploads/100428/1767_093618_1.jpg",@"imageurl",@"凤姐",@"username",@"修勇我喜欢你...",@"status", nil];
        //            [datingList addObject:item];
        //        }
    }
    return self;
}

-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    [self.navigationItem setTitle:AppLocalizedString(@"圈圈相亲")];

    //custom segment
    /*
    NSDictionary *item1 = [NSDictionary dictionaryWithObjectsAndKeys:@"列表",@"title",@"pyq_l",@"img", nil];
    NSDictionary *item2 = [NSDictionary dictionaryWithObjectsAndKeys:@"宫格",@"title",@"pyq_r",@"img", nil];
    NSArray *items = [NSArray arrayWithObjects:item1,item2, nil];
    CustomSegmentedControl *segment = [[CustomSegmentedControl alloc]initWithFrame:CGRectZero items:items defaultSelectIndex:0];
    segment.delegate = self;
    self.navigationItem.titleView=segment;
    [segment release];
     */
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, 320,416)];
	_tableView.delegate = self;
	_tableView.dataSource = self;
    [_tableView setSeparatorColor:TABLEVIEW_SEPARATORCOLOR];
    _tableView.backgroundColor=[UIColor whiteColor];
    [_tableView setRowHeight:480.0f];
//    [_tableView setContentInset:UIEdgeInsetsMake(44.0,0, 0, 0)];
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.tableFooterView = footer;
    [footer release];
    [self.view addSubview:_tableView];
    
    [_tableView setPullToRefreshHandler:^{
        [self getDatingList];
    }];
    [_tableView pullToRefresh];

    /*
    CustomSearchBar *searchBar=[[CustomSearchBar alloc]initWithFrame:CGRectMake(0.f, -44.0, self.view.frame.size.width, 44.f)];
    [self.view addSubview:searchBar];
    searchBar.placeholder=AppLocalizedString(@"搜索");
    searchBar.delegate=self;
    searchBar.showsCancelButton = NO;
    [_tableView addSubview:searchBar];
    [searchBar release];
     */
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
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)getDatingList
{
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
    [parametersDic setObject:[[SettingManager sharedSettingManager]loggedInAccount] forKey:@"AccountId"];
    [parametersDic setObject:@"-1" forKey:@"Sex"];
    [parametersDic setObject:@"-1" forKey:@"LogInDate"];
    [parametersDic setObject:@"-1" forKey:@"MaxAge"];
    [parametersDic setObject:@"-1" forKey:@"MinAge"];
    [parametersDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"PageIndex",@"200",@"ReturnCount", nil] forKey:@"Pager"];
    [parametersDic setObject:@"0.0" forKey:@"JingDu"];
    [parametersDic setObject:@"0.0" forKey:@"WeiDu"];
    isUserLoadUserListRequesting = YES;
    userLoadUserListRequest = [[UserLoadUserListRequest alloc]initWithRequestWithDic:parametersDic ];
    userLoadUserListRequest.delegate = self;
    [userLoadUserListRequest startAsynchronous];
}



-(void)friendsCircleRequestRequest:(FriendsCircleRequest *)request didFailedWithErrorMsg:(NSString *)msg
{
    isUserLoadUserListRequesting = NO;

    if ([userLoadUserListRequest isEqual:request])
    {
        [_tableView refreshFinished];
        [userLoadUserListRequest release];userLoadUserListRequest = nil;
    }
    
}

-(void)friendsCircleRequestRequest:(FriendsCircleRequest *)request didFinishWithData:(id)data
{
    isUserLoadUserListRequesting = NO;
    HYLog(@"%@",data);
    if ([userLoadUserListRequest isEqual:request])
    {
        NSDictionary *friends = (NSDictionary *)data;
        if (friends && [friends isKindOfClass:[NSDictionary class]] && [friends count]>0)
        {
            isCompleted  = [[friends objectForKey:@"Completed"] boolValue];
            [_datingList removeAllObjects];
            [_datingList addObjectsFromArray:[friends objectForKey:@"List"]];
            [_tableView reloadData];
        }
        [_tableView refreshFinished];
        [userLoadUserListRequest release];userLoadUserListRequest = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (isUserLoadUserListRequesting &&userLoadUserListRequest)
    {
        [userLoadUserListRequest cancel];
    }
    [super viewWillDisappear:animated];
}



-(void)filterAction:(UIButton*)sender
{
    DatingFilterVC *vc = [[DatingFilterVC alloc]initWithDelegate:self];
    CustonNavigationController *nav = [[CustonNavigationController alloc]initWithRootViewController:vc];
    [self.navigationController presentModalViewController:nav animated:YES];
    [vc release];
    [nav release];
}


-(void)setCurrentSegmentType:(SegmentType)type_
{
    HYLog(@"%d",type_);
}

#pragma mark
#pragma CustomSegmentedControl Methord
-(void)didSelectIndex:(NSUInteger)selectedIndex withSegmentControl:(CustomSegmentedControl*)segmentControl;
{
    [self setCurrentSegmentType:selectedIndex];
}


#pragma mark UISearchBarDelegate Methord
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar_                   // called when text starts editing
{
    searchBar_.showsCancelButton = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar_
{
}

- (void)searchBar:(UISearchBar *)searchBar_ textDidChange:(NSString *)searchText   // called when text changes (including clear)
{
    //    YKLog(@"%@",searchText);
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_
{
    [searchBar_ resignFirstResponder];
    //不需禁用cancel按钮
    UIButton *cancelbtn;
    object_getInstanceVariable(searchBar_,"_cancelButton",(void*)&cancelbtn);
    [cancelbtn setEnabled:YES];
}

// called when cancel button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar_
{
    searchBar_.text = @"";
    searchBar_.showsCancelButton = NO;
    [searchBar_ resignFirstResponder];
}


#pragma mark -UITableViewDataSourceAndDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //for test
    return [_datingList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self ListCellForIndexPath:indexPath];
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!isCompleted)
    {
        [self editAction];
    }
}

-(UITableViewCell *)ListCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"NearByListCell";
    NearByListCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[NearByListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setFrame:CGRectMake(0, 0, 40,30)];
        [btn addTarget:self action:@selector(anLian:) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitle:AppLocalizedString(@"暗恋") forState:UIControlStateNormal];
        cell.accessoryView = btn;
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *item = [_datingList objectAtIndex:indexPath.row];
    NSString *picurl = [NSString stringWithFormat:@"%@%@",[item objectForKey:@"PhotoUrl"],THUMB_IMAGE_SUFFIX];
    if (!picurl)picurl = @"";
    [cell.avatarImg setImageWithURL:[NSURL URLWithString:[picurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]placeholderImage:[UIImage imageNamed:@"tx_gray.png"]];
    cell.usernameLbl.text = [item objectForKey:@"MemberName"];
    NSString  *ageImgName = ([[item objectForKey:@"Sex"] intValue]==0)?@"pyq_girl.png":@"pyq_boy.png";
    cell.ageImg.image = [UIImage imageNamed:ageImgName];
    cell.ageLbl.text = [[item objectForKey:@"Age"] stringValue];
    NSString *online = [[item objectForKey:@"IsOnline"] intValue]==0?AppLocalizedString(@"当前不在线"):AppLocalizedString(@"当前在线");
    cell.distanceLbl.text = [NSString stringWithFormat:@"%@  |  %@",[[GPS gpsManager] getDistanceFromLat:[item objectForKey:@"WeiDu"] Lon:[item objectForKey:@"JingDu"]],online];
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
    
    UIButton *btn  = (UIButton *)cell.accessoryView;
    
    if ([[item objectForKey:@"IsLove"] boolValue])
    {
//        [btn setTitle:AppLocalizedString(@"取消") forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_heart_useless"] forState:UIControlStateNormal];
    }
    else
    {
//        [btn setTitle:AppLocalizedString(@"暗恋") forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_heart"] forState:UIControlStateNormal];
    }
    return cell;
}

-(void)anLian:(UIButton *)btn
{
    if (!isCompleted)
    {
        return   [self editAction];
    }
    
    NearByListCell *cell = (NearByListCell *)btn.superview;
    
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
     cIndexPath = indexPath.row;
    
    NSDictionary *item = [_datingList objectAtIndex:cIndexPath];
    
    if ([[item objectForKey:@"IsLove"] boolValue])
    {
        [self handleRemoveUserRelationWithType:RelationTypeHiddenFans withAccountToID:[item objectForKey:@"AccountId"]];
    }
    else
    {
        [self handleCreateUserRelationWithType:RelationTypeHiddenFans withAccountToID:[item objectForKey:@"AccountId"]];
    }
}

-(void)editAction
{
    EditUserInfoVC *vc = [[EditUserInfoVC alloc]initWithDelegate:self];
    CustonNavigationController *nav = [[CustonNavigationController alloc]initWithRootViewController:vc];
    [[AppDelegate sharedAppDelegate].menuController presentModalViewController:nav animated:YES];
    [vc release];
    [nav release];
}

#pragma mark
#pragma UniversalViewControlDelegate Methord
-(void)didCancelViewViewController
{
    [[AppDelegate sharedAppDelegate].menuController  dismissModalViewControllerAnimated:YES];
}

-(void)didFinishedAction:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[EditUserInfoVC class]])
    {
        [_tableView performSelector:@selector(pullToRefresh) withObject:nil afterDelay:0.1];
        [self didCancelViewViewController];
    }
    else
    {
        [self didCancelViewViewController];
    }
}

//添加用户关系
//-1黑名单，0关注，1暗恋，2好友
-(void)handleCreateUserRelationWithType:(RelationType)type withAccountToID:(NSString *)toid
{
    if (isRequesting)return;
    isRequesting = YES;
    relationType = type;
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理...")];
    [[ProgressHUD sharedProgressHUD]showInView:self.navigationController.view];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[SettingManager sharedSettingManager]loggedInAccount],@"AccountFrom",
                       toid,@"AccountTo",
                       [NSString stringWithFormat:@"%d",relationType],@"Relation", nil];
    relationMakeRequest=[[RelationMakeRequest alloc]initRequestWithDic:dic];
    relationMakeRequest.delegate=self;
    [relationMakeRequest startAsynchronous];
}

#pragma RelationMakeRequestDelegate methord
-(void)relationMakeRequestDidFinishedWithParamters:(NSDictionary *)dic
{
    [self updateItemWithValue:@"1"];
    isRequesting = NO;
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"添加暗恋成功!")];
    [[ProgressHUD sharedProgressHUD]done:YES];
    [relationMakeRequest release];relationMakeRequest = nil;
}

-(void)relationMakeRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    isRequesting = NO;
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"添加暗恋失败!")];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [relationMakeRequest release];relationMakeRequest = nil;
}

//删除用户关系
//-1黑名单，0关注，1暗恋，2好友
-(void)handleRemoveUserRelationWithType:(RelationType)type  withAccountToID:(NSString *)toid
{
    if (isRequesting)return;
    isRequesting = YES;
    relationType = type;
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理...")];
    [[ProgressHUD sharedProgressHUD]showInView:self.navigationController.view];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[SettingManager sharedSettingManager]loggedInAccount],@"AccountFrom",
                       toid,@"AccountTo",
                       [NSString stringWithFormat:@"%d",type],@"Relation", nil];
    userRemoveRelationRequest=[[UserRemoveRelation alloc]initRequestWithDic:dic];
    userRemoveRelationRequest.delegate=self;
    [userRemoveRelationRequest startAsynchronous];
}

#pragma UserRemoveRelationDelegate methord
-(void)userRemoveRelationDidFinishedWithParamters:(NSDictionary *)dic
{
    [self updateItemWithValue:@"0"];
    isRequesting = NO;
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"取消暗恋成功!")];
    [[ProgressHUD sharedProgressHUD]done:YES];
    [userRemoveRelationRequest release];userRemoveRelationRequest = nil;
}

-(void)userRemoveRelationDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    isRequesting = NO;
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"取消暗恋失败!")];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [userRemoveRelationRequest release];userRemoveRelationRequest = nil;
}

-(void)updateItemWithValue:(NSString *)value
{
    NSMutableDictionary *ritem = [[NSMutableDictionary alloc]initWithDictionary:[_datingList objectAtIndex:cIndexPath]];
    [ritem setObject:value forKey:@"IsLove"];
    [_datingList replaceObjectAtIndex:cIndexPath withObject:ritem];
    [ritem release];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
