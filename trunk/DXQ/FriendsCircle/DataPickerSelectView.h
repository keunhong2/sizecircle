//
//  DataPickerSelectView.h
//  MeiXiu
//
//  Created by Yuan on 12-11-11.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    DataPickerSelectViewTypeCommen,
    DataPickerSelectViewTypeDate
}DataPickerSelectViewType;

@class DataPickerSelectView;

@protocol DataPickerSelectViewDelegate <NSObject>

@optional
-(void)dataPickerSelectViewDidCancel:(DataPickerSelectView *)selectView inPutViewSuperView:(UIView *)view;

-(void)dataPickerSelectViewDidDone:(DataPickerSelectView *)selectView inPutViewSuperView:(UIView *)view;

-(void)dataPickerSelectView:(DataPickerSelectView *)selectView  selectIndex:(NSInteger)row withInfo:(NSObject *)info inPutViewSuperView:(UIView *)view style:(DataPickerSelectViewType)style;

@end

@interface DataPickerSelectView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSIndexPath *indexPath;
}
@property(nonatomic,retain)NSIndexPath *indexPath;

@property (nonatomic,assign)id<DataPickerSelectViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title inPutViewSuperView:(UIView *)superView style:(DataPickerSelectViewType)style;

- (void)reloadData:(NSArray *)arr;

- (void)setTitle:(NSString *)title;


@end