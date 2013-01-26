//
//  BaseTicketAndTuanViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseTicketAndTuanViewController.h"
#import "ProductListRequest.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "UserMemberCell.h"

@interface BaseTicketAndTuanViewController ()<BusessRequestDelegate>{

}

@end

@implementation BaseTicketAndTuanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)dealloc{

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning
{
//    // [super didReceiveMemoryWarning];
}




#pragma mark -UISearchBarDelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

    [searchBar resignFirstResponder];
    [self screenByText:searchBar.text];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    [searchBar resignFirstResponder];
    [self screenByText:searchBar.text];
}

#pragma mark -UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self.searchBar resignFirstResponder];
}


@end

