//
//  MemberDetailView.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberBaseBgView : UIView

@end

@class MemberDetailView;

@protocol MemberDetailViewDelegate <NSObject>

@optional

-(void)memberDetailView:(MemberDetailView *)memberView imageTapIsFirst:(BOOL)isFirst;

@end

@interface MemberDetailView : MemberBaseBgView

@property (nonatomic,retain)NSString *firstLineText;
@property (nonatomic,retain)NSString *secoundLineText;
@property (nonatomic,retain)UIImage *firstImage;
@property (nonatomic,retain)UIImage *secoundImage;
@property (nonatomic)BOOL imageLocationLeft;
@property (nonatomic,assign)id<MemberDetailViewDelegate>delegate;

@end