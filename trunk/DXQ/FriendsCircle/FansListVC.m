//
//  FansListVC.m
//  DXQ
//
//  Created by Yuan on 12-10-20.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "FansListVC.h"
#import "UserLoadFriendListRequest.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "FriendsListCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UserDetailInfoVC.h"

@interface FansListVC ()<FriendsCircleRequestDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (nonatomic,retain)UITableView *fansTableView;

@property (retain, nonatomic)NSMutableArray  *data;

@end

@implementation FansListVC
@synthesize fansTableView = _fansTableView;
@synthesize data = _data;


-(void)dealloc
{
    [_fansTableView release];_fansTableView = nil;
    [_data release];_data = nil;

    [super dealloc];
}

-(void)viewDidUnload
{
    self.fansTableView = nil;
    
    [super viewDidUnload];
}

-(id)initWithAccountID:(NSString *)accountID_
{
    if(self = [super init])
    {        
        _data = [[NSMutableArray alloc]init];
        
        accountID = accountID_;
    }
    return self;
}

-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    [self.view insertSubview:[self fansTableView] atIndex:0];
}


-(UITableView *)createNewTableViewWithDelegate:(id)delegate
{
    UITableView *newTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [newTableView setSeparatorColor:TABLEVIEW_SEPARATORCOLOR];
    newTableView.backgroundColor=[UIColor whiteColor];
    newTableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    newTableView.delegate=delegate;
    newTableView.dataSource=delegate;
    return newTableView;
}

-(UITableView *)fansTableView
{
    if (!_fansTableView)
    {
        _fansTableView= [self createNewTableViewWithDelegate:self];
        [_fansTableView setPullToRefreshHandler:^{
            [self startRefreshFriends];
        }];
        [_fansTableView pullToRefresh];
    }
    return _fansTableView;
}

- (void)viewDidLoad
{
    [self setNavgationTitle:AppLocalizedString(@"粉丝") backItemTitle:AppLocalizedString(@"返回")];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void)startRefreshFriends
{
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
    [parametersDic setObject:@"2" forKey:@"FriendType"];
    [parametersDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"PageIndex",@"200",@"ReturnCount", nil] forKey:@"Pager"];
    [parametersDic setObject:accountID forKey:@"AccountId"];
    isUserLoadFriendListRequesting = YES;
    userLoadFriendListRequest = [[UserLoadFriendListRequest alloc]initWithRequestWithDic:parametersDic ];
    userLoadFriendListRequest.delegate = self;
    [userLoadFriendListRequest startAsynchronous];
}


-(void)friendsCircleRequestRequest:(FriendsCircleRequest *)request didFailedWithErrorMsg:(NSString *)msg
{
    if ([userLoadFriendListRequest isEqual:request])
    {
        [_fansTableView refreshFinished];

        [userLoadFriendListRequest release];userLoadFriendListRequest = nil;
    }
    
}

-(void)friendsCircleRequestRequest:(FriendsCircleRequest *)request didFinishWithData:(id)data
{
    HYLog(@"%@",data);
    if ([userLoadFriendListRequest isEqual:request])
    {
        NSArray *friends = (NSArray *)data;
        if (friends && [friends isKindOfClass:[NSArray class]] && [friends count]>0)
        {
            [self reloadData:friends];
        }
        [_fansTableView refreshFinished];

        [userLoadFriendListRequest release];userLoadFriendListRequest = nil;
    }
}

-(void)reloadData:(NSArray *)arr
{
    [_data removeAllObjects];
    [_data addObjectsFromArray:arr];
    [_fansTableView reloadData];
}


#pragma mark -UITableViewDataSourceAndDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //for test
    return [_data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self ListCellForIndexPath:indexPath withTableView:tableView];
}

-(UITableViewCell *)ListCellForIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView
{
    static NSString *cellIdentifier=@"NearByListCell";
    FriendsListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[FriendsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *item = [_data objectAtIndex:indexPath.row];
    NSString *picurl = [NSString stringWithFormat:@"%@%@",[item objectForKey:@"PhotoUrl"],THUMB_IMAGE_SUFFIX];
    if (!picurl)picurl = @"";
    [cell.avatarImg setImageWithURL:[NSURL URLWithString:[picurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]placeholderImage:[UIImage imageNamed:@"tx_gray.png"]];
    [cell.avatarImg addTarget:self action:@selector(viewUserDetailInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.usernameLbl.text = [item objectForKey:@"MemberName"];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = [_data objectAtIndex:indexPath.row];
    UserDetailInfoVC *vc=[[UserDetailInfoVC alloc]initwithUserInfo:item];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];    
}


- (void)didReceiveMemoryWarning
{
//    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
