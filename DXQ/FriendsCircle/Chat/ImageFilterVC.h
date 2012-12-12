//
//  ImageFilterVC.h
//  DXQ
//
//  Created by Yuan on 12-11-26.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UploadPhoto.h"

@interface ImageFilterVC : BaseViewController<UniversalViewControlDelegate>

- (id)initWithImage:(UIImage *)image type:(NSString *)type;

@property (nonatomic,retain)NSString *productID;//

@end
