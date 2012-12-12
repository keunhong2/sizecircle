//
//  MemberDetailBusinessInfoView.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberDetailView.h"

@interface MemberDetailBusinessInfoView : UIView


@property (nonatomic,retain)UIImageView *businessImageView;
@property (nonatomic,retain)UILabel *businessNameLabel;
@property (nonatomic,retain)UILabel *countDownLabel;
@property (nonatomic,retain)UILabel *outDateLabel;

@end


@interface MemberActionView : UIView

@property (nonatomic,readonly)UIButton *follwerBtn;
@property (nonatomic,readonly)UIButton *praiseBtn;
@property (nonatomic,readonly)UIButton *shareBtn;

@end


@interface MemberDetailHeaderView : MemberBaseBgView{
    
    MemberDetailBusinessInfoView *headerView;
    MemberActionView *actionView;
    UILabel *detailInfoLabel;
}

@property (nonatomic,retain)NSURL *businessImageURL;
@property (nonatomic,retain)NSString *businessName;
@property (nonatomic,retain)NSString *countDownTime;
@property (nonatomic,retain)NSString *outDate;
@property (nonatomic,retain)NSString *detail;
@property (nonatomic,readonly)MemberActionView *actionView;

@end