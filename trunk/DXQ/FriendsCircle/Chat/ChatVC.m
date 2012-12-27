//
//  ChatVC.m
//  DXQ
//
//  Created by Yuan on 12-10-21.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ChatVC.h"
#import "ChatBottomToolBar.h"
#import "UIImageView+WebCache.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "HYEmojiView.h"
#import "SDWebImageManager.h"
#import "SDImageCache.h"
#import "DXQWebSocket.h"
#import "ChatMessageCenter.h"

@interface ChatVC ()<UIBubbleTableViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *bubbleData;
    
    ChatBottomToolBar *chatToolBar;
    
    HYEmojiView *hYEmojiView;
    
    NSDictionary *chatUserInfo;
    
    BOOL isShowEmojiKeyBoard;
    
    UIImage *meAvatar;
    UIImage *chatUserAvatar;
}

@property(nonatomic,retain)UIBubbleTableView *chatTableView;

@property(nonatomic,retain)UITextField *messageTextField;

@property(nonatomic,retain)ChatBottomToolBar *chatToolBar;

@property(nonatomic,retain) NSMutableArray *bubbleData;

@property(nonatomic,retain) HYEmojiView *hYEmojiView;

@property(nonatomic,retain) NSDictionary *chatUserInfo;
@end

@implementation ChatVC
@synthesize  chatTableView = _chatTableView;
@synthesize  messageTextField = _messageTextField;
@synthesize chatToolBar = _chatToolBar;
@synthesize bubbleData = _bubbleData;
@synthesize hYEmojiView = _hYEmojiView;
@synthesize chatUserInfo = _chatUserInfo;

-(void)dealloc
{
    [self removeNotifications];

    [_chatUserInfo release];_chatUserInfo = nil;
    
    [_hYEmojiView release];_hYEmojiView = nil;
    
    [_bubbleData release];_bubbleData = nil;
    
    [_chatToolBar release];_chatToolBar = nil;
    
    [_messageTextField release];_messageTextField = nil;
    
    [_chatTableView release];_chatTableView = nil;
    [[ChatMessageCenter shareMessageCenter]removeChatViewController:self];
    [super dealloc];
}

-(void)viewDidUnload
{
    self.hYEmojiView = nil;
    
    self.chatToolBar = nil;
    
    self.messageTextField = nil;
    
    self.chatTableView = nil;
 
    [super viewDidUnload];
}

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self)
    {
        [[ChatMessageCenter shareMessageCenter]addChatViewController:self chatName:[info objectForKey:@"AccountId"]];
        _chatUserInfo = [[NSDictionary alloc]initWithDictionary:info];
        
        //最近会话的人
        [[SettingManager sharedSettingManager]addLastestContact:info];
        
        _bubbleData = [[NSMutableArray alloc]init];
        
        DXQAccount *account =  [[DXQCoreDataManager sharedCoreDataManager]getCurrentLoggedInAccount];
        meAvatar = [[SDImageCache sharedImageCache]imageFromKey:account.dxq_PhotoUrl];
        if (account.dxq_PhotoUrl )
        {
            if (!meAvatar)
            {
                [[SDWebImageManager sharedManager]downloadWithURL:[NSURL URLWithString:account.dxq_PhotoUrl] delegate:nil options:0 userInfo:nil success:^(UIImage *image,BOOL cached)
                 {
                     meAvatar = image;
                     [_chatTableView reloadData];
                 } failure:nil];
            }
        }
        else
        {
            meAvatar = [UIImage imageNamed:@"tx_gray.png"];
        }
        
        NSString *chatUserAvatarUrl = [_chatUserInfo objectForKey:@"PhotoUrl"];
        chatUserAvatar = [[SDImageCache sharedImageCache]imageFromKey:chatUserAvatarUrl];
        if (chatUserAvatarUrl )
        {
            if (!chatUserAvatar)
            {
                [[SDWebImageManager sharedManager]downloadWithURL:[NSURL URLWithString:chatUserAvatarUrl] delegate:nil options:0 userInfo:nil success:^(UIImage *image,BOOL cached)
                 {
                     chatUserAvatar = image;
                     [_chatTableView reloadData];
                 } failure:nil];
            }
        }
        else
        {
            chatUserAvatar = [UIImage imageNamed:@"tx_gray.png"];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessage:) name:NOTIFICATIONCENTER_RECEIVED_MESSAGES object:nil];
    }
    return self;
}


-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
        
    _chatTableView = [[UIBubbleTableView alloc] initWithFrame:CGRectMake(0,0, 320, 370) style:UITableViewStyleGrouped];
    [_chatTableView setBubbleDataSource:self];
    _chatTableView.snapInterval = 15;
    _chatTableView.showAvatars = YES;
    _chatTableView.typingBubble = NSBubbleTypingTypeNobody;
    [_chatTableView setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:_chatTableView];
    
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard:)];
    [_chatTableView addGestureRecognizer:g];
    [g release];
    
    _chatToolBar = [[ChatBottomToolBar alloc]initWithFrame:CGRectMake(0,self.view.bounds.size.height-44.0,320.0,0) delegate:self];
    _chatToolBar.messageTextField.delegate = self;
    _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:_chatToolBar];
    
    _hYEmojiView = [[HYEmojiView alloc]initWithFrame:CGRectMake(0,0,rect.size.width,rect.size.height) superViewHeight:rect.size.height - self.navigationController.navigationBar.frame.size.height delegate:self];
    CGRect emojiFrame = _hYEmojiView.frame;
    emojiFrame.origin.y = rect.size.height - self.navigationController.navigationBar.frame.size.height;
    _hYEmojiView.frame = emojiFrame;
    [self.view addSubview:_hYEmojiView];
    
}

-(void)dismissKeyBoard:(UIGestureRecognizer *)g
{
    isShowEmojiKeyBoard = NO;
    [self showEmoji:NO];
    [_chatToolBar.messageTextField resignFirstResponder];
}

-(void)showEmoji:(BOOL)isShow
{
    CGFloat offset_y = 0.0f;
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.30];
    if (isShow)
    {
        offset_y = self.view.frame.size.height-_hYEmojiView.frame.size.height;
    }
    else
    {
        offset_y = self.view.frame.size.height;
    }
    _hYEmojiView.frame=CGRectMake(0, offset_y,
                                  _hYEmojiView.frame.size.width,
                                  _hYEmojiView.frame.size.height);
    _chatToolBar.frame = CGRectMake(0,offset_y- _chatToolBar.frame.size.height, _chatToolBar.frame.size.width,_chatToolBar.frame.size.height);
	[UIView commitAnimations];
    _chatTableView.frame = CGRectMake(0,0, _chatTableView.frame.size.width,_chatTableView.frame.size.height);
}

//show emoji keyboard
-(void)emojiKeyBoard:(id)sender
{
    isShowEmojiKeyBoard = YES;
    [_chatToolBar.messageTextField resignFirstResponder];
    [self showEmoji:YES];
}

- (void)viewDidLoad
{
    [self setNavgationTitle:[_chatUserInfo objectForKey:@"MemberName"] backItemTitle:AppLocalizedString(@"返回")];
    /*
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"嘿嘿，大黄...." date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    heyBubble.avatar = [UIImage imageNamed:@"demo_img.png"];
    
    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"demo_gift.png"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
    photoBubble.avatar = [UIImage imageNamed:@"demo_img.png"];
    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"凤姐表示对你很感兴趣哦，赶紧找她吧!" date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    replyBubble.avatar = [UIImage imageNamed:@"demo_img.png"];
    
    _bubbleData = [[NSMutableArray alloc] initWithObjects:heyBubble, photoBubble, replyBubble, nil];
    
    [_chatTableView reloadData];
     */
     
    [self registerForKeyboardNotifications];

    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    NSArray *chatMsg=[[ChatMessageCenter shareMessageCenter]getMsgWithChatName:[_chatUserInfo objectForKey:@"AccountId"]];
    for (int i=0; i<chatMsg.count; i++) {
        [self getChatMessage:[chatMsg objectAtIndex:i]];
    }
    
    NSLog(@"self view %@",self.view);
    NSLog(@"window %@",[[[UIApplication sharedApplication]keyWindow]subviews]);
}

-(void)sendMessage:(id)sender
{
    if ([_chatToolBar.messageTextField.text length] > 0)
    {
        NSString *txtString = [Tool trimmingWhiteSpaceCharacter:_chatToolBar.messageTextField.text];
        if ([txtString length]>140)
        {
            [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"亲，字数140超限制了!")];
            [[ProgressHUD sharedProgressHUD]showInView:[[[UIApplication sharedApplication] windows] lastObject]];
            [[ProgressHUD sharedProgressHUD]done:NO];
            return;
        }
        
        NSBubbleData *meReply = [NSBubbleData dataWithText:txtString date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
        meReply.avatar = meAvatar;
        [_bubbleData addObject:meReply];
        [_chatTableView reloadData];
        [self sendMessageContent:txtString];
        isShowEmojiKeyBoard = NO;
        [self showEmoji:NO];
        [_chatToolBar.messageTextField resignFirstResponder];
    }
}

-(void)sendMessageContent:(NSString *)content
{
    //链接成功了给服务器发送cpc接口的数据
    NSDictionary *pDict = [NSDictionary dictionaryWithObjectsAndKeys:[[SettingManager sharedSettingManager]loggedInAccount],@"AccountFrom",[_chatUserInfo objectForKey:@"AccountId"],@"AccountTo",content,@"Content", nil];
    [[ChatMessageCenter shareMessageCenter]sendMsg:pDict target:self];
    _chatToolBar.messageTextField.text = @"";
}

-(void)receivedMessage:(NSNotification *)info
{
    HYLog(@"info-->%@",info);
    return;
    NSMutableDictionary *receiveDict = [NSMutableDictionary dictionaryWithDictionary:[(NSNotification*)info userInfo]];

    if ([[receiveDict objectForKey:@"AccountFrom"] isEqualToString:[_chatUserInfo objectForKey:@"AccountId"]])
    {
        long int timeSp = [[receiveDict objectForKey:@"OpTime"] longLongValue];
        NSBubbleData *heyBubble = [NSBubbleData dataWithText:[receiveDict objectForKey:@"Content"] date:[NSDate dateWithTimeIntervalSince1970:timeSp] type:BubbleTypeSomeoneElse];
        heyBubble.avatar = chatUserAvatar;
        [_bubbleData addObject:heyBubble];
        [_chatTableView reloadData];
    }
}

-(void)getChatMessage:(NSDictionary *)receiveDict{
    
    long int timeSp = [[receiveDict objectForKey:@"OpTime"] longLongValue];
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:[receiveDict objectForKey:@"Content"] date:[NSDate dateWithTimeIntervalSince1970:timeSp] type:BubbleTypeSomeoneElse];
    heyBubble.avatar = chatUserAvatar;
    [_bubbleData addObject:heyBubble];
    [_chatTableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    isShowEmojiKeyBoard = NO;
    [textField resignFirstResponder];
    return YES;
}

-(void)showKeyBoard:(HYEmojiView *)emojiView
{
    isShowEmojiKeyBoard = NO;
    [_chatToolBar.messageTextField becomeFirstResponder];
}

- (void)didSelectEmojiImage:(UIImage *)image EmojiString:(NSString*)emoji
{
    HYLog(@"%@",emoji);
    NSString *msgText=nil;
    if (_chatToolBar.messageTextField.text) {
        msgText=_chatToolBar.messageTextField.text;
    }else
        msgText=@"";
    _chatToolBar.messageTextField.text = [NSString stringWithFormat:@"%@%@",msgText,emoji];
}

#pragma mark - UIBubbleTableViewDataSource implementation
- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [_bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [_bubbleData objectAtIndex:row];
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATIONCENTER_RECEIVED_MESSAGES object:nil];

	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:_chatToolBar name:@"HiddenKeybord" object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey
                      ];
    CGSize keyboardSize = [value CGRectValue].size;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.30];
    CGFloat offset_y = self.view.bounds.size.height-keyboardSize.height-44.0f;
    _chatToolBar.frame=CGRectMake(0, offset_y,
                               _chatToolBar.frame.size.width,
                               _chatToolBar.frame.size.height);
    _chatTableView.frame = CGRectMake(0,offset_y- _chatTableView.frame.size.height, _chatTableView.frame.size.width,_chatTableView.frame.size.height);
	[UIView commitAnimations];
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.30];
    CGFloat offset_y = 0.0f;

    if (isShowEmojiKeyBoard)
    {
        offset_y = self.view.frame.size.height-_chatToolBar.frame.size.height-_hYEmojiView.frame.size.height;
    }
    else
    {
        offset_y = self.view.bounds.size.height-44.0;
    }
    _chatToolBar.frame=CGRectMake(0,offset_y,
                                  _chatToolBar.frame.size.width,
                                  _chatToolBar.frame.size.height);
    _chatTableView.frame = CGRectMake(0,offset_y- _chatTableView.frame.size.height, _chatTableView.frame.size.width,_chatTableView.frame.size.height);
	[UIView commitAnimations];
    [self showEmoji:NO];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
