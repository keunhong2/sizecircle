//
//  ActivityTableViewDataSource.m
//  DXQ
//
//  Created by Yuan on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ActivityTableViewDataSource.h"


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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30.0f;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[[UIView alloc]initWithFrame:CGRectZero] autorelease];
//    [headerView setBackgroundColor:[UIColor clearColor]];
//    CGRect  lblFrame  = section == 0?CGRectMake(-5.0f,0.0f,330.0f,30.0f):CGRectMake(-5.0f,-1.0f,330.0f,31.0f);
//    UITextView *titletxt = [[UITextView alloc]initWithFrame:lblFrame];
//    titletxt.layer.borderColor = TABLEVIEW_SEPARATORCOLOR.CGColor;
//    titletxt.layer.borderWidth = 1.0f;
//    [titletxt setContentInset:UIEdgeInsetsMake(0,20,0,0)];
//    [titletxt setUserInteractionEnabled:NO];
//    [titletxt setFont:NormalDefaultFont];
//    [titletxt setTextColor:[UIColor grayColor]];
//    [titletxt setBackgroundColor:[UIColor clearColor]];
//    [titletxt setText:[[_data objectAtIndex:section] objectForKey:@"sectiontitle"]];
//    [headerView addSubview:titletxt];
//    [titletxt release];
//    return headerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"AboutTableViewDataSource";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:indentifier] autorelease];
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = MiddleNormalDefaultFont;
    cell.textLabel.textColor = [UIColor grayColor];
    NSDictionary *dic=[_data objectAtIndex:indexPath.row];
    cell.textLabel.text = [Tool checkData:[dic objectForKey:@"Title"]];
    cell.detailTextLabel.text = [Tool checkData:[dic objectForKey:@"MemberName"]];
    cell.imageView.image = nil;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
