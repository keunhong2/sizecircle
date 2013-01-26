//
//  AreaSelectView.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-9.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "AreaSelectView.h"

@interface AreaSelectView ()<UIPickerViewDataSource,UIPickerViewDelegate>{

    UIToolbar *_toolBar;
    UIPickerView *_pickerView;
    
}

@end
@implementation AreaSelectView

-(void)dealloc{

    _delegate=nil;
    [_toolBar release];
    [_pickerView release];
    [areaArray release];
    [super dealloc];
}

-(id)init{

    CGRect bounds=[UIScreen mainScreen].bounds;
    return [self initWithFrame:CGRectMake(0.f, 0.f, bounds.size.width, 216.f+44.f)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        areaArray=[[NSArray alloc]initWithObjects:@"不限",@"白云区",@"花都区",@"海珠区",@"荔湾区",@"番禺区",@"天河区",@"越秀区",@"周边", nil];
        _toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, 44.f)];
        _toolBar.barStyle=UIBarStyleBlackTranslucent;
        _toolBar.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        
        UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDone:)];
        UIBarButtonItem *spaceItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnDone:)];
        NSArray *items=[NSArray arrayWithObjects:cancelItem,spaceItem,doneItem, nil];
        [cancelItem release];
        [spaceItem release];
        [doneItem release];
        _toolBar.items=items;
        [self addSubview:_toolBar];
        
        _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 44.f, self.frame.size.width, self.frame.size.height-44.f)];
        _pickerView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _pickerView.showsSelectionIndicator=YES;
        _pickerView.delegate=self;
        _pickerView.dataSource=self;
        [self addSubview:_pickerView];
    }
    return self;
}

-(id)initWithDelegate:(id<AreaSelectDelegate>)delegate{

    CGRect bounds=[UIScreen mainScreen].bounds;
    self=[self initWithFrame:CGRectMake(0.f, 0.f, bounds.size.width, 216.f+44.f)];
    if (self) {
        self.delegate=delegate;
    }
    return self;
}

-(void)setRowByText:(NSString *)text{

    NSInteger row=0;
    row=[areaArray indexOfObject:text];
    [_pickerView selectRow:row inComponent:0 animated:YES];
}
#pragma mark -Action

-(void)cancelDone:(id)sender{

    if (_delegate&&[_delegate respondsToSelector:@selector(cancelDoneAreaSelectView:)]) {
        [_delegate cancelDoneAreaSelectView:self];
    }
}

-(void)doneBtnDone:(id)sender{

    if (_delegate&&[_delegate respondsToSelector:@selector(doneSelectAreaSelectView:)]) {
        [_delegate doneSelectAreaSelectView:self];
    }
}

#pragma mark-UIPickerViewDataSouce And Delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return areaArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return [areaArray objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (_delegate&&[_delegate respondsToSelector:@selector(areaSelectView:didSelectArea:)]) {
        [_delegate areaSelectView:self didSelectArea:[areaArray objectAtIndex:row]];
    }
}
@end

