//
//  UserMemberCell.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserMemberCell : UITableViewCell
{
    id tapTarget;
    SEL _action;
}
@property (nonatomic,retain)NSArray *userMemberArray;//

-(void)setTarget:(id)target action:(SEL)action;

@end



@interface UserMemberView : UIControl


@property (nonatomic,retain)UIImageView *memberImageView;
@property (nonatomic,retain)UILabel *memberNameLabel;

@end