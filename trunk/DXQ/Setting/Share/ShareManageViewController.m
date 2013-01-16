//
//  ShareManageViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ShareManageViewController.h"
#import "SinaWeiBoShare.h"
#import "TecentWeiBoShare.h"

@interface ShareManageViewController ()<UITableViewDataSource,SinaWeiBoShareDelegate,TecentWeiBoShareDelegate>

@end

@implementation ShareManageViewController

-(void)dealloc{

    [_tableView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{

    [super loadView];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource=self;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.backgroundView=nil;
    self.tableView=tableView;
    [tableView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavgationTitle:AppLocalizedString(@"分享设置") backItemTitle:AppLocalizedString(@"返回")];
}

- (void)didReceiveMemoryWarning
{
    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Set

-(void)setTableView:(UITableView *)tableView{
    
    if ([tableView isEqual:_tableView]) {
        return;
    }

    [_tableView removeFromSuperview];
    [_tableView release];
    _tableView=[tableView retain];
    [self.view addSubview:_tableView];
}

#pragma mark -UITableViewDataSource 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *shareIndent=@"share";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:shareIndent];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shareIndent] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    UISwitch *theSwitch=[[UISwitch alloc]initWithFrame:CGRectZero];
    [theSwitch addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    theSwitch.tag=indexPath.row;
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.text=AppLocalizedString(@"新浪微博");
            theSwitch.on=[SinaWeiBoShare sharedSinaWeiBo].sinaweibo.isAuthValid;
        }
            break;
        case 1:
        {
            cell.textLabel.text=AppLocalizedString(@"腾讯微博");
            theSwitch.on=[[[TecentWeiBoShare sharedTecentWeiBoShare].weiboEngine openId] length]>0;
        }
            break;
        default:
            break;
    }
    cell.accessoryView=theSwitch;
    [theSwitch release];
    return cell;
}


-(void)valueChange:(UISwitch *)theSwitch{

    switch (theSwitch.tag) {
        case 0:
        {
            if (theSwitch.on) {
                [[SinaWeiBoShare sharedSinaWeiBo]loginSinaWeibo];
                [[SinaWeiBoShare sharedSinaWeiBo]setDelegate:self];
            }else
                [[SinaWeiBoShare sharedSinaWeiBo]logoutSinaWeibo];
        }
            break;
        case 1:
        {
            if (theSwitch.on) {
                [[TecentWeiBoShare sharedTecentWeiBoShare]onLogin];
            }else
                [[[TecentWeiBoShare sharedTecentWeiBoShare]weiboEngine]logOut];
        }
            
        default:
            break;
    }
    
    if (theSwitch.on) {
        [theSwitch setOn:NO animated:YES];
    }
}

-(void)SinaWeiBoShareBindSuccessed{
    
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UISwitch *theSwitch=(UISwitch *)[cell accessoryView];
    [theSwitch setOn:YES animated:YES];
}

-(void)SinaWeiBoShareBindFailure{

    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UISwitch *theSwitch=(UISwitch *)[cell accessoryView];
    [theSwitch setOn:NO animated:YES];
}


-(void)TecentWeiBoShareBindSuccessed{

    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UISwitch *theSwitch=(UISwitch *)[cell accessoryView];
    [theSwitch setOn:YES animated:YES];
}

-(void)TecentWeiBoShareBindFailure{

    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UISwitch *theSwitch=(UISwitch *)[cell accessoryView];
    [theSwitch setOn:NO animated:YES];
}
@end
