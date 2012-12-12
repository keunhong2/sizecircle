//
//  ScreenSelectCell.m
//  DXQ
//
//  Created by 黄修勇 on 12-10-22.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ScreenSelectCell.h"

@implementation ScreenSelectCell


-(void)dealloc{

    [_textField release];
    [bgImgView release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSString *path=[[NSBundle mainBundle]pathForResource:@"txt_single" ofType:@"png"];
        UIImage *img=[UIImage imageWithContentsOfFile:path];
        
        bgImgView=[[UIImageView alloc]initWithImage:img];
        [bgImgView sizeToFit];
        bgImgView.frame=CGRectMake(self.contentView.frame.size.width/2-bgImgView.frame.size.width/2, 0.f, bgImgView.frame.size.width, bgImgView.frame.size.height);
        [self.contentView addSubview:bgImgView];
        
        _textField=[[UITextField alloc]initWithFrame:CGRectMake(60.f+10.f, 45.f/2-31.f/2+6.f, self.contentView.frame.size.width-90.f, 31.f)];
        _textField.borderStyle=UITextBorderStyleNone;
        _textField.font=[UIFont boldSystemFontOfSize:19.f];
        _textField.returnKeyType=UIReturnKeyDone;
        [self.contentView addSubview:_textField];
        
        self.indentationLevel=1;
        self.backgroundColor=[UIColor clearColor];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


-(void)setShowSelectPickerImageView:(BOOL)showSelectPickerImageView{

    if (self.showSelectPickerImageView==showSelectPickerImageView) {
        return;
    }
    _showSelectPickerImageView=showSelectPickerImageView;
    
    NSString *path=nil;
    if (showSelectPickerImageView) {
        path=[[NSBundle mainBundle]pathForResource:@"radio_bg" ofType:@"png"];
    }else
        path=[[NSBundle mainBundle]pathForResource:@"txt_single" ofType:@"png"];
    
    UIImage *img=[UIImage imageWithContentsOfFile:path];
    bgImgView.image=img;
}




@end
