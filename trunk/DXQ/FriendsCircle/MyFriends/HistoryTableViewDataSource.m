//
//  HistoryTableViewDataSource.m
//  DXQ
//
//  Created by Yuan on 12-10-24.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "HistoryTableViewDataSource.h"
#import "FriendsListCell.h"
#import "UIButton+WebCache.h"
#import "MyFriendsVC.h"
#import "ChatMessageCenter.h"

@interface HistoryTableViewDataSource()
{
    UITableView *listTableView;
}
@property (nonatomic,assign)UIViewController *viewControl;
@property (retain, nonatomic)NSMutableArray  *data;
@end

@implementation HistoryTableViewDataSource
@synthesize data = _data;
@synthesize viewControl = _viewControl;

- (void)dealloc
{
    [_viewControl release];_viewControl = nil;
    [_data release];_data = nil;
    [super dealloc];
}

-(id)initWithViewControl:(UIViewController *)viewControl;
{
    if(self = [super init])
    {
        _viewControl = viewControl;
        _data = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)reloadData:(UITableView *)tableview
{
    listTableView = tableview;
    [_data removeAllObjects];
    [_data addObjectsFromArray:[[SettingManager sharedSettingManager]getLastestContact]];
    [listTableView reloadData];
}

#pragma mark -UITableViewDataSourceAndDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    [cell.avatarImg setImageWithURL:[NSURL URLWithString:picurl]placeholderImage:[UIImage imageNamed:@"tx_gray.png"]];
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
    cell.badgeNumber=[[ChatMessageCenter shareMessageCenter]getMsgNumberWithChatName:[item objectForKey:@"AccountId"]];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除会话";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *item = [_data objectAtIndex:indexPath.row];
    [(MyFriendsVC *)_viewControl chatWithUserInfo:item];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_data removeObjectAtIndex:indexPath.row];
        [[SettingManager sharedSettingManager]saveLastestContact:_data];
        [listTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}




-(void)viewUserDetailInfoAction:(UIButton *)btn
{
    FriendsListCell *cell = (FriendsListCell *)([[btn superview]superview]);
    NSIndexPath *indexPath =  [listTableView indexPathForCell:cell];
    NSDictionary *item = [_data objectAtIndex:indexPath.row];
    [(MyFriendsVC *)_viewControl viewUserDetailInfo:item];
}



@end
