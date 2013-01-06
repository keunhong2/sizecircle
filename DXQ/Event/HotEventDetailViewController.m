//
//  HotEventDetailViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-24.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "HotEventDetailViewController.h"
#import "HotEventHeaderView.h"
#import "ImageContentView.h"
#import "UIColor+ColorUtils.h"
#import "ProductDetailRequest.h"
#import "UIImageView+WebCache.h"
#import "UserSetFavoriteProduct.h"
#import "OrderRequest.h"
#import "ImageFilterVC.h"
#import "ShareEventToFriendsViewController.h"
#import "PhotoDetailViewController.h"
#import "PhotoDetailVC.h"
#import "SinaWeiBoShare.h"
#import "TecentWeiBoShare.h"
#import "BuyViewController.h"

@interface HotEventDetailViewController ()<BusessRequestDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UniversalViewControlDelegate,ImageContentDelegate>{
    
    UIScrollView *_contentView;
    HotEventHeaderView *_headerView;
    ImageContentView *_imageContentView;
    UIWebView *contentWebView;
//    UILabel *_introInfoLabel;
    UIButton *_interBtn;
    UIButton *_shareBtn;
    UIButton *_joinBtn;
    
    ProductDetailRequest *detailRequest;
    UserSetFavoriteProduct *favorRequest;
    OrderRequest *joinRequest;
    
    //to shear
    SinaWeiBoShare *sinaShare;
    TecentWeiBoShare *tcShare;
}

@end

@implementation HotEventDetailViewController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"_image_is_upload" object:nil];
    [_contentView release];
    [_headerView release];
    [_imageContentView release];
//    [_introInfoLabel release];
    [contentWebView release];
    [_simpleDic release];
    [_detailDic release];
    sinaShare.delegate=nil;
    tcShare.delegate=nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestDetail) name:@"_image_is_upload" object:nil];
    }
    return self;
}

-(void)loadView{
    
    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    
    _contentView=[[UIScrollView alloc]initWithFrame:self.view.bounds];
    _contentView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _contentView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_contentView];
    
    _headerView=[[HotEventHeaderView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 110.f)];
    [_contentView addSubview:_headerView];
    
    UIImage *buddleImg=[UIImage imageNamed:@"blue_title_bg"];
    UIView *buddleView=[[UIView alloc]initWithFrame:CGRectMake(0.f, 110.f, buddleImg.size.width, buddleImg.size.height)];
    buddleView.backgroundColor=[UIColor clearColor];
    UIImageView *bundImgView=[[UIImageView alloc]initWithImage:buddleImg];
    [buddleView addSubview:bundImgView];
    [bundImgView release];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, buddleView.frame.size.width-5.f, buddleView.frame.size.height-5.f)];
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=UITextAlignmentCenter;
    label.text=AppLocalizedString(@"活动照片");
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont boldSystemFontOfSize:12.f];
    [buddleView addSubview:label];
    [label release];
    
    [_contentView addSubview:buddleView];
    [buddleView release];
    
    _imageContentView=[[ImageContentView alloc]initWithFrame:CGRectMake(0.f, buddleView.frame.origin.y+buddleView.frame.size.height, self.view.frame.size.width, 70.f)];
    _imageContentView.delegate=self;
    [_contentView addSubview:_imageContentView];
    
    _interBtn=[self btnWithPosition:CGPointMake(10.f, _imageContentView.frame.origin.y+_imageContentView.frame.size.height+10.f)];
    [_interBtn setImage:[UIImage imageNamed:@"icon_faver_event"] forState:UIControlStateNormal];
    [_interBtn setTitle:@"感兴趣" forState:UIControlStateNormal];
    [_interBtn addTarget:self action:@selector(interBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_interBtn];
    
    _shareBtn=[self btnWithPosition:CGPointMake(self.view.frame.size.width/2+5.f, _interBtn.frame.origin.y)];
    [_shareBtn setImage:[UIImage imageNamed:@"icon_share_event"] forState:UIControlStateNormal];
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_shareBtn];
    /*
    _introInfoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10.f, _shareBtn.frame.origin.y+_shareBtn.frame.size.height+15.f, self.view.frame.size.width-20.f, 20.f)];
    _introInfoLabel.backgroundColor=[UIColor clearColor];
    _introInfoLabel.textAlignment=UITextAlignmentCenter;
    _introInfoLabel.shadowColor=[UIColor whiteColor];
    _introInfoLabel.textColor=[UIColor darkGrayColor];
    _introInfoLabel.numberOfLines=0;
    _introInfoLabel.shadowOffset=CGSizeMake(0.f, 1.f);
    [_contentView addSubview:_introInfoLabel];
     */
    contentWebView=[[UIWebView alloc]initWithFrame:CGRectMake(10.f, _shareBtn.frame.origin.y+_shareBtn.frame.size.height+15.f, self.view.frame.size.width-20.f, 100.f)];
    contentWebView.backgroundColor=[UIColor clearColor];
    contentWebView.scalesPageToFit=NO;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=0) {
        contentWebView.scrollView.backgroundColor=[UIColor clearColor];
    }else
    {
        for (UIView *view in contentWebView.subviews) {
            [view setBackgroundColor:[UIColor clearColor]];
        }
    }
    [_contentView addSubview:contentWebView];
    
    NSString *joinBtnImgPath=[[NSBundle mainBundle]pathForResource:@"btn_act" ofType:@"png"];
    UIImage *joinBtnImg=[UIImage imageWithContentsOfFile:joinBtnImgPath];
    _joinBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_joinBtn setBackgroundImage:joinBtnImg forState:UIControlStateNormal];
    [_joinBtn sizeToFit];
    [_joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_joinBtn setTitle:AppLocalizedString(@"我要参加") forState:UIControlStateNormal];
    [_joinBtn addTarget:self action:@selector(joinBntAction:) forControlEvents:UIControlEventTouchUpInside];
    _joinBtn.frame=CGRectMake((self.view.frame.size.width-_joinBtn.frame.size.width)/2,self.view.frame.size.height-_joinBtn.frame.size.height-5.f,_joinBtn.frame.size.width, _joinBtn.frame.size.height);
    _joinBtn.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:_joinBtn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIButton *inivateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [inivateBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [inivateBtn sizeToFit];
    [inivateBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [inivateBtn setTitle:AppLocalizedString(@"邀请") forState:UIControlStateNormal];
    [inivateBtn addTarget:self action:@selector(inivateBtnDone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:inivateBtn];
    self.navigationItem.rightBarButtonItem=item;
    [item release];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if (!_detailDic) {
        [self requestDetail];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self cancelAllRequest];
}

-(void)viewDidUnload{
    
    [super viewDidUnload];
    [_headerView release];
    _headerView=nil;
    [_contentView release];
    _contentView=nil;
    [_imageContentView release];
    _imageContentView=nil;
//    [_introInfoLabel release];
//    _introInfoLabel=nil;
    [contentWebView release];
    contentWebView=nil;
    _shareBtn=nil;
    _interBtn=nil;
    _joinBtn=nil;
}

-(UIButton *)btnWithPosition:(CGPoint)posistion{
    
    UIImage *bgImg=[UIImage imageNamed:@"btn_1"];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:bgImg forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.f, -10.f, 0.f, 0.f)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btn.frame=CGRectMake(posistion.x, posistion.y, btn.frame.size.width, btn.frame.size.height);
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor colorWithString:@"#687C93"] forState:UIControlStateNormal];
    return btn;
}

-(void)inivateBtnDone{
    
    ShareEventToFriendsViewController *initvate=[[ShareEventToFriendsViewController alloc]init];
    [self.navigationController pushViewController:initvate animated:YES];
    initvate.eventInfoDic=_detailDic;
    [initvate release];
}

-(void)addImage{
    
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:AppLocalizedString(@"图片分享") delegate:self cancelButtonTitle:AppLocalizedString(@"取消") destructiveButtonTitle:nil otherButtonTitles:AppLocalizedString(@"相机"),AppLocalizedString(@"相册"), nil];
    [sheet showInView:self.navigationController.view];
    [sheet release];
}
#pragma mark -Requset

-(void)cancelAllRequest{
    
    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release];
        detailRequest=nil;
    }
    
    if (favorRequest) {
        [favorRequest cancel];
        [favorRequest release];
        favorRequest=nil;
    }
    
    if (joinRequest) {
        [joinRequest cancel];
        [joinRequest release];
        joinRequest=nil;
    }
}


-(void)requestDetail{
    
    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release];
        detailRequest=nil;
    }
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accountID,@"AccountId",[_simpleDic objectForKey:@"ProductCode"],@"ProductCode", nil];
    detailRequest=[[ProductDetailRequest alloc]initWithRequestWithDic:dic];
    detailRequest.delegate=self;
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    [detailRequest startAsynchronous];
}

-(void)setFavorRequest{
    
    if (favorRequest) {
        [favorRequest cancel];
        [favorRequest release];
        favorRequest=nil;
    }
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accountID,@"AccountId",[_simpleDic objectForKey:@"ProductCode"],@"ProductCode", nil];
    favorRequest=[[UserSetFavoriteProduct alloc]initWithRequestWithDic:dic];
    favorRequest.delegate=self;
    [favorRequest startAsynchronous];
}

-(void)joinRequest{
    
    if (joinRequest) {
        [joinRequest cancel];
        [joinRequest release];
        joinRequest=nil;
    }
    
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accountID,@"AccountId",[_simpleDic objectForKey:@"ProductCode"],@"ProductCode",@"1",@"ProductCount", nil];
    joinRequest=[[OrderRequest alloc]initWithRequestWithDic:dic];
    joinRequest.delegate=self;
    [joinRequest startAsynchronous];
}
// request delegate

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{
    
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    if (request==detailRequest) {
        _shareBtn.enabled=NO;
        _interBtn.enabled=NO;
    }
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{
    
    if ([request isEqual:detailRequest]) {
        [[ProgressHUD sharedProgressHUD]hide];
        self.detailDic=data;
        _shareBtn.enabled=YES;
        _interBtn.enabled=YES;
    }else if ([request isEqual:favorRequest]){
        _interBtn.enabled=NO;
        [[ProgressHUD sharedProgressHUD]showInView:self.view];
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"感兴趣成功")];
        [[ProgressHUD sharedProgressHUD]done:YES];
    }else if ([request isEqual:joinRequest]){
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"参加成功")];
        [[ProgressHUD sharedProgressHUD]done:YES];
    }
}

#pragma mark -Set action

-(void)setSimpleDic:(NSDictionary *)simpleDic{
    
    if ([_simpleDic isEqualToDictionary:simpleDic]) {
        return;
    }
    [_simpleDic release];
    _simpleDic=[simpleDic retain];
    
    NSString *title=[simpleDic objectForKey:@"Title"];
    _headerView.nameLabel.text=title;
    [self setNavgationTitle:title backItemTitle:AppLocalizedString(@"返回")];
    
    _headerView.locationLabel.text=[simpleDic objectForKey:@"Address"];
    NSString *startDate=[Tool convertTimestampToNSDate:[[simpleDic objectForKey:@"StartDate"] integerValue] dateStyle:@"YYYY-MM-dd HH-mm"];
    NSString *endDate=[Tool convertTimestampToNSDate:[[simpleDic objectForKey:@"ExpiredDate"] integerValue] dateStyle:@"HH-MM"];
    _headerView.dateLabel.text= [NSString stringWithFormat:@"%@--%@",startDate,endDate];
    NSString *enUrl=[[simpleDic objectForKey:@"PhotoUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_headerView.imageView setImageWithURL:[NSURL URLWithString:enUrl] placeholderImage:nil];
}

-(void)setDetailDic:(NSDictionary *)detailDic{
    
    if ([detailDic isEqualToDictionary:_detailDic]) {
        return;
    }
    [_detailDic release];
    _detailDic=[detailDic retain];
    
    //    _headerView.nameLabel.text=[detailDic objectForKey:@"CompanyName"];
    _headerView.locationLabel.text=[detailDic objectForKey:@"CompanyAddress"];
    _headerView.infoLabel.text=[detailDic objectForKey:@"Summary"];
    
    self.title=[_detailDic objectForKey:@"ProductTitle"];
    _imageContentView.imageArray=[detailDic objectForKey:@"PictureList"];
    _interBtn.frame=CGRectMake(_interBtn.frame.origin.x, _imageContentView.frame.origin.y+_imageContentView.frame.size.height+15.f, _interBtn.frame.size.width, _interBtn.frame.size.height);
    _shareBtn.frame=CGRectMake(_shareBtn.frame.origin.x, _interBtn.frame.origin.y, _shareBtn.frame.size.width, _shareBtn.frame.size.height);
   
    NSString *startDate=[Tool convertTimestampToNSDate:[[detailDic objectForKey:@"StartDate"] integerValue] dateStyle:@"YYYY-MM-dd HH-mm"];
    NSString *endDate=[Tool convertTimestampToNSDate:[[detailDic objectForKey:@"ExpiredDate"] integerValue] dateStyle:@"HH-MM"];
    _headerView.dateLabel.text= [NSString stringWithFormat:@"%@--%@",startDate,endDate];
    _headerView.nameLabel.text=[detailDic objectForKey:@"ProductTitle"];
    contentWebView.frame=CGRectMake(10.f, _shareBtn.frame.origin.y+_shareBtn.frame.size.height+15.f, self.view.frame.size.width-20.f, contentWebView.frame.size.height);
    [contentWebView loadHTMLString:[detailDic objectForKey:@"Content"] baseURL:nil];
    
    
//    _introInfoLabel.frame=CGRectMake(10.f, _shareBtn.frame.origin.y+_shareBtn.frame.size.height+15.f, self.view.frame.size.width-20.f, 10.f);
//    _introInfoLabel.text=[detailDic objectForKey:@"Content"];
//    [_introInfoLabel sizeToFit];
    
    if ([[detailDic objectForKey:@"IsFavorite"] integerValue]==0) {
        _interBtn.enabled=YES;
    }else
        _interBtn.enabled=NO;
    
    _contentView.contentSize=CGSizeMake(_contentView.frame.size.width, contentWebView.frame.origin.y+contentWebView.frame.size.height+60.f);
}
#pragma mark - button action

-(void)interBtnAction:(UIButton *)btn{
    
    [self setFavorRequest];
}

-(void)shareBtnAction:(UIButton *)btn{
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:AppLocalizedString(@"分享") delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:AppLocalizedString(@"新浪微博"),AppLocalizedString(@"腾讯微博"), nil];
    actionSheet.tag=2;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

-(void)joinBntAction:(UIButton *)btn{
    
    BuyViewController *buyViewController=[[BuyViewController alloc]init];
    buyViewController.productDic=_detailDic;
    
    if (/*[[_infoDic objectForKey:@"Discount"] integerValue]==0||*/[[_detailDic objectForKey:@"MemberPrice"] floatValue]==0) {
        buyViewController.canEditeBuyNumber=NO;
    }
    [self.navigationController pushViewController:buyViewController animated:YES];
    [buyViewController release];
    return;

    [self joinRequest];
}

-(void)showImageFilterWithImage:(UIImage *)image
{
    ImageFilterVC *filter=[[ImageFilterVC alloc]initWithImage:image type:@"2"];
    filter.vDelegate=self;
    filter.productID=[_detailDic objectForKey:@"ProductCode"];
    CustonNavigationController *navi=[[CustonNavigationController alloc]initWithRootViewController:filter];
    [self presentModalViewController:navi animated:YES];
    [filter release];
    [navi release];
}

#pragma mark -ImageContentDelegate

-(void)imageContentView:(ImageContentView *)imageContentView imageViewIndex:(NSInteger)index{
    
    if (index==imageContentView.imageArray.count) {
        [self addImage];
    }else
    {
//        PhotoDetailViewController *detail=[[PhotoDetailViewController alloc]init];
//        detail.imgInfoDic=[imageContentView.imageArray objectAtIndex:index];
//        [self.navigationController pushViewController:detail animated:YES];
//        [detail release];
        
        PhotoDetailVC *photo=[[PhotoDetailVC alloc]initWithUserInfo:[imageContentView.imageArray objectAtIndex:index]];
        [self.navigationController pushViewController:photo animated:YES];
        [photo release];
    }
}
#pragma mark -UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag==2) {
        if (buttonIndex==0) {
            sinaShare=[SinaWeiBoShare sharedSinaWeiBo];
            [sinaShare postTextMessage:[self shareText]];
        }else if (buttonIndex==1)
        {
            tcShare=[TecentWeiBoShare sharedTecentWeiBoShare];
            [tcShare postMessage:[self shareText]];
        }
    }else
    {
        if (buttonIndex<2) {
            
            if (buttonIndex==0) {
                if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"该设备无法调用摄像头")];
                    return;
                }
            }
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            if (buttonIndex==0) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            [self presentModalViewController:imagePicker animated:YES];
            [imagePicker release];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissModalViewControllerAnimated:YES];
    [self performSelector:@selector(showImageFilterWithImage:) withObject:[info objectForKey:@"UIImagePickerControllerOriginalImage"] afterDelay:0.5f];
}


#pragma mark -share

-(NSString *)shareText{

    NSString *title=[_detailDic objectForKey:@"ProductTitle"];
    NSString *begainDate=[Tool convertTimestampToNSDate:[[_detailDic objectForKey:@"StartDate"] integerValue]];
    return [NSString stringWithFormat:@"%@ 开始时间:%@ %@",title,begainDate,HomeWebSite];
}

-(void)shareResult:(BOOL)succes{

    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    NSString *text=succes==YES?AppLocalizedString(@"分享成功"):AppLocalizedString(@"分享失败");
    [[ProgressHUD sharedProgressHUD]setText:text];
    [[ProgressHUD sharedProgressHUD]done:succes];
}

#pragma mark -SinaDelegate

-(void)TecentWeiBoShareRequestFailure{
    
    [self shareResult:NO];
}

-(void)TecentWeiBoShareRequestSuccessed{

    [self shareResult:YES];
}


-(void)SinaWeiBoShareRequestFailure{

    [self shareResult:NO];
}

-(void)SinaWeiBoShareRequestSuccessed{

    [self shareResult:YES];
}
@end

