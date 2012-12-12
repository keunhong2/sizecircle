//
//  GenderSelectView.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-11.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "GenderSelectView.h"

@interface GenderSelectView ()
{
    UIToolbar *toolBar;
    UIPickerView *malePickerView;
}
@end
@implementation GenderSelectView

@synthesize delegate=_delegate;
@synthesize male=_male;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
       
        self.backgroundColor=[UIColor clearColor];
        
        toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, 44.f)];
        toolBar.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        toolBar.barStyle=UIBarStyleBlackTranslucent;
        [self addSubview:toolBar];
        
        UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnDone)];
        UIBarButtonItem *flexiItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnDone)];
        NSArray *array=[NSArray arrayWithObjects:cancelItem,flexiItem,doneBtn, nil];
        [cancelItem release];
        [flexiItem release];
        [doneBtn release];
        
        toolBar.items=array;
     
        malePickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 44.f, self.frame.size.width, self.frame.size.height-44.f)];
        malePickerView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        malePickerView.dataSource=self;
        malePickerView.delegate=self;
        malePickerView.showsSelectionIndicator=YES;
        [self addSubview:malePickerView];
    }
    return self;
}

-(void)dealloc{

    [toolBar release];
    [malePickerView release];
    [super dealloc];
}

-(void)setMale:(BOOL)male{

    [self setMale:male animated:NO];
}

-(void)setMale:(BOOL)male animated:(BOOL)animated{

    if (_male==male) {
        return;
    }
    _male=male;
    
    NSInteger row=male==YES?0:1;
    [malePickerView selectRow:row inComponent:0 animated:animated];
}

#pragma mark -Button Action

-(void)cancelBtnDone
{
    if (_delegate && [_delegate respondsToSelector:@selector(genderSelectViewDidCancel:)]) {
        [_delegate genderSelectViewDidCancel:self];
    }
}

-(void)doneBtnDone{

    if (_delegate &&[_delegate respondsToSelector:@selector(genderSelectViewDidDone:)]) {
        [_delegate genderSelectViewDidDone:self];
    }
}

#pragma mark -

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (_delegate &&[_delegate respondsToSelector:@selector(genderSelectView:genderChanageMale:)]) {
        [_delegate genderSelectView:self genderChanageMale:(row==0?YES:NO)];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return 2;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    return row==0? AppLocalizedString(@"男"):AppLocalizedString(@"女");
}
@end
