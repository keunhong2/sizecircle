//
//  LoadMoreView.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-26.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "LoadMoreView.h"

@interface LoadMoreView (){

    UIButton *btn;
    UIActivityIndicatorView *activityView;
    
    //state title
    
}

@end
@implementation LoadMoreView

-(void)dealloc{

    if (_loadMoreBlock) {
        Block_release(_loadMoreBlock);
    }
    [activityView release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=[UIColor clearColor];
        UIImage *btnImg=[UIImage imageNamed:@"load_more_button"];
        UIImage *selectedImg=[UIImage imageNamed:@"load_more_selected_button"];
        btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:btnImg forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn setBackgroundImage:selectedImg forState:UIControlStateHighlighted];
        [btn setBackgroundImage:selectedImg forState:UIControlStateSelected];
        UIColor *normalColor=[UIColor colorWithRed:55.f/255.f green:55.f/255.f blue:55.f/255.f alpha:1.0f];
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitle:@"显示下20条" forState:UIControlStateNormal];
        [btn setTitle:@"正在加载中..." forState:UIControlStateSelected];
        [btn setTitleShadowColor:normalColor forState:UIControlStateHighlighted];
        [btn setTitleShadowColor:normalColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnDone) forControlEvents:UIControlEventTouchUpInside];
        [btn.titleLabel setShadowOffset:CGSizeMake(0.f, 1.f)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
        [self addSubview:btn];
        
        activityView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame=CGRectMake(60.f, btn.frame.size.height/2-activityView.frame.size.height/2, activityView.frame.size.width, activityView.frame.size.height);
        activityView.hidesWhenStopped=YES;
        [activityView stopAnimating];
        [btn addSubview:activityView];
    }
    return self;
}

-(void)layoutSubviews{

    btn.frame=CGRectMake((self.frame.size.width-btn.frame.size.width)/2, (self.frame.size.height-btn.frame.size.height)/2, btn.frame.size.width, btn.frame.size.height);
}

-(void)btnDone{

    if (self.state==LoadMoreStateNormal) {
        _loadMoreBlock();
        self.state=LoadMoreStateRequesting;
    }
}

-(void)setState:(LoadMoreState)state{

    if (state==_state) {
        return;
    }
    _state=state;
    
    switch (state) {
        case LoadMoreStateNormal:
        {
            [activityView stopAnimating];
            btn.userInteractionEnabled=YES;
            btn.selected=NO;
        }
            break;
        case LoadMoreStateRequesting:
        {
            [activityView startAnimating];
            btn.selected=YES;
            btn.userInteractionEnabled=NO;
        }
            break;
        case LoadMoreStateDisdisabled:
        {
            [activityView stopAnimating];
            btn.selected=NO;
            btn.userInteractionEnabled=NO;
            
        }
            break;
            
        default:
            break;
    }
}
@end
