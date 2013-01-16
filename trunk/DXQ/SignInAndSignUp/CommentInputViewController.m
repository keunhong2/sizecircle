//
//  CommentInputViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-9.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "CommentInputViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CommentInputViewController ()

@end

@implementation CommentInputViewController

-(id)init{

    return [self initWithNibName:@"CommentInputViewController" bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"CommentInputViewController" bundle:nibBundleOrNil];
    if (self) {
        self.title=AppLocalizedString(@"评论");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.textView.layer.borderWidth=1.f;
    self.textView.layer.borderColor=[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.3f].CGColor;
    self.textView.layer.cornerRadius=4.f;
    
    UIImage *btnImg=[UIImage imageNamed:@"btn_round"];
    UIFont *font=[UIFont boldSystemFontOfSize:14.f];
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
    [cancelBtn sizeToFit];
    [cancelBtn.titleLabel setFont:font];
    [cancelBtn setTitle:AppLocalizedString(@"返回") forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnDone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem=cancelItem;
    [cancelItem release];
    
    UIButton *doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
    [doneBtn sizeToFit];
    [doneBtn.titleLabel setFont:font];
    [doneBtn setTitle:AppLocalizedString(@"确定") forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnDone:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItem=[[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem=doneItem;
    [doneItem release];
}

- (void)didReceiveMemoryWarning
{
//    // [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_textView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTextView:nil];
    [super viewDidUnload];
}

#pragma mark -

-(void)cancelBtnDone:(UIButton *)btn{
    
    if (_delegate&&[_delegate respondsToSelector:@selector(commentInputViewController:cancelBtnDone:)]) {
        [_delegate commentInputViewController:self cancelBtnDone:btn];
    }
}

-(void)doneBtnDone:(UIButton *)btn{
    if (_delegate&&[_delegate respondsToSelector:@selector(commentInputViewController:doneBtnDone:)]) {
        [_delegate commentInputViewController:self doneBtnDone:btn];
    }
}
@end
