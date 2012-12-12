//
//  TicketInfoHeaderView.h
//  DXQ
//
//  Created by 黄修勇 on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberDetailBusinessInfoView.h"

@interface TicketInfoHeaderView : MemberDetailHeaderView

@end



@interface TicketImagesView : UIView<UIScrollViewDelegate>{

    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSMutableArray *_imageViewArray;
}

@property (nonatomic,retain)NSArray *imageArray;


@end