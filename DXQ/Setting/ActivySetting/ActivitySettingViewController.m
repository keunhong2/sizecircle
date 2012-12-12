//
//  ActivitySettingViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ActivitySettingViewController.h"
#import "DXQAccount.h"
#import "UserUpdateNewsSetting.h"

@interface ActivitySettingViewController ()<UITableViewDataSource,UITableViewDelegate,BusessRequestDelegate>{

    DXQAccount *user;
    UserUpdateNewsSetting *settingRequest;
}

@property (nonatomic,retain)NSArray *dataSourceArray;

@end

@implementation ActivitySettingViewController

-(void)dealloc{

    [_dataSourceArray release];
    [_tableView release];
    [settingRequest cancel];
    [user release];
    [settingRequest release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.dataSourceArray=[NSArray arrayWithObjects:AppLocalizedString(@"所有人可见"),AppLocalizedString(@"朋友可见"),AppLocalizedString(@"仅自己可见"), nil];
        user=[[[DXQCoreDataManager sharedCoreDataManager]getCurrentLoggedInAccount] retain];
        if ([user.dxq_NewsSetting isEqualToString:@"ALL"]) {
            self.selectIndexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        }else if ([user.dxq_NewsSetting isEqualToString:@"FRIENDS"]){
            self.selectIndexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        }else
            self.selectIndexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    }
    return self;
}

-(void)loadView{

    [super loadView];

    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [tableView release];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"动态设置") backItemTitle:AppLocalizedString(@"返回")];
    

    UIImage *btnImg=[UIImage imageNamed:@"btn_round"];
    UIFont *font=[UIFont boldSystemFontOfSize:14.f];
    
    UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
    [doneBtn sizeToFit];
    [doneBtn.titleLabel setFont:font];
    [doneBtn setTitle:AppLocalizedString(@"确定") forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnDone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItem=[[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem=doneItem;
    [doneItem release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doneBtnDone:(id)sender{

    if (settingRequest) {
        [settingRequest cancel];
        [settingRequest release];
        settingRequest=nil;
    }
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSString *newsSetting=nil;

    switch (_selectIndexPath.row) {
        case 0:
            newsSetting=@"ALL";
            break;
        case 1:
            newsSetting=@"FRIENDS";
            break;
        case 2:
            newsSetting=@"SELF";
            break;
        default:
            return;
            break;
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accountID,@"AccountId",newsSetting,@"NewsSetting", nil];
    settingRequest=[[UserUpdateNewsSetting alloc]initWithRequestWithDic:dic];
    [[ProgressHUD sharedProgressHUD]showInView:[[[UIApplication sharedApplication]windows]objectAtIndex:0]];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"更新设置中...")];
    [settingRequest setDelegate:self];
    [settingRequest startAsynchronous];
}
#pragma mark -Request

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    switch (_selectIndexPath.row) {
        case 0:
            user.dxq_NewsSetting=@"ALL";
            break;
        case 1:
            user.dxq_NewsSetting=@"FRIENDS";
            break;
        case 2:
            user.dxq_NewsSetting=@"SELF";
            break;
        default:
            return;
            break;
    }
    [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"更新成功")];
    [[ProgressHUD sharedProgressHUD]done:YES];
    [self.navigationController popViewControllerAnimated:YES];
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

-(void)setSelectIndexPath:(NSIndexPath *)selectIndexPath{

    if ([selectIndexPath isEqual:_selectIndexPath]) {
        return;
    }
    UITableViewCell *lastSelectCell=[self.tableView cellForRowAtIndexPath:_selectIndexPath];
    lastSelectCell.accessoryType=UITableViewCellAccessoryNone;
    UITableViewCell *selectCell=[self.tableView cellForRowAtIndexPath:selectIndexPath];
    selectCell.accessoryType=UITableViewCellAccessoryCheckmark;
    _selectIndexPath=[selectIndexPath retain];
}

#pragma mark -UITableViewDataSource And Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ident=@"activity setting";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident] autorelease];
    }
    cell.textLabel.text=[_dataSourceArray objectAtIndex:indexPath.row];
    if ([indexPath isEqual:_selectIndexPath]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }else
        cell.accessoryType=UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndexPath=indexPath;
}

@end
