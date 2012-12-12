//
//  BaseImageTableViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-25.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseImageTableViewController.h"
#import "ThumbImageCell.h"
#import "PhotoDetailViewController.h"
#import "UserDetailInfoVC.h"

@interface BaseImageTableViewController ()

@end

@implementation BaseImageTableViewController

-(void)loadView{
    
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
}

-(void)setVisibleImageArray:(NSArray *)visibleImageArray{

    if ([visibleImageArray isEqualToArray:_visibleImageArray]) {
        return;
    }
    [_visibleImageArray release];
    _visibleImageArray=[visibleImageArray retain];
    [self.tableView reloadData];
}

#pragma mark Image touch 

-(void)imageViewTapIndex:(NSIndexPath *)indexPath imageView:(UIImageView *)imageView{    
    NSInteger location=indexPath.row*4;
    NSInteger length=4;
    if (self.visibleImageArray.count-indexPath.row*4<4) {
        length=self.visibleImageArray.count-indexPath.row*4;
    }
    NSArray *array=[self.visibleImageArray subarrayWithRange:NSMakeRange(location, length)];
    NSDictionary *dic=[array objectAtIndex:imageView.tag-1];
    UserDetailInfoVC *photo=[[UserDetailInfoVC alloc]initwithUserInfo:dic];
    [self.navigationController pushViewController:photo animated:YES];
    [photo release];
}

#pragma mark -UITableViewDataSource And Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 83.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.visibleImageArray count]%4==0?[self.visibleImageArray count]/4:[self.visibleImageArray count]/4+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *photoIdent = @"thumbImage";
    ThumbImageCell *cell = [_tableView dequeueReusableCellWithIdentifier:photoIdent];
    
    if (!cell)
    {
        cell=[[[ThumbImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:photoIdent] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell addTapTarget:self action:@selector(imageViewTapIndex:imageView:)];
    }
    NSInteger location=indexPath.row*4;
    NSInteger length=4;
    if ([self visibleImageArray].count-indexPath.row*4<4) {
        length=[self visibleImageArray].count-indexPath.row*4;
    }
    NSArray *array=[[self visibleImageArray] subarrayWithRange:NSMakeRange(location, length)];
    cell.imageSourceArray=array;
    return cell;

}
@end
