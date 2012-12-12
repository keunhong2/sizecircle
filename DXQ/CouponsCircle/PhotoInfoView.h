//
//  PhotoInfoView.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-17.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoInfoView : UIView

@property (nonatomic,retain)UIImage *userImage;
@property (nonatomic,retain)NSString *userName;
@property (nonatomic,retain)NSString *location;
@property (nonatomic,retain)NSString *infoSource;
@property (nonatomic,retain)NSString *dateString;
@property (nonatomic)NSInteger viewNumber;
@property (nonatomic,retain)NSString *imgUrl;

@end


@interface ViewNumberLabel : UIView

@property (nonatomic)NSInteger viewNumber;
@property (nonatomic,retain)UIFont *font;
@property (nonatomic,retain)UIColor *textColor;

@end