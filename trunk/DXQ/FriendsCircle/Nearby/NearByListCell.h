//
//  NearByListCell.h
//  DXQ
//
//  Created by Yuan on 12-10-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByListCell : UITableViewCell
{
	UIButton *avatarImg;
	UILabel *usernameLbl;
    
    UIImageView *ageImg;
	UILabel *ageLbl;
	UILabel *distanceLbl;
    
    UILabel *statusLbl;
}
@property (nonatomic,retain)UIButton *avatarImg;
@property (nonatomic,retain)UILabel *usernameLbl;
@property (nonatomic,retain)UIImageView *ageImg;
@property (nonatomic,retain)UILabel *ageLbl;
@property (nonatomic,retain)UILabel *distanceLbl;
@property (nonatomic,retain)UILabel *statusLbl;
@end
