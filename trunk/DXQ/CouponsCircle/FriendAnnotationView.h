//
//  FriendAnnotationView.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-13.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface FriendAnnotationView : MKAnnotationView

@property (nonatomic,readonly)UIImageView *headerImageView;
@property (nonatomic,assign)NSInteger age;
@property (nonatomic,assign)BOOL male;//sex YES

@end

@interface FriendSexAndAgeView : UIView

@property (nonatomic,readonly)UIImageView *genderImageView;
@property (nonatomic,readonly)UILabel *ageLabel;
@property (nonatomic)BOOL male;//default YES
@property (nonatomic)NSInteger age;//default 18

-(id)initWithGender:(BOOL)male;

@end