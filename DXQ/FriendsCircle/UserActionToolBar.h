//
//  UserActionToolBar.h
//  DXQ
//
//  Created by Yuan on 12-10-20.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserActionToolBar : UIView

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action items:(NSArray *)itemsArray;
@end

@interface UIButtonUserInfoAction : UIView

typedef enum
{
    UIButtonUserInfoActionTypeGifts = 1,
    UIButtonUserInfoActionTypeChat,
    UIButtonUserInfoActionTypeAloha,
    UIButtonUserInfoActionTypeAddNewFriend,
    UIButtonUserInfoActionTypeMore,
    UIButtonUserInfoActionTypeReport,
    UIButtonUserInfoActionTypeAddBlackList
}UIButtonUserInfoActionType;

- (id)initWithFrame:(CGRect)frame image:(UIImage*)img title:(NSString *)title;

@end