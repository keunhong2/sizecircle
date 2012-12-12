//
//  FriendsListCell.m
//  DXQ
//
//  Created by Yuan on 12-12-1.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "FriendsListCell.h"

@implementation FriendsListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        avatarImg.userInteractionEnabled = YES;
        
        self.ageImg.hidden = YES;
        self.ageLbl.hidden = YES;
        self.distanceLbl.hidden = YES;
        
        CGRect avatarFrame = self.avatarImg.frame;
        avatarFrame.size.width = 40.0f;
        avatarFrame.size.height = 40.0f;
        self.avatarImg.frame = avatarFrame;
        
        CGRect aliasFrame = self.usernameLbl.frame;
        aliasFrame.origin.x = 56.0f;
        self.usernameLbl.frame = aliasFrame;
        
        CGRect statusFrame = self.statusLbl.frame;
        statusFrame.origin.x = 56.0f;
        statusFrame.origin.y = 30.0f;
        self.statusLbl.frame = statusFrame;
        
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
