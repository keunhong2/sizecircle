//
//  AcvityDetailViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-30.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "AcvityDetailViewController.h"
#import "PhotoDetailViewController.h"
#import "UserLoadNewsDetail.h"
#import "AdmireRequest.h"
#import "ShopCommentViewController.h"
#import "UserCommentCell.h"
#import "UIImageView+WebCache.h"

@interface AcvityDetailViewController ()<BusessRequestDelegate,CommentViewDelegate>{

    UILabel *contentLabel;
    UserLoadNewsDetail *detailRequest;
    AdmireRequest *admireRequest;
    UIActivityIndicatorView *activity;
}

@end

@implementation AcvityDetailViewController

-(void)dealloc{

    [_photoTopView release];
    [_tableView release];
    [_activityDic release];
    [contentLabel release];
    [_commantList release];
    [_simpleDic release];
    [activity release];
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

    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.delegate=self;
    tableView.dataSource=self;
    self.tableView=tableView;
    [tableView release];
    
    PhotoDetailTopView *detailTopView=[[PhotoDetailTopView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 180.f)];
    self.photoTopView=detailTopView;
    [detailTopView release];
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self cancelAllRequest];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if (!_activityDic) {
        [self detailRequest];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"动态详情") backItemTitle:AppLocalizedString(@"返回")];
}

-(void)setInfoToPhotoViewByDic:(NSDictionary *)dic{

    if (!_photoTopView||!dic) {
        return;
    }
    
    if (!contentLabel) {
        contentLabel=[[UILabel alloc]initWithFrame:CGRectZero];
        contentLabel.backgroundColor=[UIColor clearColor];
        contentLabel.textColor=[UIColor darkTextColor];
        [_photoTopView addSubview:contentLabel];
    }
    contentLabel.frame=CGRectMake(20.f, 20.f, self.view.frame.size.width-40.f,100.f);
    contentLabel.text=[dic objectForKey:@"Content"];
    _photoTopView.frame=CGRectMake(_photoTopView.frame.origin.x, _photoTopView.frame.origin.y, _photoTopView.frame.size.width, contentLabel.frame.origin.y+contentLabel.frame.size.height+100.f);
    self.commantList=[dic objectForKey:@"CommentList"];
    NSString *praText=[NSString stringWithFormat:AppLocalizedString(@"%@人"),[dic objectForKey:@"PraiseCount"]];
    [_photoTopView.goodBtn setTitle:praText forState:UIControlStateNormal];
    NSString *comText=[NSString stringWithFormat:AppLocalizedString(@"%@人"),[dic objectForKey:@"CommentCount"]];
    [_photoTopView.commentBtn setTitle:comText forState:UIControlStateNormal];
    [self.tableView reloadData];
}

#pragma mark - Set method

-(void)setTableView:(UITableView *)tableView{

    if ([tableView isEqual:_tableView]) {
        return;
    }
    [_tableView removeFromSuperview];
    [_tableView release];
    _tableView=[tableView retain];
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView=_photoTopView;
}

-(void)setPhotoTopView:(PhotoDetailTopView *)photoTopView{

    if ([_photoTopView isEqual:photoTopView]) {
        return;
    }
    [_photoTopView release];
    _photoTopView =[photoTopView retain];
    [_photoTopView.imageView removeFromSuperview];
    [self setInfoToPhotoViewByDic:_activityDic];
    self.tableView.tableHeaderView=photoTopView;
    [activity release];
    activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setHidesWhenStopped:YES];
    [activity stopAnimating];
    activity.frame=CGRectMake((_photoTopView.goodBtn.frame.size.width-activity.frame.size.width)/2, (_photoTopView.goodBtn.frame.size.height-activity.frame.size.height)/2, activity.frame.size.width, activity.frame.size.height);
    [_photoTopView.goodBtn addSubview:activity];
    [_photoTopView.goodBtn addTarget:self action:@selector(admireRequest) forControlEvents:UIControlEventTouchUpInside];
    [_photoTopView.commentBtn addTarget:self action:@selector(commentBtn) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setActivityDic:(NSDictionary *)activityDic{

    if ([activityDic isEqualToDictionary:_activityDic]) {
        return;
    }
    [_activityDic release];
    _activityDic=[activityDic retain];
    [self setInfoToPhotoViewByDic:activityDic];
}

-(void)commentBtn{
    
    ShopCommentViewController *shop=[[ShopCommentViewController alloc]initWithNibName:@"CommentInputViewController" bundle:nil];
    shop.shopDic=_activityDic;
    shop.commentDelegate=self;
    shop.kindType=@"MemberNews";
    CustonNavigationController *nav=[[CustonNavigationController alloc]initWithRootViewController:shop];
    [self presentModalViewController:nav animated:YES];
    [nav release];
    [shop release];
}

#pragma mark -CommentViewDelegate

-(void)finishCommentViewController:(ShopCommentViewController *)commentViewController{

    [self detailRequest];
}

#pragma mark -Request 

-(void)cancelAllRequest{

    [self cancelDetailRequest];
    [self cancelAdmireRequest];
}

-(void)cancelDetailRequest
{
    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release];
        detailRequest=nil;
    }   
}

-(void)detailRequest{

    [self cancelDetailRequest];
    
    NSString *acID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:acID,@"AccountId",[_simpleDic objectForKey:@"Id"],@"Id", nil];
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    detailRequest=[[UserLoadNewsDetail alloc]initWithRequestWithDic:dic];
    detailRequest.delegate=self;
    [detailRequest startAsynchronous];
}

-(void)cancelAdmireRequest{

    if (admireRequest) {
        [admireRequest cancel];
        [admireRequest release];
        admireRequest=nil;
    }
}

-(void)admireRequest{
    
    [self cancelAdmireRequest];
    
    activity.frame=CGRectMake(_photoTopView.goodBtn.frame.size.width/2-activity.frame.size.width/2, _photoTopView.goodBtn.frame.size.height/2-activity.frame.size.height/2, activity.frame.size.width, activity.frame.size.height);
    [_photoTopView.goodBtn addSubview:activity];
    [activity startAnimating];
    _photoTopView.goodBtn.enabled=NO;
    
    NSString *acID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       @"MemberFile",@"ObjectKind",
                       [_activityDic objectForKey:@"Id"],@"ObjectNo",
                       acID,@"AccountId", nil];
    admireRequest=[[AdmireRequest alloc]initWithRequestWithDic:dic];
    admireRequest.delegate=self;
    [admireRequest startAsynchronous];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    if (request==detailRequest) {
        _photoTopView.goodBtn.enabled=NO;
        _photoTopView.commentBtn.enabled=NO;
    }
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    if (request==detailRequest) {
        [[ProgressHUD sharedProgressHUD]done:YES];
        self.activityDic=data;
        _photoTopView.goodBtn.enabled=YES;
        _photoTopView.commentBtn.enabled=YES;
    }else if (request==admireRequest){
        [[ProgressHUD sharedProgressHUD]showInView:self.view];
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"赞成功")];
        [[ProgressHUD sharedProgressHUD]done:YES];
        [activity stopAnimating];
        NSString *goodText=[NSString stringWithFormat:AppLocalizedString(@"%d人"),[[_activityDic objectForKey:@"PraiseCount"] intValue]+1];
        [_photoTopView.goodBtn setTitle:goodText forState:UIControlStateNormal];
    }
}

#pragma mark -UITableViewDataSouce And Delegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _commantList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIndent=@"coment";
    UserCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndent];
    if (!cell) {
        cell=[[[UserCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndent] autorelease];
    }
    NSDictionary *dic=[_commantList objectAtIndex:indexPath.row];
    NSString *url=[dic objectForKey:@"PhotoUrl"];
    NSString *encodeUrl=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.userImageView setImageWithURL:[NSURL URLWithString:encodeUrl] placeholderImage:nil];
    cell.userNameLabel.text=[dic objectForKey:@"MemberName"];
    cell.dateLabel.text=[Tool convertTimestampToNSDate:[[dic objectForKey:@"OpTime"] integerValue]];
    cell.commentLabel.text=[dic objectForKey:@"Content"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
