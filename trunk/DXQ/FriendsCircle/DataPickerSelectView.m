//
//  DataPickerSelectView.m
//  MeiXiu
//
//  Created by Yuan on 12-11-11.
//
//

#import "DataPickerSelectView.h"



@interface DataPickerSelectView ()
{
    NSMutableArray *dataArray;
    UIToolbar *toolBar;
    UIPickerView *pickerView;
    UIDatePicker *datePickerView;
    UIView *superView;
    DataPickerSelectViewType dataPickerSelectViewType;
}

@property(nonatomic,retain)UIPickerView *pickerView;
@property(nonatomic,retain)UIDatePicker *datePickerView;
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,retain)UIView *superView;
@property(nonatomic,retain)UIToolbar *toolBar;

@end
@implementation DataPickerSelectView

@synthesize delegate=_delegate;
@synthesize dataArray = _dataArray;
@synthesize superView = _superView;
@synthesize toolBar = _toolBar;
@synthesize pickerView = _pickerView;
@synthesize datePickerView = _datePickerView;
@synthesize indexPath = _indexPath;

-(void)dealloc
{
    [_indexPath release];_indexPath = nil;
    [_datePickerView release];_datePickerView = nil;
    [_superView release];_superView = nil;
    [_dataArray release];_dataArray = nil;
    [_toolBar release];_toolBar = nil;
    [_pickerView release];_pickerView = nil;
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title inPutViewSuperView:(UIView *)sv style:(DataPickerSelectViewType)style
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _superView = sv;
        
        dataPickerSelectViewType =  style;
        
        _dataArray = [[NSMutableArray alloc]init];
        
        self.backgroundColor=[UIColor redColor];
        
        _toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, 44.f)];
        _toolBar.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        _toolBar.barStyle=UIBarStyleBlackTranslucent;
        [self addSubview:_toolBar];
        
        UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnDone)];
        UIBarButtonItem *flexiItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnDone)];
        NSArray *array=[NSArray arrayWithObjects:cancelItem,flexiItem,doneBtn, nil];
        [cancelItem release];
        [flexiItem release];
        [doneBtn release];
        
        UILabel *titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(60,8,180,30)];
        titleLbl.text = title;
        titleLbl.tag = 100;
        [titleLbl setFont:[UIFont boldSystemFontOfSize:18.0]];
        [titleLbl setTextAlignment:UITextAlignmentCenter];
        [titleLbl setBackgroundColor:[UIColor clearColor]];
        [titleLbl setTextColor:[UIColor whiteColor]];
        [_toolBar addSubview:titleLbl];
        [titleLbl release];
        
        _toolBar.items=array;
                
        if (dataPickerSelectViewType == DataPickerSelectViewTypeCommen)
        {
            _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 44.f, self.frame.size.width, self.frame.size.height-44.f)];
            _pickerView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            _pickerView.dataSource=self;
            _pickerView.delegate=self;
            _pickerView.showsSelectionIndicator=YES;
            [self addSubview:_pickerView];
        }
        else
        {
            _datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.f, 44.f, self.frame.size.width, self.frame.size.height-44.f)];
            [_datePickerView setMaximumDate:[NSDate date]];
            [_datePickerView setDate:[NSDate date] animated:YES];
            [_datePickerView addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
            [_datePickerView setDatePickerMode:UIDatePickerModeDate];
            [self addSubview:_datePickerView];
        }
   
    }
    return self;
}

- (void)reloadData:(NSArray *)arr
{
    [_dataArray removeAllObjects];
    [_dataArray addObjectsFromArray:arr];
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:0 inComponent:0 animated:NO];
}

- (void)setTitle:(NSString *)title
{
    UILabel *titleLbl = (UILabel *)[_toolBar viewWithTag:100];
    titleLbl.text = title;
}

#pragma mark -Button Action

-(void)cancelBtnDone
{
    if (_delegate && [_delegate respondsToSelector:@selector(dataPickerSelectViewDidCancel:inPutViewSuperView:)])
    {
        [_delegate dataPickerSelectViewDidCancel:self inPutViewSuperView:_superView];
    }
}

-(void)doneBtnDone
{    
    if (_delegate &&[_delegate respondsToSelector:@selector(dataPickerSelectViewDidDone:inPutViewSuperView:)])
    {
        [_delegate dataPickerSelectViewDidDone:self inPutViewSuperView:_superView];
    }
}

#pragma mark -UIDatePicker methord

-(void)datePickerValueChanged:(UIDatePicker*)datePicker
{
    NSDate *selected = [datePicker date];
    if (_delegate &&[_delegate respondsToSelector:@selector(dataPickerSelectView:selectIndex:withInfo:inPutViewSuperView:style:)])
    {
        [_delegate dataPickerSelectView:self selectIndex:0 withInfo:selected inPutViewSuperView:_superView style:dataPickerSelectViewType];
    }
}

#pragma mark -UIPickerViewDelegate methord

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_delegate &&[_delegate respondsToSelector:@selector(dataPickerSelectView:selectIndex:withInfo:inPutViewSuperView:style:)])
    {
        [_delegate dataPickerSelectView:self selectIndex:row withInfo:[_dataArray objectAtIndex:row]inPutViewSuperView:_superView style:dataPickerSelectViewType];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_dataArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_dataArray objectAtIndex:row];
}

@end






