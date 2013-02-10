//
//  BlindTelPhoneView.h
//  DXQ
//
//  Created by 黄修勇 on 13-2-10.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BlindTelPhoneView;
@protocol BlindTelPhoneDelegate <NSObject>

-(void)binldTelPhoneView:(BlindTelPhoneView *)view didFinishSendPhone:(NSString *)phone;

@end


@interface BlindTelPhoneView : UIView

@property (nonatomic,assign)id<BlindTelPhoneDelegate>delegate;

@end
