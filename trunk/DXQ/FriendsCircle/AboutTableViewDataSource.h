//
//  AboutTableViewDataSource.h
//  DXQ
//
//  Created by Yuan on 12-10-20.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AboutTableViewDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

-(id)initWithViewControl:(UIViewController *)viewControl;

-(void)reloadData:(NSString *)accountID;

@end
