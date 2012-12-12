//
//  RegisterPhotoViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RegisterPhotoViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,readonly)UIImageView *headImageView;

@end
