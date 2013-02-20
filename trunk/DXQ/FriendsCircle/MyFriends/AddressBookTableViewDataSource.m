//
//  AddressBookTableViewDataSource.m
//  DXQ
//
//  Created by Yuan on 12-10-24.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "AddressBookTableViewDataSource.h"
#import "FriendsListCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "Contact.h"
#import "UserMakeFriendRequest.h"

@interface AddressBookTableViewDataSource()<BusessRequestDelegate>
@property (nonatomic,assign)UIViewController *viewControl;
@property (retain, nonatomic)NSMutableArray  *data;
@property (nonatomic,assign)UITableView *tableView;
@end

@implementation AddressBookTableViewDataSource
@synthesize data = _data;
@synthesize viewControl = _viewControl;

- (void)dealloc
{
    [_viewControl release];_viewControl = nil;
    [_data release];_data = nil;
    self.notRegArray=nil;
    [super dealloc];
}

-(id)initWithViewControl:(UIViewController *)viewControl;
{
    if(self = [super init])
    {
        _viewControl = viewControl;
        
        _data = [[NSMutableArray alloc]init];
//        for (int i = 0 ; i < 20; i++)
//        {
//            NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:@"http://www.51netu.com/uploads/100428/1767_093618_1.jpg",@"imageurl",@"凤姐",@"username",@"修勇我喜欢你...",@"status", nil];
//            [_data addObject:item];
//        }
    }
    return self;
}



-(void)reloadData:(NSArray *)arr tableView:(UITableView *)tableview{

    self.tableView=tableview;
    [_data removeAllObjects];
    [_data addObjectsFromArray:arr];
    [tableview reloadData];
}

-(void)setNotRegArray:(NSArray *)notRegArray{

    if ([notRegArray isEqualToArray:_notRegArray]) {
        return;
    }
    [_notRegArray release];
    _notRegArray=[notRegArray retain];
    [self.tableView reloadData];
}

#pragma mark -UITableViewDataSourceAndDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //for test
    NSInteger count= [_data count];
    if (count==0) {
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }else
        tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self ListCellForIndexPath:indexPath withTableView:tableView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)ListCellForIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView
{
    static NSString *cellIdentifier=@"FriendsListCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }
    if (self.notRegArray) {
        if (![cell.accessoryView isKindOfClass:[UIButton class]]) {
            
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeContactAdd];
            [btn addTarget:self action:@selector(addFriendBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView=btn;
        }
    }else
        cell.accessoryView=nil;
//    NSDictionary *item = [_data objectAtIndex:indexPath.row];
//    [cell.avatarImg setImageWithURL:[NSURL URLWithString:[[item objectForKey:@"imageurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]placeholderImage:[UIImage imageNamed:@"tx_gray.png"]];
    Contact *contact=[_data objectAtIndex:indexPath.row];
    cell.imageView.image=[UIImage imageNamed:@"tx_gray.png"];
    cell.textLabel.text=contact.fullName;
    cell.detailTextLabel.text=contact.phone;
//    cell.ageImg.image = [UIImage imageNamed:@"pyq_girl.png"];
//    cell.ageLbl.text = @"18";
//    cell.distanceLbl.text = @"15.32km  |  当前在线";
//    cell.statusLbl.text = [item objectForKey:@"status"];
    return cell;
}

-(void)addFriendBtn:(UIButton *)btn
{
    if (self.notRegArray==nil) {
        return;
    }
    UITableViewCell *cell=(UITableViewCell *)[btn superview];
    if (![cell isKindOfClass:[UITableViewCell class]]) {
        cell=(UITableViewCell *)[cell superview];
    }
    if ([cell isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath=[self.tableView indexPathForCell:cell];
        Contact *contac=[self.data objectAtIndex:indexPath.row];
        if ([contac checkIsContainPhone:self.notRegArray]) {
            NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[[SettingManager sharedSettingManager]loggedInAccount],@"AccountFrom",contac.phone,@"AccountTo", nil];
            UserMakeFriendRequest *friend=[[UserMakeFriendRequest alloc]initWithRequestWithDic:dic];
            [[ProgressHUD sharedProgressHUD]setText:@"发送请求好友中..."];
            [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
            [friend setDelegate:self];
            [friend startAsynchronous];
        }
    }
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]done:NO];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [request release];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data
{
    [[ProgressHUD sharedProgressHUD]done:YES];
    [[ProgressHUD sharedProgressHUD]setText:@"请求发送成功!"];
    [request release];
}

@end
