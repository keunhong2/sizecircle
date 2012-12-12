//
//  ChatBottomToolBar.m
//  DXQ
//
//  Created by Yuan on 12-10-22.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ChatBottomToolBar.h"

@implementation ChatBottomToolBar
@synthesize  messageTextField = _messageTextField;

-(void)dealloc
{
    [_messageTextField release];_messageTextField = nil;
        
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame delegate:(UIViewController *)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImage *toolbarBg = [UIImage imageNamed:@"chat_toolbar_bg.png"];
        [self setBackgroundColor:[UIColor colorWithPatternImage:toolbarBg]];
        frame.size.height = toolbarBg.size.height;
        self.frame = frame;
        
        
        UIButton *emojButton = [UIButton buttonWithType:UIButtonTypeCustom];
        emojButton.frame = CGRectMake(6.0,7.0,30,30);
        [emojButton setBackgroundImage:[UIImage imageNamed:@"e057"] forState:UIControlStateNormal];
        [emojButton setImage:[UIImage imageNamed:@"e057"] forState:UIControlStateNormal];
        [emojButton addTarget:delegate action:@selector(emojiKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:emojButton];
        
        _messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(41.0,7.0, 230.0, 30.0)];
        [_messageTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [_messageTextField setPlaceholder:AppLocalizedString(@"消息内容,最多140字符")];
        [_messageTextField setFont:NormalDefaultFont];
        _messageTextField.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:_messageTextField];
        
        UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *sendImage = [UIImage imageNamed:@"chat_send_btn.png"];
        [sendButton addTarget:delegate action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        sendButton.frame = CGRectMake(274,6.0, sendImage.size.width, sendImage.size.height);
        [sendButton setImage:sendImage forState:UIControlStateNormal];
        [self addSubview:sendButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
