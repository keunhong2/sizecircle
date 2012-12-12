//
//  CouponsBottomBar.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-16.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "CouponsBottomBar.h"

@implementation CouponsBottomBar

@synthesize selectIndex=_selectIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 320.f, 49.f)];
    if (self)
    {
        // Initialization code
        NSArray *normalImageArray=[NSArray arrayWithObjects:@"about_menu",@"trends_menu",@"pic_menu", nil];
        for (int i=0; i<normalImageArray.count; i++) {
            UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
            float weidth=320.f/normalImageArray.count;
            btn.frame=CGRectMake(weidth*i, 0.f, weidth, 49.f);
            NSString *name=[normalImageArray objectAtIndex:i];
            NSString *normalPath=[[NSBundle mainBundle]pathForResource:name ofType:@"png"];
            UIImage *normalImage=[UIImage imageWithContentsOfFile:normalPath];
            [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
            
            NSString *hightedPath=[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@_highted",name] ofType:@"png"];
            UIImage *hightedImage=[UIImage imageWithContentsOfFile:hightedPath];
            [btn setBackgroundImage:hightedImage forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnDone:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag=i+1;
            [self addSubview:btn];
            _selectIndex=-1;
        }
    }
    return self;
}


-(void)btnDone:(UIButton *)btn{

    NSInteger index=btn.tag-1;
    if (index!=_selectIndex)
    {
        self.selectIndex=btn.tag-1;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

-(void)setSelectIndex:(NSInteger)selectIndex{
    
    if (selectIndex==_selectIndex) {
        return;
    }
    UIButton *lastSelectBtn=(UIButton *)[self viewWithTag:_selectIndex+1];
    lastSelectBtn.selected=NO;
    _selectIndex=selectIndex;
    UIButton *selectBnt=(UIButton *)[self viewWithTag:selectIndex+1];
    selectBnt.selected=YES;
}

@end
