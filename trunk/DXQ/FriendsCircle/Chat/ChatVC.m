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
#import "UserDetailInfoVC.h"
#import "RelationMakeRequest.h"
#import "UserReportUserRequest.h"

#define CHAT_VC_HISTORY_NUMBER  10

@interface ChatVC ()<UIBubbleTableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,RelationMakeRequestDelegate,UserReportUserRequestDelegate>
{
    NSMutableArray *bubbleData;
    
    ChatBottomToolBar *chatToolBar;
    
    HYEmojiView *hYEmojiView;
    
    NSDictionary *chatUserInfo;
    
    BOOL isShowEmojiKeyBoard;
    
    UIImage *meAvatar;
    UIImage *chatUserAvatar;

    RelationMakeRequest *takeBlackRequest;
    UserReportUserRequest *reportRequest;
    
    UIImageView *bgImgView;
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
    [[ChatMessageCenter shareMessageCenter]removeChatMsgSendStateObserver:self];
    [[ChatMessageCenter shareMessageCenter]removeUserObserByTarget:self userName:[_chatUserInfo objectForKey:@"AccountId"]];
    [_chatUserInfo release];_chatUserInfo = nil;
    
    [_hYEmojiView release];_hYEmojiView = nil;
    
    [_bubbleData release];_bubbleData = nil;
    
    [_chatToolBar release];_chatToolBar = nil;
    [bgImgView release];bgImgView=nil;
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
    [bgImgView release];
    bgImgView=nil;
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
    
        if (account.dxq_PhotoUrl)
        {
            if (!meAvatar)
            {
                [[SDWebImageManager sharedManager]downloadWithURL:[NSURL URLWithString:[account.dxq_PhotoUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]] delegate:self options:0 userInfo:nil success:^(UIImage *image,BOOL cached)
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
        if (chatUserAvatarUrl.length>0)
        {
            if (!chatUserAvatar)
            {
                [[SDWebImageManager sharedManager]downloadWithURL:[NSURL URLWithString:chatUserAvatarUrl] delegate:self options:0 userInfo:nil success:^(UIImage *image,BOOL cached)
                 {
                     chatUserAvatar = image;
                     [_chatTableView reloadData];
                     bgImgView.image=chatUserAvatar;
                 } failure:^(NSError *error){
                 
                     NSLog(@"error %@",error);
                 }];
            }
        }
        else
        {
            chatUserAvatar = [UIImage imageNamed:@"tx_gray.png"];
            [self getChatUserHeaderImage];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessage:) name:NOTIFICATIONCENTER_RECEIVED_MESSAGES object:nil];
    }
    return self;
}


-(void)getChatUserHeaderImage{

    if (!chatUserAvatar) {
        ChatMessageCenter *msgCenter=[ChatMessageCenter shareMessageCenter];
        NSString *userID=[_chatUserInfo objectForKey:@"AccountId"];
        if ([msgCenter isRequestDetailByID:userID]) {
            [msgCenter addUserInfoDetailObserve:self action:@selector(getUserData:) userID:userID];
            [msgCenter requestUserDefailtInfoByID:userID];
        }
    }
}

-(void)getUserData:(NSDictionary *)dic{

    NSString *imgURL=[dic objectForKey:@"PhotoUrl"];
    [[SDWebImageManager sharedManager]downloadWithURL:[NSURL URLWithString:[imgURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]] delegate:self options:0 userInfo:nil success:^(UIImage *image,BOOL cached)
     {
         chatUserAvatar = image;
         [_chatTableView reloadData];
         bgImgView.image=image;
     } failure:nil];
}

-(void)loadView
{
    CGRect rect = [UIScreen mainScreen].applicationFrame;
    CustomUIView *view_ = [[CustomUIView alloc] initWithFrame:rect];
    self.view = view_;
    [view_ release];
    
    NSArray *titleArray=[NSArray arrayWithObjects:@"删除记录",/*@"送 礼",*/@"查看资料",@"更 多", nil];
    NSArray *action=[NSArray arrayWithObjects:@"editeChat:",/*@"sendGit",*/@"showChatUserDetailPage",@"moreAction", nil];
    
    float buttonWeidth=70;
    float margin=10;
    float lefhtMargin=(self.view.frame.size.width-titleArray.count*buttonWeidth-(titleArray.count-1)*margin)/2;
    for (int i=0; i<titleArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *imge=[UIImage imageNamed:@"btn_1"];
        [btn setBackgroundImage:imge forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:NSSelectorFromString([action objectAtIndex:i]) forControlEvents:UIControlEventTouchUpInside];
        btn.frame=CGRectMake(lefhtMargin+(buttonWeidth+margin)*i, 5.f, buttonWeidth, 30.f);
        [self.view addSubview:btn];
    }
    
    _chatTableView = [[UIBubbleTableView alloc] initWithFrame:CGRectMake(0,40, 320, 370-40) style:UITableViewStyleGrouped];
    [_chatTableView setBubbleDataSource:self];
    _chatTableView.snapInterval = 15;
    _chatTableView.showAvatars = YES;
    _chatTableView.typingBubble = NSBubbleTypingTypeNobody;
    [_chatTableView setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:_chatTableView];
    
    bgImgView=[[UIImageView alloc]initWithImage:chatUserAvatar];
    bgImgView.frame=CGRectMake(0.f, 40.f, self.view.frame.size.width, self.view.frame.size.height-40.f-44.f);
    bgImgView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:bgImgView atIndex:0];
    
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
    _chatTableView.frame = CGRectMake(0,40, _chatTableView.frame.size.width,_chatTableView.frame.size.height);
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

        [self sendMessageContent:txtString];
    }
}

-(void)sendMessageContent:(NSString *)content
{
    //链接成功了给服务器发送cpc接口的数据
    NSDictionary *pDict = [NSDictionary dictionaryWithObjectsAndKeys:[[SettingManager sharedSettingManager]loggedInAccount],@"AccountFrom",[_chatUserInfo objectForKey:@"AccountId"],@"AccountTo",[Tool encodeBase64:content],@"Content", nil];
    [[ChatMessageCenter shareMessageCenter]sendMsg:pDict target:self];
    _chatToolBar.messageTextField.text = @"";
}

-(void)chatMessage:(NSDictionary *)msgDic sendFailedWithError:(NSError *)error{
    
    [Tool showAlertWithTitle:@"消息发送失败" msg:[msgDic objectForKey:@"Content"]];
}

-(void)chatMessageDidSend:(NSDictionary *)msgDic{

    NSBubbleData *meReply = [NSBubbleData dataWithText:[Tool decodeBase64:[msgDic objectForKey:@"Content"]] date:[NSDate dateWithTimeIntervalSince1970:[[msgDic objectForKey:@"OpTime"] integerValue]] type:BubbleTypeMine];
    meReply.avatar = meAvatar;
    meReply.idNumber=[[msgDic objectForKey:@"Id"] integerValue];
    [_bubbleData addObject:meReply];
    [_chatTableView reloadData];
    [_chatTableView scrollRectToVisible:CGRectMake(0.f, _chatTableView.contentSize.height-_chatTableView.frame.size.height, _chatTableView.frame.size.width, _chatTableView.frame.size.height) animated:YES];
}

-(void)receivedMessage:(NSNotification *)info
{
    HYLog(@"info-->%@",info);
    return;
    NSMutableDictionary *receiveDict = [NSMutableDictionary dictionaryWithDictionary:[(NSNotification*)info userInfo]];

    if ([[receiveDict objectForKey:@"AccountFrom"] isEqualToString:[_chatUserInfo objectForKey:@"AccountId"]])
    {
        long int timeSp = [[receiveDict objectForKey:@"OpTime"] longLongValue];
        NSBubbleData *heyBubble = [NSBubbleData dataWithText:[Tool decodeBase64:[receiveDict objectForKey:@"Content"]] date:[NSDate dateWithTimeIntervalSince1970:timeSp] type:BubbleTypeSomeoneElse];
        heyBubble.idNumber=[[receiveDict objectForKey:@"Id"] integerValue];
        heyBubble.avatar = chatUserAvatar;
        [_bubbleData addObject:heyBubble];
        [_chatTableView reloadData];
    }
}

-(void)getChatMessage:(NSDictionary *)receiveDict{
    
    long int timeSp = [[receiveDict objectForKey:@"OpTime"] longLongValue];
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:[Tool decodeBase64:[receiveDict objectForKey:@"Content"]] date:[NSDate dateWithTimeIntervalSince1970:timeSp] type:BubbleTypeSomeoneElse];
    heyBubble.idNumber=[[receiveDict objectForKey:@"Id"] integerValue];
    heyBubble.avatar = chatUserAvatar;
    [self getChatUserHeaderImage];
    [_bubbleData addObject:heyBubble];
    [_chatTableView reloadData];
    [_chatTableView scrollRectToVisible:CGRectMake(0.f, _chatTableView.contentSize.height-_chatTableView.frame.size.height, _chatTableView.frame.size.width, _chatTableView.frame.size.height) animated:YES];
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

-(void)bubbleTableView:(UIBubbleTableView *)tableView headerDidTapForData:(NSBubbleData *)data{

    NSDictionary *dic;
    if (data.type==BubbleTypeMine) {
        DXQAccount *account = [[DXQCoreDataManager sharedCoreDataManager]getCurrentLoggedInAccount];
        dic=[NSDictionary dictionaryWithObjectsAndKeys: account.dxq_MemberName,@"MemberName",account.dxq_AccountId,@"AccountId",account.dxq_Introduction,@"Introduction",account.dxq_PhotoUrl,@"PhotoUrl", nil];
    }else
        dic=_chatUserInfo;
    UserDetailInfoVC *user=[[UserDetailInfoVC alloc]initwithUserInfo:dic];
    [self.navigationController pushViewController:user animated:YES];
    [user release];
}

-(void)bubbleTableView:(UIBubbleTableView *)tableView deleteForData:(NSBubbleData *)data
{
    if ([[ChatMessageCenter shareMessageCenter]deleteHistoryChatMsgByID:data.idNumber]) {
        [_bubbleData removeObject:data];
        [tableView reloadData];
    }
}

-(void)showChatUserDetailPage
{
    UserDetailInfoVC *user=[[UserDetailInfoVC alloc]initwithUserInfo:_chatUserInfo];
    [self.navigationController pushViewController:user animated:YES];
    [user release];
}

-(void)pullToRereshBubbleTable:(UIBubbleTableView *)tableView{

    NSInteger page=_bubbleData.count/CHAT_VC_HISTORY_NUMBER;
    NSString *tempUserID=[_chatUserInfo objectForKey:@"AccountId"];
    NSArray *tempArray=[[ChatMessageCenter shareMessageCenter]getHistoryChatMsgFromUser:tempUserID number:CHAT_VC_HISTORY_NUMBER*(page+1) page:0];
    NSMutableArray *tempData=[NSMutableArray array];
    for (int i=0; i<tempArray.count; i++) {
        NSDictionary *receiveDict=[tempArray objectAtIndex:i];
        NSBubbleType tempType;
        if ([[receiveDict objectForKey:@"AccountFrom"] isEqualToString:tempUserID]) {
            tempType=BubbleTypeSomeoneElse;
        }else
            tempType=BubbleTypeMine;
        long int timeSp = [[receiveDict objectForKey:@"OpTime"] longLongValue];
        NSBubbleData *heyBubble = [NSBubbleData dataWithText:[Tool decodeBase64:[receiveDict objectForKey:@"Content"]] date:[NSDate dateWithTimeIntervalSince1970:timeSp] type:tempType];
        heyBubble.idNumber=[[receiveDict objectForKey:@"Id"] integerValue];
        heyBubble.avatar = chatUserAvatar;
        [tempData addObject:heyBubble];
    }
    [_bubbleData removeAllObjects];
    [_bubbleData addObjectsFromArray:tempData];
    [tableView reloadData];
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
    _chatTableView.frame = CGRectMake(0,40, _chatTableView.frame.size.width,offset_y-40.f);
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
    _chatTableView.frame = CGRectMake(0,40.f, _chatTableView.frame.size.width,self.view.frame.size.height-_chatToolBar.frame.size.height-40.f);
	[UIView commitAnimations];
    [self showEmoji:NO];
}



- (void)didReceiveMemoryWarning
{
//    // [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)moreAction
{
    UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"更多" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"加入黑名单",@"举报", nil];
    [sheet showInView:self.view];
    [sheet release];
}

-(void)sendGit
{
}

-(void)editeChat:(UIButton *)btn
{
    BOOL isEdite=[self.chatTableView isEditing];
    [self.chatTableView setEditing:!isEdite animated:YES];
    if (isEdite) {
        [btn setTitle:@"删除记录" forState:UIControlStateNormal];
    }else
        [btn setTitle:@"完 成" forState:UIControlStateNormal];
}

#pragma mark -

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self addUserToBlackList];
            break;
        case 1:
        {
            [self reportUser];
        }
            break;
        default:
            break;
    }
}

-(void)addUserToBlackList
{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[SettingManager sharedSettingManager].loggedInAccount,@"AccountFrom",[_chatUserInfo objectForKey:@"AccountId"],@"AccountTo",@"-1",@"Relation", nil];
    takeBlackRequest=[[RelationMakeRequest alloc]initRequestWithDic:dic];
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
    [[ProgressHUD sharedProgressHUD]setText:@"拉黑名单中..."];
    takeBlackRequest.delegate=self;
    [takeBlackRequest startAsynchronous];
}


-(void)reportUser
{
  NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[SettingManager sharedSettingManager].loggedInAccount,@"AccountFrom",[_chatUserInfo objectForKey:@"AccountId"],@"AccountTo", nil];
    reportRequest=[[UserReportUserRequest alloc]initRequestWithDic:dic];
    [[ProgressHUD sharedProgressHUD]setText:@"正在举报用户"];
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
    reportRequest.delegate=self;
    [reportRequest startAsynchronous];
}
#pragma mark -relation delegate

-(void)relationMakeRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    [[ProgressHUD sharedProgressHUD]setText:errorMsg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [takeBlackRequest release];
    takeBlackRequest=nil;
}

-(void)relationMakeRequestDidFinishedWithParamters:(NSDictionary *)dic
{
    [[ProgressHUD sharedProgressHUD]setText:@"添加成功!"];
    [[ProgressHUD sharedProgressHUD]done:YES];
    [takeBlackRequest release];
    takeBlackRequest=nil;
    NSMutableArray *array=[[SettingManager sharedSettingManager]getLastestContact];
    [array removeObject:_chatUserInfo];
    [[SettingManager sharedSettingManager]saveLastestContact:array];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)userReportUserRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    [[ProgressHUD sharedProgressHUD]setText:errorMsg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    [reportRequest release];
    reportRequest=nil;
}

-(void)userReportUserRequestDidFinishedWithParamters:(NSDictionary *)dic
{
    [[ProgressHUD sharedProgressHUD]setText:@"举报成功!"];
    [[ProgressHUD sharedProgressHUD]done:YES];
    [reportRequest release];
    reportRequest=nil;
    [self.navigationController popViewControllerAnimated:YES];
}
@end

