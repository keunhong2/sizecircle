//
//  SendGiftsVC.m
//  DXQ
//
//  Created by Yuan on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "SendGiftsVC.h"
#import "ThumbImageCell.h"
#import "UIScrollView+AH3DPullRefresh.h"

@interface SendGiftsVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)UITableView *tableView;

@end

@implementation SendGiftsVC
@synthesize tableView = _tableView;


-(void)dealloc
{
    [_tableView release];_tableView = nil;
    [super dealloc];
}

-(void)viewDidUnload
{
    self.tableView = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    CGRect tableViewFrame = CGRectMake(0,0,rect.size.width,rect.size.height);
    _tableView=[[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    [_tableView setSeparatorColor:TABLEVIEW_SEPARATORCOLOR];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView setPullToRefreshHandler:^{
        [self refreshStart];
    }];
}

- (void)viewDidLoad
{
    [self setNavgationTitle:@"送礼" backItemTitle:AppLocalizedString(@"返回")];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)refreshStart
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.tableView refreshFinished];
                   });
}

-(void)imageViewTapIndex:(NSIndexPath *)indexPath imageView:(UIImageView *)imageView
{
    //
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppLocalizedString(@"您确定送这件礼物吗？") message:nil delegate:self cancelButtonTitle:AppLocalizedString(@"取消") otherButtonTitles:AppLocalizedString(@"确定"), nil];
    [alert show];
    [alert release];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
    if (buttonIndex == 0) {
        return;
    }
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"送礼成功!")];
    [[ProgressHUD sharedProgressHUD]showInView:self.navigationController.view];
    [[ProgressHUD sharedProgressHUD]done];
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 83;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ThumbImageCell";
    ThumbImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil)
    {
        cell=[[[ThumbImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell addTapTarget:self action:@selector(imageViewTapIndex:imageView:)];
    }
    NSString *imageurl1 = @"http://www.techcn.com.cn/uploads/200906/1245128626Qe9q3JML.jpg";
    NSString *imageurl2 = @"http://www.techcn.com.cn/uploads/200906/1245128626Qe9q3JML.jpg";
    NSString *imageurl3 = @"http://www.techcn.com.cn/uploads/200906/1245128626Qe9q3JML.jpg";
    cell.imageSourceArray=[NSArray arrayWithObjects:
                           [NSDictionary dictionaryWithObjectsAndKeys:imageurl1,@"imageurl", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:imageurl3,@"imageurl", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:imageurl1,@"imageurl", nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:imageurl2,@"imageurl", nil], nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
