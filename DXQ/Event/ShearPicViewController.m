//
//  ShearPicViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-25.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ShearPicViewController.h"
#import "UserLoadPhotoShareList.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "LoadMoreView.h"
#import "PhotoDetailViewController.h"
#import "ImageFilterVC.h"
#import "PhotoDetailVC.h"

@interface ShearPicViewController ()<BusessRequestDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UniversalViewControlDelegate>{
    
    UserLoadPhotoShareList *shareRequest;
    BOOL isRefresh;
    
    LoadMoreView *loadMoreView;
}

@end

@implementation ShearPicViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=AppLocalizedString(@"图片分享");
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"_image_is_upload" object:nil];
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"_image_is_upload" object:nil];
    [self cancelAllRequest];
    [loadMoreView release];
    [super dealloc];
}

-(void)loadView{
    
    [super loadView];
    
    loadMoreView=[[LoadMoreView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 60.f)];
    
    [loadMoreView setLoadMoreBlock:^{
        
        [self requestSharePicListByPage:self.visibleImageArray.count/20+1];
    }];
    [self.tableView setPullToRefreshHandler:^{
        
        [self requestSharePicListByPage:1];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.frame=CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height-60.f);
    UIImage *bgImage=[UIImage imageNamed:@"btn_round"];
    UIButton *screenBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [screenBtn setBackgroundImage:bgImage forState:UIControlStateNormal];
    [screenBtn sizeToFit];
    [screenBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [screenBtn setImage:[UIImage imageNamed:@"icon_cam_btn"] forState:UIControlStateNormal];
    [screenBtn addTarget:self action:@selector(shareBtnDone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:screenBtn];
    self.navigationItem.rightBarButtonItem=item;
    [item release];
}

-(void)viewDidUnload{
    
    [loadMoreView release];
    loadMoreView=nil;
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    if (![self visibleImageArray]) {
        [self.tableView pullToRefresh];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [self cancelAllRequest];
}

-(void)reloadData
{
    [self.tableView pullToRefresh];
}
#pragma mark -button action

-(void)shareBtnDone{
    
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:AppLocalizedString(@"图片分享") delegate:self cancelButtonTitle:AppLocalizedString(@"取消") destructiveButtonTitle:nil otherButtonTitles:AppLocalizedString(@"相机"),AppLocalizedString(@"相册"), nil];
    [sheet showInView:self.navigationController.view];
    [sheet release];
}

-(void)imageViewTapIndex:(NSIndexPath *)indexPath imageView:(UIImageView *)imageView{
    NSInteger location=indexPath.row*4;
    NSInteger length=4;
    if (self.visibleImageArray.count-indexPath.row*4<4) {
        length=self.visibleImageArray.count-indexPath.row*4;
    }
    NSArray *array=[self.visibleImageArray subarrayWithRange:NSMakeRange(location, length)];
    NSDictionary *dic=[array objectAtIndex:imageView.tag-1];
//    PhotoDetailViewController *photo=[[PhotoDetailViewController alloc]initWithImageInfoDic:dic];
//    [self.navigationController pushViewController:photo animated:YES];
//    [photo release];
    
    PhotoDetailVC *photo=[[PhotoDetailVC alloc]initWithUserInfo:dic];
    [self.navigationController pushViewController:photo animated:YES];
    [photo release];
    
}

-(void)showImageFilterWithImage:(UIImage *)image
{
    ImageFilterVC *filter=[[ImageFilterVC alloc]initWithImage:image type:@"2"];
    filter.vDelegate=self;
    CustonNavigationController *navi=[[CustonNavigationController alloc]initWithRootViewController:filter];
    [self presentModalViewController:navi animated:YES];
    [filter release];
    [navi release];
}
#pragma mark -Request

-(void)cancelAllRequest{
    
    if(shareRequest){
        [shareRequest cancel];
        [shareRequest release];
        shareRequest=nil;
    }
    
    loadMoreView.state=LoadMoreStateNormal;
}

-(void)requestSharePicListByPage:(NSInteger)page{
    
    if (shareRequest) {
        [shareRequest cancel];
        [shareRequest release];
        shareRequest=nil;
    }
    
    if (page==1) {
        isRefresh=YES;
    }else
        isRefresh=NO;
    NSDictionary *pager=[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%d",page],@"PageIndex",
                         [NSString stringWithFormat:@"%d",20],@"ReturnCount", nil];
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accountID,@"AccountId",
                       @"2",@"Order",@"0",@"OrderDirection",
                       [[GPS gpsManager]getLocation:GPSLocationLatitude],@"WeiDu",
                       [[GPS gpsManager]getLocation:GPSLocationLongitude],@"JingDu",
                       pager,@"Pager", nil];
    loadMoreView.state=LoadMoreStateRequesting;
    shareRequest=[[UserLoadPhotoShareList alloc]initWithRequestWithDic:dic];
    shareRequest.delegate=self;
    [shareRequest startAsynchronous];
}

///  request delegate
-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{
    
    [self.tableView refreshFinished];
    loadMoreView.state=LoadMoreStateNormal;
    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{
    
    if ([request isEqual:shareRequest]) {
        [self.tableView refreshFinished];
        if (isRefresh) {
            self.visibleImageArray=data;
        }else
        {
            NSMutableArray *tempArray=[NSMutableArray arrayWithArray:self.visibleImageArray];
            [tempArray addObjectsFromArray:data];
            self.visibleImageArray=tempArray;
        }
        if ([data count]==20) {
            self.tableView.tableFooterView=loadMoreView;
        }else
            self.tableView.tableFooterView=nil;
        loadMoreView.state=LoadMoreStateNormal;
    }
}

#pragma mark -UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"button index %d",buttonIndex);
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
#pragma mark -UIimageControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissModalViewControllerAnimated:YES];
    [self performSelector:@selector(showImageFilterWithImage:) withObject:[info objectForKey:@"UIImagePickerControllerOriginalImage"] afterDelay:0.5f];
}

-(void)didCancelViewViewController{
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)didFinishedAction:(id)sender{
    
    [self.tableView pullToRefresh];
}
@end
