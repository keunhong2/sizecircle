//
//  MemberDetailViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "MemberDetailViewController.h"
#import "MemberDetailView.h"
#import "MemberDetailBusinessInfoView.h"
#import "AnnotationViewController.h"
#import "BaseAnnotation.h"
#import "OrderRequest.h"
#import "BuyViewController.h"
#import "SinaWeiBoShare.h"
#import "TecentWeiBoShare.h"

@interface MemberDetailViewController ()<MemberDetailViewDelegate,UIAlertViewDelegate,RelationMakeRequestDelegate,BusessRequestDelegate,UITextFieldDelegate,UIActionSheetDelegate>{

    NSTimer *countDownTimer;
    NSTimeInterval allCount;
    OrderRequest *orderRequest;
    UIButton *buyBtn;
    
    //to shear
    SinaWeiBoShare *sinaShare;
    TecentWeiBoShare *tcShare;
    
    
}

-(void)startCountDownWithTime:(NSTimeInterval)secound;

-(void)stopCountDown;

@end

@implementation MemberDetailViewController

@synthesize tableView=_tableView;
@synthesize memberInfoView=_memberInfoView;
@synthesize detailView=_detailView;
@synthesize businessInfoView=_businessInfoView;
@synthesize infoDic=_infoDic;

-(void)dealloc{

    [self cancelAllRequest];
    [_tableView release];
    [_memberInfoView release];
    [_detailView release];
    [_businessInfoView release];
    [_infoDic release];
    [_simpleInfoDic release];
    
    sinaShare.delegate=nil;
    tcShare.delegate=nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _canBuy=YES;
        self.title=AppLocalizedString(@"会员卡明细");
    }
    return self;
}


-(void)loadView{

    CGRect rect = [UIScreen mainScreen].bounds;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    
    UIImage *btnImg=[UIImage imageNamed:@"btn_red"];
    
    float height=self.view.frame.size.height-btnImg.size.height-10.f;
    if (!_canBuy) {
        height=height+btnImg.size.height+10.f;
    }
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, height) style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor clearColor];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:tableView];
    self.tableView=tableView;
    [tableView release];
    
    buyBtn=nil;
    if (_canBuy) {
        buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [buyBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
        [buyBtn addTarget:self action:@selector(buyBtn) forControlEvents:UIControlEventTouchUpInside];
        [buyBtn sizeToFit];
        [buyBtn setTitle:AppLocalizedString(@"已结束") forState:UIControlStateNormal];
        [buyBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20.f]];
        
        if (_simpleInfoDic) {
            NSDate *date=[NSDate dateWithTimeIntervalSince1970:[[_simpleInfoDic objectForKey:@"EndDate"] integerValue]];
            NSTimeInterval endDate=[date timeIntervalSinceDate:[NSDate date]];
            if (endDate<0) {
                buyBtn.enabled=NO;
                [buyBtn setTitle:AppLocalizedString(@"已结束") forState:UIControlStateNormal];
            }else
            {
                buyBtn.enabled=YES;
                [buyBtn setTitle:AppLocalizedString(@"点击购买") forState:UIControlStateNormal];
            }
        }
        UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0.f, self.view.frame.size.height-btnImg.size.height-10.f, self.view.frame.size.width, btnImg.size.height+10.f)];
        footView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        footView.backgroundColor=[UIColor clearColor];
        buyBtn.center=CGPointMake(footView.frame.size.width/2, footView.frame.size.height/2);
        footView.tag=20;
        [footView addSubview:buyBtn];
        [self.view addSubview:footView];
        [footView release];
    }
    
    
    MemberDetailHeaderView *headerInfoView=[[MemberDetailHeaderView alloc]initWithFrame:CGRectMake(10.f, 5.f, self.view.frame.size.width-20.f, 155.f)];
    UIButton *btn=[[headerInfoView actionView]praiseBtn];
    [btn addTarget:self action:@selector(admireRequest) forControlEvents:UIControlEventTouchUpInside];
    [[headerInfoView.actionView follwerBtn]addTarget:self action:@selector(relationRequest) forControlEvents:UIControlEventTouchUpInside];
    [headerInfoView.actionView.shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.memberInfoView=headerInfoView;
    [headerInfoView release];
    
    MemberDetailView *detail=[[MemberDetailView alloc]initWithFrame:CGRectMake(10.f, 0.f, self.view.frame.size.width-20.f, 70.f)];
    detail.firstImage=[UIImage imageNamed:@"icon_info"];
    detail.secoundImage=[UIImage imageNamed:@"icon_info"];
    self.detailView=detail;
    [detail release];
    
    MemberDetailView *location=[[MemberDetailView alloc]initWithFrame:detail.frame];
    location.imageLocationLeft=NO;
    location.firstImage=[UIImage imageNamed:@"icon_position"];
    location.secoundImage=[UIImage imageNamed:@"icon_phone"];
    location.firstLineText=[NSString stringWithFormat:@"地址:%@",[_simpleInfoDic objectForKey:@"Address"]];
    location.delegate=self;
    self.businessInfoView=location;
    [location release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setNavgationTitle:AppLocalizedString(@"会员卡明细") backItemTitle:AppLocalizedString(@"返回")];
    [self requestProductDetail];
}

-(void)viewDidUnload{

    [_tableView release];
    _tableView=nil;
    
    [_businessInfoView release];
    _businessInfoView=nil;
    
    [_detailView release];
    _detailView=nil;
    
    [super viewDidUnload];
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self stopCountDown];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (_infoDic&&allCount!=0) {
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:[[_infoDic objectForKey:@"ExpiredDate"]floatValue] ];
        NSTimeInterval time=[date timeIntervalSinceNow];
        [self startCountDownWithTime:time];
    }
}

-(void)setSimpleInfoDic:(NSDictionary *)simpleInfoDic{

    if ([simpleInfoDic isEqualToDictionary:_simpleInfoDic]) {
        return;
    }
    [_simpleInfoDic release];
    _simpleInfoDic=[simpleInfoDic retain];
    
    if (_simpleInfoDic) {
        NSDate *date=[NSDate dateWithTimeIntervalSince1970:[[_simpleInfoDic objectForKey:@"EndDate"] integerValue]];
        NSTimeInterval endDate=[date timeIntervalSinceDate:[NSDate date]];
        if (endDate<0) {
            buyBtn.enabled=NO;
            [buyBtn setTitle:AppLocalizedString(@"已结束") forState:UIControlStateNormal];
        }else
        {
            buyBtn.enabled=YES;
            [buyBtn setTitle:AppLocalizedString(@"点击购买") forState:UIControlStateNormal];
        }
    }
}

-(void)setInfoDic:(NSDictionary *)infoDic{

    if ([_infoDic isEqualToDictionary:infoDic]) {
        return;
    }
    [_infoDic release];
    _infoDic=[infoDic retain];
    
    MemberDetailHeaderView *headerView=(MemberDetailHeaderView *)[self memberInfoView];
    headerView.businessName=[_infoDic objectForKey:@"ProductTitle"];
    headerView.businessImageURL=[NSURL URLWithString:[[_infoDic objectForKey:@"ProductPhoto"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    headerView.detail=[_infoDic objectForKey:@"Summary"];
    NSDate *startDate=[NSDate dateWithTimeIntervalSince1970:[[_infoDic objectForKey:@"StartDate"] floatValue]];
    NSDate *endDate=[NSDate dateWithTimeIntervalSince1970:[[_infoDic objectForKey:@"EndDate"] floatValue]];
    NSDate *expDate=[NSDate dateWithTimeIntervalSince1970:[[_infoDic objectForKey:@"ExpiredDate"] floatValue]];
    [self startCountDownWithTime:[expDate timeIntervalSinceNow]];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDateText=[dateFormatter stringFromDate:startDate];
    NSString *endDateText=[dateFormatter stringFromDate:endDate];
    [dateFormatter release];
    headerView.outDate=[NSString stringWithFormat:@"%@-%@",startDateText,endDateText];
    
    MemberDetailView *tempDetail=(MemberDetailView *)self.detailView;
    
    MemberDetailView *locationView=(MemberDetailView *)self.businessInfoView;
//    locationView.firstLineText=[NSString stringWithFormat:@"地址:%@",[_infoDic objectForKey:@"Address"] ];
    locationView.secoundLineText=[NSString stringWithFormat:@"电话:%@",[_infoDic objectForKey:@"CompanyTelephone"]];

    NSString *price=[_infoDic objectForKey:@"MarketPrice"];
    NSString *discount=[_infoDic objectForKey:@"Discount"];
    float theDiscount=[discount floatValue]/10.f;
    NSString *nowPrice=[NSString stringWithFormat:@"%0.f",([price floatValue])*(1.f-theDiscount)];
    tempDetail.firstLineText=[NSString stringWithFormat:@"市场价 ¥%@ , 折扣: %@折 , 节省:¥%@",price,discount,nowPrice,nil];
    tempDetail.secoundLineText=[NSString stringWithFormat:@"已有%@人购买",[_infoDic objectForKey:@"BuyerCount"]];
}

-(void)startCountDownWithTime:(NSTimeInterval)secound{

    allCount=secound;
    [self stopCountDown];
    countDownTimer=[NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(countDwon) userInfo:nil repeats:YES];
}

-(void)countDwon{
    
    MemberDetailHeaderView *headerInfoView=(MemberDetailHeaderView *)[self memberInfoView];
    NSString *text=[Tool convertTimeBySecound:allCount];
    headerInfoView.countDownTime=[NSString stringWithFormat:@"还剩下%@",text];
    if (allCount<=0) {
        headerInfoView.countDownTime=AppLocalizedString(@"已结束");
        [self stopCountDown];
    }
    allCount--;
}
-(void)stopCountDown{

    if (countDownTimer) {
        [countDownTimer invalidate];
        countDownTimer=nil;
    }
}

-(void)buyBtn{

    BuyViewController *buyViewController=[[BuyViewController alloc]init];
    buyViewController.productDic=_infoDic;
    
    if (/*[[_infoDic objectForKey:@"Discount"] integerValue]==0||*/[[_infoDic objectForKey:@"MarketPrice"] floatValue]==0||[[_infoDic objectForKey:@"MarketPrice"] integerValue]==0) {
        buyViewController.canEditeBuyNumber=NO;
    }
    [self.navigationController pushViewController:buyViewController animated:YES];
    [buyViewController release];
    return;
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppLocalizedString(@"填写购买数量") message:nil delegate:self cancelButtonTitle:AppLocalizedString(@"取消") otherButtonTitles:AppLocalizedString(@"购买"), nil];
    UITextField *numberInput=[[UITextField alloc]initWithFrame:CGRectMake(13.f, 50.f, 280.f-22.f, 31.f)];
    numberInput.borderStyle=UITextBorderStyleBezel;
    numberInput.backgroundColor=[UIColor whiteColor];
    numberInput.delegate=self;
    numberInput.keyboardType=UIKeyboardTypeNumberPad;
    [alert addSubview:numberInput];
    numberInput.text=@"1";
    [numberInput release];
    alert.tag=3;
    [numberInput becomeFirstResponder];
    [alert show];
    [alert release];
}

-(void)setCanBuy:(BOOL)canBuy{


    if (canBuy==_canBuy) {
        return;
    }
    _canBuy=canBuy;
    
    UIImage *btnImg=[UIImage imageNamed:@"btn_red"];
    if (canBuy) {
        self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.view.frame.size.height-btnImg.size.height-btnImg.size.height-10.f);
        buyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [buyBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
        [buyBtn addTarget:self action:@selector(buyBtn) forControlEvents:UIControlEventTouchUpInside];
        [buyBtn sizeToFit];
        [buyBtn setTitle:@"点击购买" forState:UIControlStateNormal];
        [buyBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20.f]];
        
        UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0.f, self.view.frame.size.height-btnImg.size.height-10.f, self.view.frame.size.width, btnImg.size.height+10.f)];
        footView.autoresizingMask=UIViewAutoresizingFlexibleTopMargin;
        footView.backgroundColor=[UIColor clearColor];
        buyBtn.center=CGPointMake(footView.frame.size.width/2, footView.frame.size.height/2);
        [footView addSubview:buyBtn];
        footView.tag=20;
        [self.view addSubview:footView];
        [footView release];
    }else
    {
        self.tableView.frame=CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height+btnImg.size.height+10.f);
        [[self.view viewWithTag:20] removeFromSuperview];
    }
}

-(void)shareBtnAction:(UIButton *)btn{
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:AppLocalizedString(@"分享") delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:AppLocalizedString(@"新浪微博"),AppLocalizedString(@"腾讯微博"), nil];
    actionSheet.tag=2;
    [actionSheet showInView:self.view];
    [actionSheet release];
}

#pragma mark -UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==0) {
        return 0.f;
    }else
        return 30.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case 0:
            return 160.f;
            break;
        case 1:
            return 70.f;
        case 2:
            return 70.f;
            break;
        default:
            return 0.f;
            break;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section==0) {
        return nil;
    }else
    {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, tableView.frame.size.width, 30.f)];
        view.backgroundColor=[UIColor clearColor];
        
        UIImage *img=[UIImage imageNamed:@"blue_title_bg"];
        UIImageView *imageView=[[UIImageView alloc]initWithImage:img];
        [imageView sizeToFit];
        imageView.frame=CGRectMake(0.f, 30.f/2-imageView.frame.size.height/2, imageView.frame.size.width, imageView.frame.size.height);
        [view addSubview:imageView];
        [imageView release];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0.f, 0.f, imageView.frame.size.width, 22.f)];
        label.backgroundColor=[UIColor clearColor];
        label.textAlignment=UITextAlignmentCenter;
        label.font=NormalBoldDefaultFont;
        label.textColor=[UIColor whiteColor];
        if (section==1) {
            label.text=@"详 情";
        }else
            label.text=@"商家信息";
        [imageView addSubview:label];
        [label release];
        
        return view;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIndent=@"member detail";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIndent];
    if (!cell) {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndent] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    switch (indexPath.section) {
        case 0:
            [cell.contentView addSubview:_memberInfoView];
            break;
        case 1:
            [cell.contentView addSubview:_detailView];
            break;
        case 2:
            [cell.contentView addSubview:_businessInfoView];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark- Request

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
    
    if (orderRequest) {
        [orderRequest cancel];
        [orderRequest release];
        orderRequest=nil;
    }
}

-(void)requestProductDetail{

    if (detailRequest) {
        [detailRequest cancel];
        [detailRequest release];
        detailRequest=nil;
    }
    
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    
    NSString *idText=[_simpleInfoDic objectForKey:@"ProductCode"];
    if (!idText) {
        idText=[_simpleInfoDic objectForKey:@"ObjectNo"];
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:idText,@"ProductCode",[[SettingManager sharedSettingManager]loggedInAccount],@"AccountId", nil];
    detailRequest=[[ProductDetailRequest alloc]initWithRequestWithDic:dic];
    detailRequest.delegate=self;
    [detailRequest startAsynchronous];
}

-(void)admireRequest{
    
    if (admireRequest) {
        [admireRequest cancel];
        [admireRequest release];
        admireRequest=nil;
    }
    
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       @"Product",@"ObjectKind",[_simpleInfoDic objectForKey:@"ProductCode"],@"ObjectNo",[[SettingManager sharedSettingManager]loggedInAccount],@"AccountId", nil];
    admireRequest=[[AdmireRequest alloc]initWithRequestWithDic:dic];
    admireRequest.delegate=self;
    [admireRequest startAsynchronous];
}

-(void)relationRequest{
    
    if (relationRequest) {
        [relationRequest cancel];
        [relationRequest release];
        relationRequest=nil;
    }
    
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [[SettingManager sharedSettingManager]loggedInAccount],@"AccountFrom",
                       [_simpleInfoDic objectForKey:@"AccountId"],@"AccountTo",
                       @"0",@"Relation", nil];
    relationRequest=[[RelationMakeRequest alloc]initRequestWithDic:dic];
    relationRequest.delegate=self;
    [relationRequest startAsynchronous];
}

-(void)orderRequestByNumber:(NSInteger)number{

    if (orderRequest) {
        [orderRequest cancel];
        [orderRequest release];
        orderRequest=nil;
    }
   
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       [NSString stringWithFormat:@"%d",number],@"ProductCount",
                       [_simpleInfoDic objectForKey:@"ProductCode"],@"ProductCode",
                       [[SettingManager sharedSettingManager]loggedInAccount],@"AccountId", nil];
    [[ProgressHUD sharedProgressHUD]showInView:[[[UIApplication sharedApplication]windows]objectAtIndex:0]];
    [[ProgressHUD sharedProgressHUD]setText:@""];
    orderRequest=[[OrderRequest alloc]initWithRequestWithDic:dic];
    orderRequest.delegate=self;
    [orderRequest startAsynchronous];
}
#pragma mark - MembernDelegate

-(void)memberDetailView:(MemberDetailView *)memberView imageTapIsFirst:(BOOL)isFirst{

    if (isFirst) {
        AnnotationViewController *map=[[AnnotationViewController alloc]initWithNibName:@"AnnotationViewController" bundle:nil];
        [self.navigationController pushViewController:map animated:YES];
        BaseAnnotation *ann=[[BaseAnnotation alloc]init];
        ann.dic=_simpleInfoDic;
        [map.theMapView addAnnotation:ann];
        [ann release];
        [map release];
    }else
    {
        NSString *tel=[_infoDic objectForKey:@"CompanyTelephone"];
        if (tel.length==0) {
            return;
        }
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:AppLocalizedString(@"是否拨打电话") message:tel delegate:self cancelButtonTitle:AppLocalizedString(@"取消") otherButtonTitles:AppLocalizedString(@"拨打"), nil];
        alert.tag=1;
        [alert show];
        [alert release];
    }
}

#pragma mark -UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (string.length!=0) {
        NSString *match=@"^[0-9]*$";
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"self matches %@",match];
        return [predicate evaluateWithObject:string];
    }else
        return YES;
}

#pragma mark -UIAlertViewDelegate

-(void)willPresentAlertView:(UIAlertView *)alertView{

    if (alertView.tag==3) {
        alertView.frame=CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y, alertView.frame.size.width, alertView.frame.size.height+40.f);
        for (UIView *view in alertView.subviews) {
            if ([view isKindOfClass:[UIControl class]]&&![view isKindOfClass:[UITextField class]]) {
                view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y+35.f, view.frame.size.width, view.frame.size.height);
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag==1) {
        if (buttonIndex==1) {
            NSString *num = [[NSString alloc] initWithFormat:@"tel://%@",[_infoDic objectForKey:@"CompanyTelephone"]];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:num]];
            [num release];
        }
    }else if (alertView.tag==3){
    
        UITextField *textField=nil;
        for (UITextField *tempTextField in alertView.subviews) {
            if ([tempTextField isKindOfClass:[UITextField class]]) {
                textField=tempTextField;
                break;
            }
        }
        NSInteger number=[textField.text integerValue];
        if (number!=0) {
            [self orderRequestByNumber:number];
        }
    }
}
#pragma mark- RequestDelegate

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{
    
    if ([request isEqual:relationRequest]) {
        if ([msg isEqualToString:@"关系已存在"]) {
            [[ProgressHUD sharedProgressHUD]showInView:self.view];
            [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"关注成功")];
            [[ProgressHUD sharedProgressHUD]done:YES];
        }
    }else
    {
        [[ProgressHUD sharedProgressHUD]showInView:self.view];
        [[ProgressHUD sharedProgressHUD]setText:msg];
        [[ProgressHUD sharedProgressHUD]done:NO];
    }
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{
    
    if ([request isEqual:detailRequest]) {
        [[ProgressHUD sharedProgressHUD]hide];
        self.infoDic=data;
    }else if ([request isEqual:admireRequest]){
        [[ProgressHUD sharedProgressHUD]showInView:self.view];
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"赞成功!")];
        [[ProgressHUD sharedProgressHUD]done:YES];
    }else if([request isEqual:orderRequest]){
    
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"购买成功")];
        [[ProgressHUD sharedProgressHUD]done:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)relationMakeRequestDidFinishedWithErrorMessage:(NSString *)errorMsg{
    
    if ([errorMsg isEqualToString:@"关系已存在"]) {
        [[ProgressHUD sharedProgressHUD]showInView:self.view];
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"关注成功")];
        [[ProgressHUD sharedProgressHUD]done:YES];
    }else
    {
        [[ProgressHUD sharedProgressHUD]showInView:self.view];
        [[ProgressHUD sharedProgressHUD]setText:errorMsg];
        [[ProgressHUD sharedProgressHUD]done:NO];
    }
}

-(void)relationMakeRequestDidFinishedWithParamters:(NSDictionary *)dic{
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"关注成功")];
    [[ProgressHUD sharedProgressHUD]done:YES];
}

#pragma mark -Share


#pragma mark -share

-(NSString *)shareText{
    
    NSString *title=[_infoDic objectForKey:@"ProductTitle"];
//    NSString *begainDate=[Tool convertTimestampToNSDate:[[_infoDic objectForKey:@"StartDate"] integerValue]];
    return [NSString stringWithFormat:@"%@ %@ %@",title,[_infoDic objectForKey:@"Summary"],HomeWebSite];
}

-(void)shareResult:(BOOL)succes{
    
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    NSString *text=succes==YES?AppLocalizedString(@"分享成功"):AppLocalizedString(@"分享失败");
    [[ProgressHUD sharedProgressHUD]setText:text];
    [[ProgressHUD sharedProgressHUD]done:succes];
}

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
    }
}
@end
