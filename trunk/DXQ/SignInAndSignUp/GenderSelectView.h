//
//  GenderSelectView.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GenderSelectView;

@protocol GenderSelectViewDelegate <NSObject>

@optional

-(void)genderSelectViewDidCancel:(GenderSelectView *)genderSelectView;

-(void)genderSelectViewDidDone:(GenderSelectView *)genderSelectView;

-(void)genderSelectView:(GenderSelectView *)genderSelectView genderChanageMale:(BOOL)isMale;

@end

@interface GenderSelectView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,assign)id<GenderSelectViewDelegate>delegate;

@property (nonatomic)BOOL male;

-(void)setMale:(BOOL)male animated:(BOOL)animated;

@end
