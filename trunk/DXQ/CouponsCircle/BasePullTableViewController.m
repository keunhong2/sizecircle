//
//  BasePullTableViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-23.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BasePullTableViewController.h"

@interface BasePullTableViewController ()

@end

@implementation BasePullTableViewController


-(void)dealloc{

    [_egoHeaderView release];
    [_tableView release];
    [_lastUpdate release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _lastUpdate=[[NSDate date] retain];
    }
    return self;
}

-(void)loadView{
    
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:view_.bounds style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.dataSource=self;
    tableView.delegate=self;
    tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    
    _egoHeaderView= [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
    _egoHeaderView.delegate = self;
    [self.tableView addSubview:_egoHeaderView];
    [_egoHeaderView refreshLastUpdatedDate];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidUnload{

    [_egoHeaderView release];
    _egoHeaderView=nil;
    
    self.tableView=nil;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
//    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

-(void)changeTableViewState{

    self.tableView.contentOffset=CGPointMake(0.f, -70.f);
    [_egoHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
}

-(void)defaultRequest
{


}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)doneLoadingTableViewData{
	
	_isLoading = NO;
    [_lastUpdate release];
    _lastUpdate=[[NSDate date] retain];
	[_egoHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_egoHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_egoHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self defaultRequest];
    _isLoading=YES;
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _isLoading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return _lastUpdate; // should return date data source was last changed
}


@end
