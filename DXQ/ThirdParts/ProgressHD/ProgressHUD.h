
#import <UIKit/UIKit.h>


@interface ProgressHUD : UIView {
  UIActivityIndicatorView* rdActivityView;
  UILabel* rdMessage;
  UIImageView* rdCompleteImage;
}

@property (nonatomic, copy)   NSString       *text;
@property (nonatomic, assign) CGFloat         fontSize;
@property (nonatomic, assign) NSTimeInterval  doneVisibleDuration;
@property (nonatomic, assign) BOOL            removeFromSuperviewWhenHidden;

-(void)showInView:(UIView *)view;
-(void)done;
-(void)done:(BOOL)succeeded;
-(void)slash;
-(void)slash:(BOOL)succeeded;
-(void)hide;

+(ProgressHUD*)sharedProgressHUD;

@end
