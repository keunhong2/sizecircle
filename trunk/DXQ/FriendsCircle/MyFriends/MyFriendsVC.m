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
#import "CustomSearchBar.h"
#import "BlindTelPhoneView.h"
#import "VerCodeInputView.h"
#import <AddressBook/AddressBook.h>
#import "UserUploadAddressBook.h"
#import "Contact.h"

@interface MyFriendsVC ()<FriendsCircleRequestDelegate,UISearchBarDelegate,BlindTelPhoneDelegate,VerCodeInputViewDelegate,BusessRequestDelegate>
{
    
    NSMutableArray *allContact;
    
    BOOL isUserLoadFriendListRequesting;
    
    UserLoadFriendListRequest *userLoadFriendListRequest;

    UserUploadAddressBook *uploadAddressBook;
    CustomSearchBar *friendSearchBar;
    BOOL firendIsRequest;
    BlindTelPhoneView *bindView;
    VerCodeInputView *verCodeView;
}

@property (nonatomic,retain)UITableView *historyTableView;
@property (nonatomic,retain)UITableView *friendsTableView;
@property (nonatomic,retain)UITableView *addressbookTableView;
@property (nonatomic,retain)HistoryTableViewDataSource *historyTableViewDataSource;
@property (nonatomic,retain)FriendsTableViewDataSource *friendsTableViewDataSource;
@property (nonatomic,retain)AddressBookTableViewDataSource *addressBookTableViewDataSource;
@property (nonatomic)NSUInteger showType;
@property (nonatomic,retain)NSArray *friendList;
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
    [allContact release];
    [_historyTableView release];_historyTableView = nil;
    
    [_friendsTableView release];_friendsTableView = nil;
    
    [_addressbookTableView release];_addressbookTableView = nil;

    [_historyTableViewDataSource release];_historyTableViewDataSource = nil;
    
    [_friendsTableViewDataSource release];
    _friendsTableViewDataSource = nil;
    
    [_addressBookTableViewDataSource release];
    _addressBookTableViewDataSource = nil;
    [friendSearchBar release];
    [_friendList release];
    [bindView release];
    [verCodeView release];
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
        allContact=[NSMutableArray new];
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
    NSDictionary *item2 = [NSDictionary dictionaryWithObjectsAndKeys:@"好友",@"title",@"pyq_m",@"img", nil];
    NSDictionary *item3 = [NSDictionary dictionaryWithObjectsAndKeys:@"通讯录",@"title",@"pyq_r",@"img", nil];
//    NSDictionary *item2 = [NSDictionary dictionaryWithObjectsAndKeys:@"好友",@"title",@"pyq_r",@"img", nil];

    NSArray *items = [NSArray arrayWithObjects:item1,item2,item3, nil];
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
    [self getPoepleListFromAddress];
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

    friendSearchBar.text=@"";
    if ([userLoadFriendListRequest isEqual:request])
    {
        NSArray *friends = (NSArray *)data;
        if (friends && [friends isKindOfClass:[NSArray class]] && [friends count]>0)
        {
            self.friendList=friends;
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
        
        friendSearchBar=[[CustomSearchBar alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 44.f)];
        friendSearchBar.delegate=self;
        _friendsTableView.tableHeaderView=friendSearchBar;
//        [_friendsTableView pullToRefresh];
    }
    return _friendsTableView;
}

-(UITableView *)addressbookTableView
{
    if (!_addressbookTableView)
    {
        _addressbookTableView= [self createNewTableViewWithDelegate:_addressBookTableViewDataSource];
        DXQAccount *currentUser=[[DXQCoreDataManager sharedCoreDataManager]getCurrentLoggedInAccount];
        if (currentUser.dxq_Telephone.length==0) {
            bindView=[[BlindTelPhoneView alloc]initWithFrame:_addressbookTableView.bounds];
            [_addressbookTableView addSubview:bindView];
            bindView.delegate=self;
        }else
        {
            [self getPoepleListFromAddress];
        }
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
        if (!firendIsRequest) {
            [[self friendsTableView]pullToRefresh];
            firendIsRequest=YES;
        }
    }
    else if(type_ == 2)
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
#pragma mark -
#pragma mark -SearchBarDelegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *tempNewArray=[NSMutableArray array];
    for (int i=0; i<_friendList.count; i++) {
        NSDictionary *dic=[_friendList objectAtIndex:i];
        if ([[dic objectForKey:@"MemberName"] rangeOfString:searchText].length==searchText.length) {
            [tempNewArray addObject:dic];
        }
    }
    [_friendsTableViewDataSource reloadData:tempNewArray tableView:_friendsTableView];
}

#pragma mark - 

-(void)binldTelPhoneView:(BlindTelPhoneView *)view didFinishSendPhone:(NSString *)phone
{
    if (!verCodeView) {
        verCodeView=[[VerCodeInputView alloc]initWithFrame:self.addressbookTableView.bounds];
        verCodeView.delegate=self;
    }
    verCodeView.phone=phone;
    [self.addressbookTableView addSubview:verCodeView];
}

-(void)cancelVerCodeInputView:(VerCodeInputView *)view
{
    [view removeFromSuperview];
}

-(void)finishVerCodeInputView:(VerCodeInputView *)view
{
    DXQAccount *currentUser=[[DXQCoreDataManager sharedCoreDataManager]getCurrentLoggedInAccount];
    currentUser.dxq_Telephone=verCodeView.phone;
    [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
    [verCodeView removeFromSuperview];
    [bindView removeFromSuperview];
    
}

#pragma mark -request

-(void)clearUploadRequest
{
    if (uploadAddressBook) {
        [uploadAddressBook cancel];
        [uploadAddressBook release];
        uploadAddressBook=nil;
        [self.addressbookTableView refreshFinished];
    }
}

-(void)uploadAddressArray:(NSArray *)array
{
    [self clearUploadRequest];
    NSString *logID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:logID,@"AccountId",array,@"Phones", nil];
    uploadAddressBook=[[UserUploadAddressBook alloc]initWithRequestWithDic:dic];
    uploadAddressBook.delegate=self;
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
    [[ProgressHUD sharedProgressHUD]setText:@"上传通讯录中..."];
    [uploadAddressBook startAsynchronous];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    if (request==uploadAddressBook) {
        [self clearUploadRequest];
        [[ProgressHUD sharedProgressHUD]setText:msg];
        [[ProgressHUD sharedProgressHUD]done:NO];
    }
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data
{
    if (request==uploadAddressBook) {
        [[ProgressHUD sharedProgressHUD]done:YES];
        [self clearUploadRequest];
        self.addressBookTableViewDataSource.notRegArray=data;
    }
}
#pragma mark -GetPoepleFromAddress

-(void)getPoepleListFromAddress
{
    [allContact removeAllObjects];
    
    ABAddressBookRef addressBook = ABAddressBookCreate();
    NSArray *poepleArray = (NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    if (poepleArray) {
        NSMutableArray *tempPhone=[NSMutableArray new];
        for (NSObject *people in poepleArray) {
            Contact *contact=[[Contact alloc]init];
            contact.firstName= (NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
            contact.lastName= (NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
             ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(people, kABPersonPhoneProperty);
            for (int i=0; i<ABMultiValueGetCount(phones); i++) {
                NSString *phone = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
                [tempPhone addObject:phone];
                [contact.phoneArray addObject:phone];
            }
            [allContact addObject:contact];
            [contact release];
        }
        if (tempPhone.count!=0) {
            [self uploadAddressArray:tempPhone];
        }
        [self.addressBookTableViewDataSource reloadData:allContact tableView:self.addressbookTableView];
        [tempPhone release];
    }else
    {
        [Tool showAlertWithTitle:@"提示" msg:@"获取通讯录失败"];
    }
}
@end
