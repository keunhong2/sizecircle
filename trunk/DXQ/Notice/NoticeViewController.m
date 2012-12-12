//
//  NoticeViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "NoticeViewController.h"

@interface NoticeViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation NoticeViewController


-(void)dealloc{

    [_tableView release];
    [_noticeArray release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=AppLocalizedString(@"通知中心");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark Set

-(void)setTableView:(UITableView *)tableView{

    if ([tableView isEqual:_tableView]) {
        return;
    }
    [_tableView removeFromSuperview];
    [_tableView release];
    _tableView=[tableView retain];
    [self.view addSubview:_tableView];
}

-(void)setNoticeArray:(NSArray *)noticeArray{

    if ([noticeArray isEqualToArray:_noticeArray]) {
        return;
    }
    [_noticeArray release];
    _noticeArray=[noticeArray retain];
    [self.tableView reloadData];
}

#pragma mark -UITableViewDataSource And Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _noticeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ident=@"notice";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident] autorelease];
    }
    NSDictionary *dic=[_noticeArray objectAtIndex:indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"AccountFromName"];
    return cell;
}
@end
