//
//  PhotoDetailViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-16.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseViewController.h"
#import "PhotoInfoView.h"

@class PhotoDetailTopView;

@interface PhotoDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)PhotoDetailTopView *photoTopView;
@property (nonatomic,retain)PhotoInfoView *photoInfoView;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSDictionary *imgInfoDic;//
@property (nonatomic,retain)NSDictionary *imgDetailDic;
@property (nonatomic,retain)NSArray *commantArray;
@property (nonatomic,retain)NSString *imageIdKey;

-(id)initWithImageInfoDic:(NSDictionary *)dic;

@end



@interface PhotoDetailTopView : UIView{

    @private
    UIImageView *bgImgView;
}

@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,readonly)UIButton *goodBtn;
@property (nonatomic,readonly)UIButton *commentBtn;

@end

