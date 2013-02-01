//
//  MyEventViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-1.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "MyEventViewController.h"
#import "UserProductViewController.h"
#import "UserLoadFavoriteProductList.h"
#import "UIScrollView+AH3DPullRefresh.h"
#import "UserProductCell.h"
#import "UIImageView+WebCache.h"

@interface MyEventViewController ()<BusessRequestDelegate>{

    UserLoadFavoriteProductList *productList;
}
@end

@implementation MyEventViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavgationTitle:AppLocalizedString(@"我的活动") backItemTitle:AppLocalizedString(@"返回")];
}

#pragma mark -

-(void)setSegment:(UserProductSegmentControl *)segment{
    
    [super setSegment:segment];
    for (UIButton *btn in segment.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag==1) {
                NSString *notUserTitle=[NSString stringWithFormat:AppLocalizedString(@"有效的Product"),AppLocalizedString(@"活动")];
                [btn setTitle:notUserTitle forState:UIControlStateNormal];
            }else if (btn.tag==2)
            {
                NSString *userTitle=@"感兴趣的活动";
                [btn setTitle:userTitle forState:UIControlStateNormal];
            }
        }
    }
}

-(NSDictionary *)requestArgsDicByPage:(NSInteger)page{
    
    NSDictionary *pager=[NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%d",page],@"PageIndex",
                         [NSString stringWithFormat:@"%d",20],@"ReturnCount", nil];
    NSString *accountID=[[SettingManager sharedSettingManager]loggedInAccount];
    NSString *isPay=[self isSelectUntreatedType]==YES?@"0":@"1";
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       pager,@"Pager",
                       accountID,@"AccountId",
                       @"A",@"ProductType",
                       isPay,@"IsPayed",
                       @"-1",@"IsUsed", nil];
    return dic;
}

-(void)requestProductListByPage:(NSInteger)page{

    if ([self isSelectUntreatedType]) {
        [super requestProductListByPage:page];
    }else
    {
        [self cancelAllRequest];
        [self requestFavitList];
    }
}

-(void)cancelAllRequest{

    [super cancelAllRequest];
    [self cancelRequestFaviata];
}
-(void)cancelRequestFaviata{

    if (productList) {
        [productList cancel];
        [productList release];
        productList=nil;
    }
}

-(void)requestFavitList{

    [self cancelRequestFaviata];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[[SettingManager sharedSettingManager]loggedInAccount],@"AccountId", nil];
    productList=[[UserLoadFavoriteProductList alloc]initWithRequestWithDic:dic];
    productList.delegate=self;
    [productList startAsynchronous];
}


-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{

    if (request==productList) {

        self.visibleArray=data;
        [self.tableView refreshFinished];
        self.tableView.tableFooterView=nil;
    }else
        [super busessRequest:request didFinishWithData:data];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UserProductCell *cell=(UserProductCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([self isSelectUntreatedType]) {
        return cell;
    }else
    {
        NSDictionary *dic=[self.visibleArray objectAtIndex:indexPath.row];
        NSString *url=[[dic objectForKey:@"ThumbnailUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [cell.productImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil success:^(UIImage *image,BOOL isCache){
            [Tool setImageView:cell.productImageView toImage:image];
        } failure:nil];
        [cell.productNameLabel setText:[dic objectForKey:@"Address"]];
        [cell.exdateLabel setText:[Tool convertTimestampToNSDate:[[dic objectForKey:@"AddDate"] integerValue]]];
        return cell;
    }
}
@end
