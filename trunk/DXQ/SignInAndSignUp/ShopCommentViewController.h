//
//  ShopCommentViewController.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-9.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "CommentInputViewController.h"

@class ShopCommentViewController;

@protocol CommentViewDelegate <NSObject>

@optional
-(void)finishCommentViewController:(ShopCommentViewController *)commentViewController;
-(void)cancelCommentViewController:(ShopCommentViewController *)commentViewController;
@end
@interface ShopCommentViewController : CommentInputViewController<CommentInputDelegate>

@property (nonatomic,retain) NSDictionary *shopDic;
@property (nonatomic,retain)NSString *kindType;
@property (nonatomic,assign)id <CommentViewDelegate>commentDelegate;


-(id)initWithShopDic:(NSDictionary *)dic;

@end
