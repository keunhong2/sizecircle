//
//  ActivityTableViewDataSource.m
//  DXQ
//
//  Created by Yuan on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ActivityTableViewDataSource.h"
#import "CouponsTrendsCell.h"
#import "UIImageView+WebCache.h"
#import "AcvityDetailViewController.h"
#import "TicketDetailViewController.h"
#import "TuanDetailViewController.h"
#import "HotEventDetailViewController.h"
#import "MemberDetailViewController.h"

@interface ActivityTableViewDataSource()
@property (nonatomic,assign)UIViewController *viewControl;
@end

@implementation ActivityTableViewDataSource
@synthesize data = _data;
@synthesize viewControl = _viewControl;

- (void)dealloc
{
    _viewControl = nil;
    [_data release];_data = nil;
    [super dealloc];
}

-(id)initWithDataList:(NSArray *)dataList viewControl:(UIViewController *)viewControl
{
    if(self = [super init])
    {
        self.data=dataList;
        //
        _viewControl = viewControl;
        
    }
    return self;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return _data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CouponsTrendsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell){
        cell=[[[CouponsTrendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dic=[self.data objectAtIndex:indexPath.row];
    cell.businessHeadImageView.image=nil;
    NSString *url=[dic objectForKey:@"PhotoUrl"];
    NSString *encodeUrl=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.businessHeadImageView setImageWithURL:[NSURL URLWithString:encodeUrl]];
    cell.eventInfoImageView.image=nil;
    NSString *eventUrl=[dic objectForKey:@"PictureUrl"];
    NSString *enEventUrl=[eventUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.eventInfoImageView setImageWithURL:[NSURL URLWithString:enEventUrl]];
    cell.businessNameLabel.text=[dic objectForKey:@"Title"];
    cell.detailInfoLabel.text=[dic objectForKey:@"Content"];
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"OpTime"]longLongValue]];
    cell.releaseDateLabel.text =  [NSString stringWithFormat:@"%@前",[Tool calculateDate:confromTime]];
    cell.releaseDateLabel.frame=CGRectMake(cell.releaseDateLabel.frame.origin.x, 10.f, cell.releaseDateLabel.frame.size.width, 20.f);
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[self.data objectAtIndex:indexPath.row];
    NSString *objectKind=[dic objectForKey:@"ObjectKind"];
    UIViewController *controller=nil;
    if ([objectKind isEqualToString:@"Product"]) {
        NSString *kindName=[dic objectForKey:@"ProductKind"];
        NSString *className=nil;
        if ([kindName isEqualToString:@"H"]) {
            className=@"MemberDetailViewController";
        }else if ([kindName isEqualToString:@"Y"])
        {
            className=@"TicketDetailViewController";
        }else if ([kindName isEqualToString:@"T"])
        {
            className=@"TuanDetailViewController";
        }else if ([kindName isEqualToString:@"A"])
        {
            className=@"HotEventDetailViewController";
        }else
            className=@"AcvityDetailViewController";
        
        TicketDetailViewController *ticket=[[NSClassFromString(className) alloc]init];
        ticket.simpleInfoDic=dic;
        controller=ticket;
    }else
    {
        AcvityDetailViewController *acvity=[[AcvityDetailViewController alloc]init];
        acvity.simpleDic=[self.data objectAtIndex:indexPath.row];
        controller=acvity;
    }
    [_viewControl.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end
