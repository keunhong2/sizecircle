//
//  WriteSignatureVC.h
//  DXQ
//
//  Created by Yuan on 12-11-14.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteSignatureVC : BaseViewController
{
    NSInteger CHARACTER_MAXNUMBERS;

    UILabel *countLbl;
    
    UITextView *txtView;
}
@property(nonatomic,retain)UITextView *txtView;

@property(nonatomic)NSInteger CHARACTER_MAXNUMBERS;

@property(nonatomic,retain)UILabel *countLbl;

@end
