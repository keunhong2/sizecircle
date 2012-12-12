//
//  AreaSelectView.h
//  DXQ
//
//  Created by 黄修勇 on 12-11-9.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AreaSelectView;
@protocol AreaSelectDelegate <NSObject>

@optional
-(void)areaSelectView:(AreaSelectView *)areaSelectView didSelectArea:(NSString *)area;
-(void)cancelDoneAreaSelectView:(AreaSelectView *)areaSelectView;
-(void)doneSelectAreaSelectView:(AreaSelectView *)areaSelectView;
@end
@interface AreaSelectView : UIView

-(id)initWithDelegate:(id<AreaSelectDelegate>)delegate;

@property (nonatomic,assign)id<AreaSelectDelegate>delegate;

-(void)setRowByText:(NSString *)text;

@end
