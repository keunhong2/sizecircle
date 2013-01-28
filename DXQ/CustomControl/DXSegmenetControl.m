//
//  DXSegmenetControl.m
//  DXQ
//
//  Created by 黄修勇 on 13-1-28.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "DXSegmenetControl.h"
#import "UIColor+ColorUtils.h"

@interface DXSegmenetControl (){

    NSMutableArray *btnArray;
}

@end
@implementation DXSegmenetControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        btnArray=[NSMutableArray new];
    }
    return self;
}

-(void)dealloc{

    [btnArray release];
    [super dealloc];
}


-(id)initWithItems:(NSArray *)items{

    self=[self initWithFrame:CGRectZero];
    if (self) {
        self.items=items;
    }
    return self;
}

-(void)setSelectIndex:(NSInteger)selectIndex{

    if (selectIndex==_selectIndex||selectIndex>=btnArray.count) {
        return;
    }
    UIButton *btn=[btnArray objectAtIndex:_selectIndex];
    btn.selected=NO;
    btn=[btnArray objectAtIndex:selectIndex];
    btn.selected=YES;
    _selectIndex=selectIndex;
}

-(void)btnAction:(UIButton *)btn{

    self.selectIndex=[btnArray indexOfObject:btn];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)setItems:(NSArray *)items{

    if ([items isEqualToArray:_items]) {
        return;
    }
    [_items release];
    _items=[items retain];
    
    for (UIView *view in btnArray) {
        [view removeFromSuperview];
    }
    [btnArray removeAllObjects];
    UIColor *normalTitlColor=[UIColor colorWithString:@"#605D58"];
    UIColor *hightedTitleColor=[UIColor colorWithString:@"#FFFFFF"];
    UIColor *shawnColorOne=[UIColor colorWithString:@"#414141"];
    UIColor *shawnColorTwo=[UIColor colorWithString:@"#FFFFFF"];
    
    UIImage *normalImg=[UIImage imageNamed:@"label"];
    UIImage *hightedImg=[UIImage imageNamed:@"label_hot"];
    
    for (int i=0; i<items.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[items objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:normalTitlColor forState:UIControlStateNormal];
        [btn setTitleColor:hightedTitleColor forState:UIControlStateSelected];
        [btn setTitleShadowColor:shawnColorTwo forState:UIControlStateNormal];
        [btn setTitleShadowColor:shawnColorOne forState:UIControlStateSelected];
        [btn setBackgroundImage:normalImg forState:UIControlStateNormal];
        [btn setBackgroundImage:hightedImg forState:UIControlStateSelected];
        btn.titleLabel.shadowOffset=CGSizeMake(0.f, 1.f);
        btn.titleLabel.font=[UIFont systemFontOfSize:16.f];
        [btnArray addObject:btn];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i==0) {
            btn.selected=YES;
        }
    }
    self.selectIndex=0;
    [self layoutSubviews];
}

-(void)layoutSubviews{

    float width=self.frame.size.width/btnArray.count;
    
    for (int i=0; i<btnArray.count; i++) {
        UIView *view=[btnArray objectAtIndex:i];
        view.frame=CGRectMake(i*width, 0.f, width, self.frame.size.height);
        [self addSubview:view];
    }
}
@end
