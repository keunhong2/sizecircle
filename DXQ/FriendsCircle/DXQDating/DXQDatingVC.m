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

@interface DXQDatingVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *datingList;
    
    UITableView *tableView;
}

@property (nonatomic,retain)NSMutableArray *datingList;

@property (nonatomic,retain)UITableView *tableView;

@end

@implementation DXQDatingVC
@synthesize datingList = _datingList;
@synthesize tableView = _tableView;

- (id)init
{
    self = [super init];
    if (self)
    {
        datingList = [[NSMutableArray alloc]init];
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
    
    //custom segment
    NSDictionary *item1 = [NSDictionary dictionaryWithObjectsAndKeys:@"列表",@"title",@"pyq_l",@"img", nil];
    NSDictionary *item2 = [NSDictionary dictionaryWithObjectsAndKeys:@"宫格",@"title",@"pyq_r",@"img", nil];
    NSArray *items = [NSArray arrayWithObjects:item1,item2, nil];
    CustomSegmentedControl *segment = [[CustomSegmentedControl alloc]initWithFrame:CGRectZero items:items defaultSelectIndex:0];
    segment.delegate = self;
    self.navigationItem.titleView=segment;
    [segment release];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, 320,416)];
	_tableView.delegate = self;
	_tableView.dataSource = self;
    [_tableView setSeparatorColor:TABLEVIEW_SEPARATORCOLOR];
    _tableView.backgroundColor=[UIColor whiteColor];
    [_tableView setRowHeight:480.0f];
    [_tableView setContentInset:UIEdgeInsetsMake(44.0,0, 0, 0)];
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.tableFooterView = footer;
    [footer release];
    [self.view addSubview:_tableView];
    
    CustomSearchBar *searchBar=[[CustomSearchBar alloc]initWithFrame:CGRectMake(0.f, -44.0, self.view.frame.size.width, 44.f)];
    [self.view addSubview:searchBar];
    searchBar.placeholder=AppLocalizedString(@"搜索");
    searchBar.delegate=self;
    searchBar.showsCancelButton = NO;
    [_tableView addSubview:searchBar];
    [searchBar release];
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


-(void)filterAction:(UIButton*)sender
{
 
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
    return [datingList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self ListCellForIndexPath:indexPath];
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)ListCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"NearByListCell";
    NearByListCell *cell=[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[NearByListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *item = [datingList objectAtIndex:indexPath.row];
    [cell.avatarImg setImageWithURL:[NSURL URLWithString:[item objectForKey:@"imageurl"]]placeholderImage:[UIImage imageNamed:@"tx_gray.png"]];
    cell.usernameLbl.text = [item objectForKey:@"username"];
    cell.ageImg.image = [UIImage imageNamed:@"pyq_girl.png"];
    cell.ageLbl.text = @"18";
    cell.distanceLbl.text = @"15.32km  |  当前在线";
    cell.statusLbl.text = [item objectForKey:@"status"];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
