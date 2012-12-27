//
//  PhotoDetailViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-16.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "UIColor+ColorUtils.h"
#import "UserCommentCell.h"
#import "UIImageView+WebCache.h"
#import "PhotoDetailRequest.h"
#import "AdmireRequest.h"
#import "ShopCommentViewController.h"
#import "CustonNavigationController.h"

@interface PhotoDetailViewController ()<BusessRequestDelegate>{
    
    PhotoDetailRequest *detailRequest;
    AdmireRequest *admireRequest;
    UIActivityIndicatorView *activity;
}
@end

@implementation PhotoDetailViewController

@synthesize photoTopView=_photoTopView;
@synthesize photoInfoView=_photoInfoView;
@synthesize tableView=_tableView;

-(void)dealloc{
    
    [_photoTopView release];
    [_photoInfoView release];
    [_tableView release];
    [_imgInfoDic release];
    [_imgDetailDic release];
    [_commantArray release];
    [activity release];
    [_imageIdKey release];
    [super dealloc];
}

-(id)initWithImageInfoDic:(NSDictionary *)dic{
    
    self=[super init];
    if (self) {
        self.imgInfoDic=dic;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title=AppLocalizedString(@"商家照片详情");
    }
    return self;
}


-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    //初始化 头部view
    
    _photoTopView=[[PhotoDetailTopView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 180.f)];
    _photoTopView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_photoTopView];
    if (_imgInfoDic) {
        NSString *url=[[_imgInfoDic objectForKey:@"FilePath"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_photoTopView.imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil success:^(UIImage *image ,BOOL isCahce){
            [Tool setImageView:_photoTopView.imageView toImage:image];
        } failure:nil];
    }
    
    _photoInfoView=[[PhotoInfoView alloc]initWithFrame:CGRectMake(0.f, 180.f, self.view.frame.size.width, 75.f)];
    [self.view addSubview:_photoInfoView];
    [_photoTopView.goodBtn addTarget:self action:@selector(admireRequest) forControlEvents:UIControlEventTouchUpInside];
    [_photoTopView.commentBtn addTarget:self action:@selector(commentBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //for test
    
    _photoInfoView.userName=@"";
    _photoInfoView.location=@"地址:";
    _photoInfoView.dateString=@"";
    _photoInfoView.viewNumber=0;
    _photoInfoView.infoSource=@"";
    
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 255.f, self.view.frame.size.width, self.view.frame.size.height-255.f) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.separatorColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"line2"]];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.contentInset=UIEdgeInsetsMake(1.f, 0.f, 0.f, 0.f);
    _tableView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
    
    activity=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity setHidesWhenStopped:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavgationTitle:AppLocalizedString(@"照片详情") backItemTitle:AppLocalizedString(@"返回")];
    
    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIButton *screenBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [screenBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [screenBtn sizeToFit];
    [screenBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [screenBtn setTitle:AppLocalizedString(@"刷新") forState:UIControlStateNormal];
    [screenBtn addTarget:self action:@selector(requestImgDetail) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:screenBtn];
    self.navigationItem.rightBarButtonItem=item;
    [item release];
}

-(void)viewDidUnload{
    
    [_photoTopView release];
    _photoTopView=nil;
    
    [_photoInfoView release];
    _photoInfoView=nil;
    
    [_tableView release];
    _tableView=nil;
    
    [activity release];
    activity=nil;
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self requestImgDetail];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self cancelAllRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)commentBtn{
    
    ShopCommentViewController *shop=[[ShopCommentViewController alloc]initWithNibName:@"CommentInputViewController" bundle:nil];
    shop.shopDic=_imgInfoDic;
    CustonNavigationController *nav=[[CustonNavigationController alloc]initWithRootViewController:shop];
    [self presentModalViewController:nav animated:YES];
    [nav release];
    [shop release];
}

#pragma mark -Set Method

-(void)setImgInfoDic:(NSDictionary *)imgInfoDic{
    
    if ([_imgInfoDic isEqualToDictionary:imgInfoDic]) {
        return;
    }
    [_imgInfoDic release];
    _imgInfoDic=[imgInfoDic retain];
    if (_photoTopView) {
        NSString *url=[[imgInfoDic objectForKey:@"FilePath"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_photoTopView.imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    }
}

-(void)setImgDetailDic:(NSDictionary *)imgDetailDic{
    
    if ([_imgDetailDic isEqualToDictionary:imgDetailDic]) {
        return;
    }
    [_imgDetailDic release];
    _imgDetailDic=[imgDetailDic retain];
    
    _photoInfoView.imgUrl=[_imgDetailDic objectForKey:@"PhotoUrl"];
    _photoInfoView.userName=[_imgDetailDic objectForKey:@"MemberName"];
    _photoInfoView.location=[NSString stringWithFormat:@"地址:%@",[_imgDetailDic objectForKey:@"AddressInfo"]];
    _photoInfoView.infoSource=[_imgDetailDic objectForKey:@"FileDesc"];
    _photoInfoView.dateString=[Tool convertTimestampToNSDate:[[_imgDetailDic objectForKey:@"CreateDate"] integerValue]];
    _photoInfoView.viewNumber=[[_imgDetailDic objectForKey:@"ReadCount"] integerValue];
    NSString *device=nil;
    NSString *deviceCode=[_imgDetailDic objectForKey:@"DeviceInfo"];
    if ([deviceCode isEqualToString:@"0"]) {
        device=@"电脑端";
    }else if ([deviceCode isEqualToString:@"1"])
        device=@"iOS端";
    else if ([deviceCode isEqualToString:@"2"]){
        device=@"Android端";
    }else
        device=@"未知";
    _photoInfoView.infoSource=[NSString stringWithFormat:@"照片来自%@",device];
    
    NSString *url=[[_imgInfoDic objectForKey:@"FilePath"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_photoTopView.imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil success:^(UIImage *image ,BOOL isCahce){
        [Tool setImageView:_photoTopView.imageView toImage:image];
    } failure:nil];
    
    [_photoTopView.goodBtn setTitle:[NSString stringWithFormat:@"%@人",[_imgDetailDic objectForKey:@"PraiseCount"]] forState:UIControlStateNormal];
    [_photoTopView.commentBtn setTitle:[NSString stringWithFormat:@"%@人",[_imgDetailDic objectForKey:@"CommentCount"]] forState:UIControlStateNormal];
}

-(void)setCommantArray:(NSArray *)commantArray{
    
    if ([_commantArray isEqualToArray:commantArray]) {
        return;
    }
    [_commantArray release];
    _commantArray=[commantArray retain];
    [self.tableView reloadData];
}
#pragma mark -Request

-(void)cancelAllRequest{
    
    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release];
        detailRequest=nil;
    }
    
    if (admireRequest) {
        [admireRequest cancel];
        [admireRequest release];
        admireRequest=nil;
    }
}

-(void)requestImgDetail{
    
    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release];
        detailRequest=nil;
    }
    
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    
    NSString *idText=nil;
    if (!_imageIdKey) {
        idText=[_imgInfoDic objectForKey:@"Id"];
    }else
        idText=[_imgInfoDic objectForKey:_imageIdKey];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:idText,@"Id", nil];
    detailRequest=[[PhotoDetailRequest alloc]initWithRequestWithDic:dic];
    detailRequest.delegate=self;
    [detailRequest startAsynchronous];
}

-(void)admireRequest{
    
    if (admireRequest) {
        [admireRequest cancel];
        [admireRequest release];
        admireRequest=nil;
    }
    
    activity.frame=CGRectMake(_photoTopView.goodBtn.frame.size.width/2-activity.frame.size.width/2, _photoTopView.goodBtn.frame.size.height/2-activity.frame.size.height/2, activity.frame.size.width, activity.frame.size.height);
    [_photoTopView.goodBtn addSubview:activity];
    [activity startAnimating];
    _photoTopView.goodBtn.enabled=NO;
    
    NSString *acID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       @"MemberFile",@"ObjectKind",
                       [_imgInfoDic objectForKey:@"Id"],@"ObjectNo",
                       acID,@"AccountId", nil];
    admireRequest=[[AdmireRequest alloc]initWithRequestWithDic:dic];
    admireRequest.delegate=self;
    [admireRequest startAsynchronous];
}

#pragma mark -UITableViewDataSourceAndDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _commantArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndent=@"coment";
    UserCommentCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndent];
    if (!cell) {
        cell=[[[UserCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndent] autorelease];
    }
    NSDictionary *dic=[_commantArray objectAtIndex:indexPath.row];
    NSString *url=[[dic objectForKey:@"PhotoUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [cell.userImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    cell.userNameLabel.text=[dic objectForKey:@"MemberName"];
    cell.dateLabel.text=[Tool convertTimestampToNSDate:[[dic objectForKey:@"OpTime"] integerValue]];
    cell.commentLabel.text=[dic objectForKey:@"Content"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -RequestDelegate

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{
    
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:YES];
    if ([request isEqual:admireRequest]) {
        _photoTopView.goodBtn.enabled=YES;
        [activity removeFromSuperview];
    }
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{
    
    [[ProgressHUD sharedProgressHUD]hide];
    if ([request isEqual:detailRequest]) {
        self.imgDetailDic=[data objectForKey:@"Info"];
        self.commantArray=[data objectForKey:@"Items"];
    }else if ([request isEqual:admireRequest]){
        [activity removeFromSuperview];
        [_photoTopView.goodBtn setTitle:[NSString stringWithFormat:@"%d人",[[_imgDetailDic objectForKey:@"PraiseCount"] integerValue]+1] forState:UIControlStateNormal];
    }
}
@end


@implementation PhotoDetailTopView

@synthesize imageView=_imageView;
@synthesize goodBtn=_goodBtn;
@synthesize commentBtn=_commentBtn;

-(void)dealloc{
    
    [bgImgView release];
    [_imageView release];
    [super dealloc];
}


-(id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    if (self) {
        NSString *bgImgPath=[[NSBundle mainBundle]pathForResource:@"photo_bg" ofType:@"png"];
        UIImage *bgImg=[[UIImage alloc]initWithContentsOfFile:bgImgPath];
        
        bgImgView=[[UIImageView alloc]initWithImage:bgImg];
        bgImgView.frame=CGRectMake(5.f, 5.f, bgImg.size.width, bgImg.size.height);
        [self addSubview:bgImgView];
        
        [bgImg release];
        
        _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(10.f, 10.f, bgImgView.frame.size.width-10.f, 110.f)];
        _imageView.contentMode=UIViewContentModeScaleAspectFit;
        _imageView.layer.cornerRadius=3.f;
        _imageView.backgroundColor=[UIColor grayColor];
        _imageView.layer.borderColor=[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.5f].CGColor;
        _imageView.layer.borderWidth=3.f;
        [self addSubview:_imageView];
        
        _goodBtn=[self buttonWithFrame:CGRectMake(76.f/2, 130.f, 214.f/2, 30.f)];
        [_goodBtn setTitle:@"0人" forState:UIControlStateNormal];
        [_goodBtn setImage:[UIImage imageNamed:@"icon_favor_btn"] forState:UIControlStateNormal];
        [self addSubview:_goodBtn];
        
        _commentBtn=[self buttonWithFrame:CGRectMake(350.f/2, 130.f, 214.f/2, 30.f)];
        [_commentBtn setTitle:@"0人" forState:UIControlStateNormal];
        [_commentBtn setImage:[UIImage imageNamed:@"icon_comment_btn"] forState:UIControlStateNormal];
        [self addSubview:_commentBtn];
    }
    return self;
}


-(UIButton *)buttonWithFrame:(CGRect)frame{
    
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    btn.titleLabel.font=[UIFont systemFontOfSize:14.f];
    UIColor *btnTitleColor=[UIColor colorWithString:@"#687C93"];
    [btn setTitleColor:btnTitleColor forState:UIControlStateNormal];
    btn.contentEdgeInsets=UIEdgeInsetsMake(0.f, 0.f, 0.f, 20.f);
    btn.titleEdgeInsets=UIEdgeInsetsMake(0.f, 20.f, 0.f, 0.f);
    UIImage *btnBgImg=[UIImage imageNamed:@"btn_1"];
    [btn setBackgroundImage:btnBgImg forState:UIControlStateNormal];
    return btn;
}

@end