//
//  EmailManage.h
//  DXQ
//
//  Created by 黄修勇 on 12-12-9.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface EmailManage : NSObject<MFMailComposeViewControllerDelegate>


+(void)showEmailViewControllerWithHandleViewController:(UIViewController *)controller sendToUser:(NSString *)user;

@end
