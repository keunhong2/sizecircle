//
//  LoadMoreView.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-26.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    LoadMoreStateNormal,
    LoadMoreStateRequesting,
    LoadMoreStateDisdisabled,
}LoadMoreState;

@interface LoadMoreView : UIView

@property (nonatomic)LoadMoreState state;//
@property (nonatomic,copy) void(^loadMoreBlock)(void);

@end
