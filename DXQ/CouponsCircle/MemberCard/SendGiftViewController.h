//
//  SendGiftViewController.h
//  DXQ
//
//  Created by 黄修勇 on 13-1-27.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseViewController.h"

@interface SendGiftViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

-(id)initWithProductDic:(NSDictionary *)productDic;

@property (nonatomic,retain)NSDictionary *productDic;
@property (nonatomic,retain)NSIndexPath *selectIndexPath;

@end
