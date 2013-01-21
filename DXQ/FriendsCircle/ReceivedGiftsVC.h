//
//  ReceivedGiftsVC.h
//  DXQ
//
//  Created by Yuan on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceivedGiftsVC : BaseViewController

@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSArray *giftList;
@property (nonatomic,retain)NSString *userID;
@property (nonatomic,retain)NSArray *myGotGiftList;
@property (nonatomic,retain)NSArray *sendGiftList;
@property (nonatomic)BOOL isMyGotGift;//yes 我的收到的礼物 no 我送出的礼物

@end
