//
//  ActivityTableViewDataSource.h
//  DXQ
//
//  Created by Yuan on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityTableViewDataSource : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)NSArray *data;

-(id)initWithDataList:(NSArray *)dataList viewControl:(UIViewController *)viewControl;

@end
