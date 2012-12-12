//
//  ScreenSelectCell.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-22.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenSelectCell : UITableViewCell<UITextFieldDelegate>{

    UIImageView *bgImgView;
}

@property (nonatomic,retain)UITextField *textField;

@property (nonatomic)BOOL showSelectPickerImageView;

@end
