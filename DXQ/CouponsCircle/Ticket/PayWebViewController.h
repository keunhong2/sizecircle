//
//  PayWebViewController.h
//  DXQ
//
//  Created by 黄修勇 on 13-2-19.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseViewController.h"

@interface PayWebViewController : BaseViewController

@property (nonatomic,retain)UIWebView *webView;

-(void)payProductName:(NSString *)name order:(NSString *)order money:(float)money;

@end
