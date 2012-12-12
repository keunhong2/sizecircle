//
//  PhotoCommentCell.h
//  DXQ
//
//  Created by Yuan on 12-11-29.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCommentCell : UITableViewCell
{
    UIButton *iconButton;//头像
    UILabel *aliasLable; //昵称
    UILabel *timeLbl; //时间
    UITextView *contentLbl;//评论
}
@property(nonatomic,retain)UIButton *iconButton;
@property(nonatomic,retain)UILabel *aliasLable;
@property(nonatomic,retain)UILabel *timeLbl;
@property(nonatomic,retain)UITextView *contentLbl;
@end