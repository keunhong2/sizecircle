//
//  MyFriendsVC.m
//  DXQ
//
//  Created by Yuan on 12-10-23.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "MyFriendsVC.h"
#import "HistoryTableViewDataSource.h"
#import "FriendsTableViewDataSource.h"
#import "AddressBookTableViewDataSource.h"
#import "UserLoadFriendListRequest.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "UserDetailInfoVC.h"
#import "ChatVC.h"
#import "ChatMessageCenter.h"

@interface MyFriendsVC ()<FriendsCircleRequestDelegate>
{
    
    BOOL isUserLoadFriendListRequesting;
    
    UserLoadFriendListRequest *userLoadFriendListRequest;

}

@property (nonatomic,retain)UITableView *historyTableView;
@property (nonatomic,retain)UITableView *friendsTableView;
@property (nonatomic,retain)UITableView *addressbookTableView;
@property (nonatomic,retain)HistoryTableViewDataSource *historyTableViewDataSource;
@property (nonatomic,retain)FriendsTableViewDataSource *friendsTableViewDataSource;
@property (nonatomic,retain)AddressBookTableViewDataSource *addressBookTableViewDataSource;
@property (nonatomic)NSUInteger showType;
@end

@implementation MyFriendsVC
@synthesize historyTableView = _historyTableView;
@synthesize friendsTableView = _friendsTableView;
@synthesize addressbookTableView = _addressbookTableView;
@synthesize historyTableViewDataSource = _historyTableViewDataSource;
@synthesize friendsTableViewDataSource = _friendsTableViewDataSource;
@synthesize addressBookTableViewDataSource = _addressBookTableViewDataSource;
@synthesize showType = _showType;

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DXQChatMessageGetNewMessage object:nil];
    [_historyTableView release];_historyTableView = nil;
    
    [_friendsTableView release];_friendsTableView = nil;
    
    [_addressbookTableView release];_addressbookTableView = nil;

    [_historyTableViewDataSource release];_historyTableViewDataSource = nil;
    
    [_friendsTableViewDataSource release];
    _friendsTableViewDataSource = nil;
    
    [_addressBookTableViewDataSource release];
    _addressBookTableViewDataSource = nil;
    
    [super dealloc];
}

-(void)viewDidUnload
{
    self.friendsTableView = nil;
    
    self.addressbookTableView = nil;
    
    self.historyTableView = nil;
    
    [super viewDidUnload];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _historyTableViewDataSource = [[HistoryTableViewDataSource alloc]initWithViewControl:self];

        _friendsTableViewDataSource = [[FriendsTableViewDataSource alloc]initWithViewControl:self];

        _addressBookTableViewDataSource = [[AddressBookTableViewDataSource alloc]initWithViewControl:self];
        
        _showType = 0;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadChatMsgData) name:DXQChatMessageGetNewMessage object:nil];
    }
    return self;
}

-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    //custom segment
    NSDictionary *item1 = [NSDictionary dictionaryWithObjectsAndKeys:@"会话",@"title",@"pyq_l",@"img", nil];
//    NSDictionary *item2 = [NSDictionary dictionaryWithObjectsAndKeys:@"好友",@"title",@"pyq_m",@"img", nil];
//    NSDictionary *item3 = [NSDictionary dictionaryWithObjectsAndKeys:@"通讯录",@"title",@"pyq_r",@"img", nil];
    NSDictionary *item2 = [NSDictionary dictionaryWithObjectsAndKeys:@"好友",@"title",@"pyq_r",@"img", nil];

    NSArray *items = [NSArray arrayWithObjects:item1,item2, nil];
    CustomSegmentedControl *segment = [[CustomSegmentedControl alloc]initWithFrame:CGRectZero items:items defaultSelectIndex:0];
    segment.delegate = self;
    self.navigationItem.titleView=segment;
    [segment release];
    
    [self.view insertSubview:[self historyTableView] atIndex:0];
}

- (void)viewDidLoad
{
    [self showRightButton:YES title:AppLocalizedString(@"编辑")];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)reloadChatMsgData{

    [self.historyTableView reloadData];
}

-(void)showRightButton:(BOOL)isshow title:(NSString *)title
{
    if (isshow)
    {
        UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
        UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
        [rightBtn sizeToFit];
        [rightBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitle:title forState:UIControlStateNormal];
        [rightBtn.titleLabel setFont:MiddleBoldDefaultFont];
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem=rightItem;
        [rightItem release];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.historyTableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (isUserLoadFriendListRequesting &&userLoadFriendListRequest)
    {
        [userLoadFriendListRequest cancel];
    }
    [super viewWillDisappear:animated];
}

-(void)startRefreshHistory
{
    [_historyTableViewDataSource reloadData:_historyTableView];
    [_historyTableView refreshFinished];
}

-(void)startRefreshFriends
{
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
    [parametersDic setObject:@"0" forKey:@"FriendType"];
    [parametersDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"PageIndex",@"200",@"ReturnCount", nil] forKey:@"Pager"];
    [parametersDic setObject:[[SettingManager sharedSettingManager]loggedInAccount] forKey:@"AccountId"];
    isUserLoadFriendListRequesting = YES;
    userLoadFriendListRequest = [[UserLoadFriendListRequest alloc]initWithRequestWithDic:parametersDic ];
    userLoadFriendListRequest.delegate = self;
    [userLoadFriendListRequest startAsynchronous];
}


-(void)startRefreshAddressbook
{
    
}

-(void)friendsCircleRequestRequest:(FriendsCircleRequest *)request didFailedWithErrorMsg:(NSString *)msg
{
    isUserLoadFriendListRequesting = NO;
    if ([userLoadFriendListRequest isEqual:request])
    {
        [_friendsTableView refreshFinished];
        [userLoadFriendListRequest release];userLoadFriendListRequest = nil;
    }
    
}

-(void)friendsCircleRequestRequest:(FriendsCircleRequest *)request didFinishWithData:(id)data
{
    HYLog(@"%@",data);
    isUserLoadFriendListRequesting = NO;

    if ([userLoadFriendListRequest isEqual:request])
    {
        NSArray *friends = (NSArray *)data;
        if (friends && [friends isKindOfClass:[NSArray class]] && [friends count]>0)
        {
            [_friendsTableViewDataSource reloadData:friends tableView:_friendsTableView];
        }
        [_friendsTableView refreshFinished];
        [userLoadFriendListRequest release];userLoadFriendListRequest = nil;
    }
}

-(UITableView *)historyTableView
{
    if (!_historyTableView)
    {
        _historyTableView= [self createNewTableViewWithDelegate:_historyTableViewDataSource];
        [_historyTableView setPullToRefreshHandler:^{
            [self startRefreshHistory];
        }];
        [_historyTableView pullToRefresh];
    }
    return _historyTableView;
}


-(UITableView *)friendsTableView
{
    if (!_friendsTableView)
    {
        _friendsTableView= [self createNewTableViewWithDelegate:_friendsTableViewDataSource];
        [_friendsTableView setPullToRefreshHandler:^{
            [self startRefreshFriends];
        }];
        [_friendsTableView pullToRefresh];
    }
    return _friendsTableView;
}

-(UITableView *)addressbookTableView
{
    if (!_addressbookTableView)
    {
        _addressbookTableView= [self createNewTableViewWithDelegate:_addressBookTableViewDataSource];
        [_addressbookTableView setPullToRefreshHandler:^{
            [self startRefreshAddressbook];
        }];
    }
    return _addressbookTableView;
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

-(void)editAction:(UIButton*)sender
{
    if (!_historyTableView.editing)
    {
        [self showRightButton:YES title:AppLocalizedString(@"完成")];
    }
    else
    {
        [self showRightButton:YES title:AppLocalizedString(@"编辑")];
    }
    _historyTableView.editing = !_historyTableView.editing;
}

-(void)setCurrentSegmentType:(NSUInteger)type_
{
    if (self.showType == type_) return;
    
    [self.view.superview setBackgroundColor:[UIColor viewFlipsideBackgroundColor]];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	[UIView commitAnimations];
    
    _historyTableView.editing = NO;
    _showType=type_;

    if (type_ == 0)
    {
        [self showRightButton:YES title:AppLocalizedString(@"编辑")];
        [self.friendsTableView removeFromSuperview];
        [self.addressbookTableView removeFromSuperview];
        [self.view insertSubview:[self historyTableView] atIndex:0];
    }
    else if(type_ == 1)
    {
        [self showRightButton:NO title:nil];
        [self.historyTableView removeFromSuperview];
        [self.addressbookTableView removeFromSuperview];
        [self.view insertSubview:[self friendsTableView] atIndex:0];
    }
    else if(type_ == 1)
    {
        [self showRightButton:NO title:nil];
        [self.historyTableView removeFromSuperview];
        [self.friendsTableView removeFromSuperview];
        [self.view insertSubview:[self addressbookTableView] atIndex:0];
    }
}

#pragma mark
#pragma CustomSegmentedControl Methord
-(void)didSelectIndex:(NSUInteger)selectedIndex withSegmentControl:(CustomSegmentedControl*)segmentControl;
{
    [self setCurrentSegmentType:selectedIndex];
}


-(void)viewUserDetailInfo:(NSDictionary *)info
{
    UserDetailInfoVC *vc=[[UserDetailInfoVC alloc]initwithUserInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

-(void)chatWithUserInfo:(NSDictionary *)info
{
    ChatVC *vc=[[ChatVC alloc]initWithInfo:info];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}


- (void)didReceiveMemoryWarning
{
    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
