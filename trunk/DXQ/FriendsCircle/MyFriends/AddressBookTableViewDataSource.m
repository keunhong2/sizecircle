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

@interface AddressBookTableViewDataSource()
@property (nonatomic,assign)UIViewController *viewControl;
@property (retain, nonatomic)NSMutableArray  *data;
@end

@implementation AddressBookTableViewDataSource
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
//        for (int i = 0 ; i < 20; i++)
//        {
//            NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:@"http://www.51netu.com/uploads/100428/1767_093618_1.jpg",@"imageurl",@"凤姐",@"username",@"修勇我喜欢你...",@"status", nil];
//            [_data addObject:item];
//        }
    }
    return self;
}



-(void)reloadData:(NSArray *)arr tableView:(UITableView *)tableview{

    [_data removeAllObjects];
    [_data addObjectsFromArray:arr];
    [tableview reloadData];
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
    FriendsListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[FriendsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *item = [_data objectAtIndex:indexPath.row];
//    [cell.avatarImg setImageWithURL:[NSURL URLWithString:[[item objectForKey:@"imageurl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]placeholderImage:[UIImage imageNamed:@"tx_gray.png"]];
    Contact *contact=[_data objectAtIndex:indexPath.row];
    cell.avatarImg.imageView.image=[UIImage imageNamed:@"tx_gray.png"];
    cell.avatarImg.enabled=NO;
    cell.usernameLbl.text = contact.fullName;
    cell.ageImg.image = [UIImage imageNamed:@"pyq_girl.png"];
    cell.ageLbl.text = @"18";
    cell.distanceLbl.text = @"15.32km  |  当前在线";
    cell.statusLbl.text = [item objectForKey:@"status"];
    return cell;
}

@end
