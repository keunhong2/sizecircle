//
//  MoreTagVC.m
//  DXQ
//
//  Created by Yuan on 12-11-27.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "MoreTagVC.h"

@interface MoreTagVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *selectTagsArray;
    
    UITableView *tableView;
    
    NSArray *dataArray;
}
@property(nonatomic,retain)NSArray *dataArray;

@property(nonatomic,retain)UITableView *tableView;

@end

@implementation MoreTagVC
@synthesize dataArray = _dataArray;
@synthesize tableView = _tableView;

-(void)dealloc
{
    [selectTagsArray release];selectTagsArray = nil;
    [_dataArray release];_dataArray = nil;
    [_tableView release];_tableView = nil;
    [super dealloc];
}

- (id)initWithSelectedArray:(NSArray *)arr
{
    self = [super init];
    if (self)
    {
        selectTagsArray = [[NSMutableArray alloc]initWithArray:arr];
        _dataArray = [[NSArray alloc]initWithObjects:
                      @"美女",
                      @"帅哥",
                      @"旅游",
                      @"美食",
                      @"宠物",
                      @"音乐",
                      @"电影",
                      @"体育",
                      @"搞笑",
                      @"艺术",
                      @"汽车",
                      @"建筑",
                      @"新闻",
                      @"设计",
                      @"时尚",
                      @"生活",
                      @"家庭",
                      nil];
    }
    return self;
}

-(void)loadView
{
    CGRect rect =  [UIScreen mainScreen ].applicationFrame;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, 320, 416) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad
{
    [self setNavgationTitle:AppLocalizedString(@"选择标签") backItemTitle:AppLocalizedString(@"返回")];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark -UITableViewDataSourceAndDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

-(UITableViewCell *)tableView:(UITableView *)tb cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"UITableViewCell";
    UITableViewCell *cell=[tb dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    NSString *item = [_dataArray objectAtIndex:indexPath.row];
    UIImage *selectImage = [UIImage imageNamed:@"select.png"];
    if ([selectTagsArray containsObject:item])
    {
        selectImage = [UIImage imageNamed:@"select_selected.png"];
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:selectImage forState:UIControlStateNormal];
    btn.userInteractionEnabled = NO;
    [btn setFrame:CGRectMake(0, 0,selectImage.size.width,selectImage.size.height)];
    cell.accessoryView = btn;
    [cell.textLabel setFont:MiddleBoldDefaultFont];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.text = item;
    return cell;
}

-(void)tableView:(UITableView *)tb didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tb deselectRowAtIndexPath:indexPath animated:YES];
    NSString *item = [_dataArray objectAtIndex:indexPath.row];
    if ([selectTagsArray containsObject:item])
    {
        [selectTagsArray removeObject:item];
    }
    else
    {
        if ([selectTagsArray count]>=3)return;
        [selectTagsArray addObject:item];
    }
    if (vDelegate && [vDelegate respondsToSelector:@selector(didFinishedAction:witfhInfo:)])
    {
        [vDelegate didFinishedAction:self witfhInfo:selectTagsArray];
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
