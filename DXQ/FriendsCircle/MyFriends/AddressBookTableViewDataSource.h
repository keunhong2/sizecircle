//
//  AddressBookTableViewDataSource.h
//  DXQ
//
//  Created by Yuan on 12-10-24.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressBookTableViewDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

-(id)initWithViewControl:(UIViewController *)viewControl;

@end
