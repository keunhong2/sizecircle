//
//  BeautyContestViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-24.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BeautyContestViewController.h"
#import "UserLoadChooseList.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "ScreenViewController.h"
#import "UserLoadChooseDetail.h"
#import "LoadMoreView.h"
#import "UIImageView+WebCache.h"
#import "OldBeautyDetailViewController.h"
#import "UserDetailInfoVC.h"

@interface BeautyContestViewController ()<CustomSegmentedControlDelegate,BusessRequestDelegate>{

    UserLoadChooseList *oldRequest;
    UserLoadChooseDetail *currentRequest;
    BOOL isRefrsh;
    BOOL isCurrentFinish;
    BOOL isOldFinish;
    LoadMoreView *loadMoreView;
}

@end

@implementation BeautyContestViewController

-(void)dealloc{

    [_currentPerDic release];
    [_oldPerImageArray release];
    [loadMoreView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _currentPeriodical=YES;
    }
    return self;
}

-(void)loadView{

    [super loadView];
    
    loadMoreView=[[LoadMoreView alloc]initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, 60.f)];
    [loadMoreView setLoadMoreBlock:^{
        [self requestOldPerByPage:self.oldPerImageArray.count/20+1];
    }];
    
    if (_currentPeriodical) {
        [self.tableView setPullToRefreshHandler:^{
            
            [self requestCurrent];
        }];
        self.tableView.tableFooterView=nil;
    }else{
        [self.tableView setPullToRefreshHandler:^{
            
            [self requestOldPerByPage:1];
        }];
        if (isOldFinish) {
            
            self.tableView.tableFooterView=loadMoreView;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *item1 = [NSDictionary dictionaryWithObjectsAndKeys:AppLocalizedString(@"本期"),@"title",@"pyq_l",@"img", nil];
    NSDictionary *item2 = [NSDictionary dictionaryWithObjectsAndKeys:AppLocalizedString(@"往期"),@"title",@"pyq_r",@"img", nil];
    NSArray *items = [NSArray arrayWithObjects:item1,item2, nil];
    CustomSegmentedControl *segment = [[CustomSegmentedControl alloc]initWithFrame:CGRectZero items:items defaultSelectIndex:_currentPeriodical==YES?0:1];
    segment.delegate = self;
    self.navigationItem.titleView=segment;
    [segment release];
}

-(void)viewDidUnload{

    [super viewDidUnload];
    [loadMoreView release];
    loadMoreView=nil;
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    if (([self isCurrentPeriodical]&&_currentPerDic==nil)||([self isCurrentPeriodical]==NO&&_oldPerImageArray==nil))
        [self.tableView pullToRefresh];
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [self cancelAllRequest];
}


#pragma mark -Image touch 

-(void)imageViewTapIndex:(NSIndexPath *)indexPath imageView:(UIImageView *)imageView{
    
    [super imageViewTapIndex:indexPath imageView:imageView];
}

#pragma mark -Request

-(void)cancelAllRequest{

    if (currentRequest) {
        [currentRequest cancel];
        [currentRequest release];
        currentRequest=nil;
    }
    if (oldRequest) {
        [oldRequest cancel];
        [oldRequest release];
        oldRequest=nil;
    }
    loadMoreView.state=LoadMoreStateNormal;
}

-(void)requestOldPerByPage:(NSInteger)page{

    if (oldRequest) {
        [oldRequest cancel];
        [oldRequest release];
        oldRequest=nil;
    }
    
    if (page==1) {
        isRefrsh=YES;
    }else
        isRefrsh=NO;
    
    NSDictionary *pager=[NSDictionary dictionaryWithObjectsAndKeys:
           [NSString stringWithFormat:@"%d",page],@"PageIndex",
           [NSString stringWithFormat:@"%d",20],@"ReturnCount", nil];
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accountID,@"AccountId",pager,@"Pager", nil];
    loadMoreView.state=LoadMoreStateRequesting;
    oldRequest=[[UserLoadChooseList alloc]initWithRequestWithDic:dic];
    oldRequest.delegate=self;
    [oldRequest startAsynchronous];
}

-(void)requestCurrent{

    if (currentRequest) {
        [currentRequest cancel];
        [currentRequest release];
        currentRequest=nil;
    }
    NSString *accoundID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:accoundID,@"AccountId",@"-1",@"ChooseId", nil];
    currentRequest=[[UserLoadChooseDetail alloc]initWithRequestWithDic:dic];
    currentRequest.delegate=self;
    [currentRequest startAsynchronous];
}

//delegate

-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{

    [[ProgressHUD sharedProgressHUD]showInView:self.view];
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    loadMoreView.state=LoadMoreStateNormal;
    [self.tableView refreshFinished];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    loadMoreView.state=LoadMoreStateNormal;
    [self.tableView refreshFinished];
    
    if ([request isEqual:currentRequest]) {
        self.currentPerDic=data;
        self.visibleImageArray=[data objectForKey:@"MemberList"];
        [self.tableView reloadData];
    }else if ([request isEqual:oldRequest])
    {
        if (!isRefrsh) {
            NSMutableArray *tempArray=[NSMutableArray arrayWithArray:_oldPerImageArray];
            [tempArray addObjectsFromArray:data];
            self.oldPerImageArray=tempArray;
        }else
            self.oldPerImageArray=data;
        self.visibleImageArray=[self oldPerImageArray];
        
        if ([data count]==20) {
            isOldFinish=NO;
            self.tableView.tableFooterView=loadMoreView;
        }else
        {
            isOldFinish=YES;
            self.tableView.tableFooterView=nil;
        }
    }
}

#pragma mark -UITableViewDelegate And Datasouce

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (_currentPeriodical) {
        return 1;
    }else
        return _oldPerImageArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (_currentPeriodical) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }else
        return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (_currentPeriodical) {
        return nil;
    }else
    {
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, tableView.frame.size.width, 20.f)];
        view.backgroundColor=[UIColor colorWithRed:242.f/255.f green:242.f/255.f blue:242.f/255.f alpha:1.f];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15.f, 0.f, view.frame.size.width, 20.f)];
        label.textColor=[UIColor colorWithRed:173.f/255.f green:173.f/255.f blue:173.f/255.f alpha:1.f];
        label.text=[NSString stringWithFormat:AppLocalizedString(@"第%d期"),section+1];
        label.font=[UIFont systemFontOfSize:14.f];
        label.backgroundColor=[UIColor clearColor];
        [view addSubview:label];
        [label release];
        return [view autorelease];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (_currentPeriodical) {
        return 0.f;
    }else
        return 20.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (_currentPeriodical) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }else
        return 110.f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (_currentPeriodical) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }else
    {
        UITableViewCell * cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"none"] autorelease];
        NSArray *memberList=[[_oldPerImageArray objectAtIndex:indexPath.row] objectForKey:@"MemberList"];
        for (int i=0; i<memberList.count; i++) {
            NSDictionary *dic=[memberList objectAtIndex:i];
            NumberImageView *numberImageView=[[NumberImageView alloc]initWithFrame:CGRectMake(5+(100.f+5)*i, 5.f, 100.f, 100.f)];
            numberImageView.number=i+1;
            [numberImageView setImageByDic:dic];
            [cell.contentView addSubview:numberImageView];
            [numberImageView release];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (!_currentPeriodical) {
        OldBeautyDetailViewController *detail=[[OldBeautyDetailViewController alloc]init];
        detail.beautyDic=[_oldPerImageArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
    }
}

#pragma mark -set method

-(void)setCurrentPeriodical:(BOOL)currentPeriodical{

    if (currentPeriodical==_currentPeriodical) {
        return;
    }
    _currentPeriodical=currentPeriodical;
   
    [self cancelAllRequest];
    
    if (currentPeriodical) {
        self.visibleImageArray=[_currentPerDic objectForKey:@"MemberList"];
        [self.tableView setPullToRefreshHandler:^{
        
            [self requestCurrent];
        }];
        if (!_currentPerDic) {
            [self.tableView pullToRefresh];
        }
        self.tableView.tableFooterView=nil;
    }else{
        self.visibleImageArray=_oldPerImageArray;
        
        
        [self.tableView setPullToRefreshHandler:^{
        
            [self requestOldPerByPage:1];
        }];
        if (!_oldPerImageArray) {
            [self.tableView pullToRefresh];
        }else
        {
            if (!isOldFinish) {
                self.tableView.tableFooterView=loadMoreView;
            }
        }
    }
}

#pragma mark -CustomSegmentDelegate

-(void)didSelectIndex:(NSUInteger)selectedIndex withSegmentControl:(CustomSegmentedControl*)segmentControl{
    
    if (selectedIndex==0) {
        self.currentPeriodical=YES;
    }else
        self.currentPeriodical=NO;
}
@end


#pragma mark -New Class

@implementation NumberView

-(void)dealloc{

    [bgImgView release];
    [numberLabel release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame{

    UIImage *numberBgImg=[UIImage imageNamed:@"xm_goal_bg"];
    self=[super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, numberBgImg.size.width, numberBgImg.size.height)];
    if (self) {
        bgImgView=[[UIImageView alloc]initWithImage:numberBgImg];
        bgImgView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:bgImgView];
        numberLabel=[[UILabel alloc]initWithFrame:self.bounds];
        numberLabel.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        numberLabel.backgroundColor=[UIColor clearColor];
        numberLabel.textColor=[UIColor blackColor];
        numberLabel.textAlignment=UITextAlignmentCenter;
        numberLabel.font=[UIFont systemFontOfSize:14.f];
        [self addSubview:numberLabel];
    }
    return self;
}

-(void)setNumber:(NSInteger)number{

    if (number==_number) {
        return;
    }
    _number=number;
    numberLabel.text=[NSString stringWithFormat:@"%d",number];
}

@end

@interface NumberImageView (){

    NumberView *numberView;
}

@end

@implementation NumberImageView

-(void)dealloc{

    [numberView release];
    [_imageView release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if (self) {
        _imageView=[[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.contentMode=UIViewContentModeScaleAspectFit;
        _imageView.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _imageView.layer.borderColor=[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.4f].CGColor;
        _imageView.layer.borderWidth=2.f;
        _imageView.backgroundColor=[UIColor grayColor];
        [self addSubview:_imageView];
        
        numberView=[[NumberView alloc]initWithFrame:CGRectMake(1.f, 1.f, 10.f, 10.f)];
        numberView.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:numberView];
    }
    return self;
}

-(void)setNumber:(NSInteger)number{

    numberView.number=number;
}

-(NSInteger)number{

    return numberView.number;
}

-(void)setImageByDic:(NSDictionary *)dic{

    NSString *url=[dic objectForKey:@"PhotoUrl"];
    NSString *encodeUrl=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_imageView setImageWithURL:[NSURL URLWithString:encodeUrl] placeholderImage:nil success:^(UIImage *image,BOOL isCache){
    
        if (image) {
            if (image.size.width<_imageView.frame.size.width&&image.size.height<_imageView.frame.size.height) {
                _imageView.frame=CGRectMake((self.frame.size.width-image.size.width)/2, (self.frame.size.height-image.size.height)/2, image.size.width, image.size.height);
            }else
            {
                float imgScale=image.size.width/image.size.height;
                
                float viewScale=_imageView.frame.size.width/_imageView.frame.size.height;
                if (imgScale>viewScale) {
                    float imageHeight=_imageView.frame.size.width/imgScale;
                    _imageView.frame=CGRectMake(0.f, (self.frame.size.height-imageHeight)/2, _imageView.frame.size.width, imageHeight);
                }else
                {
                    float imageWidth=_imageView.frame.size.height*imgScale;
                    _imageView.frame=CGRectMake((self.frame.size.width-imageWidth)/2, 0.f, imageWidth, _imageView.frame.size.height);
                }
                numberView.frame=CGRectMake(_imageView.frame.origin.x+1.f, _imageView.frame.origin.y+1.f, numberView.frame.size.width, numberView.frame.size.height);
            }
        }
    } failure:nil];
}
@end
