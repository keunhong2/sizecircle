//
//  ShopCommentViewController.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-9.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ShopCommentViewController.h"
#import "CommentRequest.h"

@interface ShopCommentViewController ()<BusessRequestDelegate>{
    
    CommentRequest *commentRequest;
}

@end

@implementation ShopCommentViewController

-(void)dealloc{
    
    [commentRequest cancel];
    [commentRequest release];
    commentRequest=nil;
    [_shopDic release];
    [_kindType release];
    _commentDelegate=nil;
    [super dealloc];
}

-(id)initWithShopDic:(NSDictionary *)dic{
    
    self=[super initWithNibName:@"CommentInputViewController" bundle:nil];
    if (self) {
        self.shopDic=dic;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.kindType=@"MemberFile";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    // [super didReceiveMemoryWarning];
}

-(void)commentInputViewController:(CommentInputViewController *)inputViewController cancelBtnDone:(UIButton *)btn{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)commentInputViewController:(CommentInputViewController *)inputViewController doneBtnDone:(UIButton *)btn{
    
    if (self.textView.text.length==0) {
        [Tool showAlertWithTitle:AppLocalizedString(@"提示") msg:AppLocalizedString(@"评论得内容不能为空")];
        return;
    }
    [self.textView resignFirstResponder];
    [self comment];
}

-(void)comment{
    
    if (commentRequest) {
        [commentRequest cancel];
        [commentRequest release];
        commentRequest=nil;
    }
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication]keyWindow]];
    [[ProgressHUD sharedProgressHUD]setText:nil];
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:
                       _kindType,@"ObjectKind",
                       [_shopDic objectForKey:@"Id"],@"ObjectNo",
                       self.textView.text,@"Content",
                       [[SettingManager sharedSettingManager]loggedInAccount],@"AccountId", nil];
    commentRequest=[[CommentRequest alloc]initWithRequestWithDic:dic];
    commentRequest.delegate=self;
    [commentRequest startAsynchronous];
}

#pragma mark-
-(void)busessRequest:(DXQBusessBaseRequest *)request didFailedWithErrorMsg:(NSString *)msg{
    
    [[ProgressHUD sharedProgressHUD]setText:msg];
    [[ProgressHUD sharedProgressHUD]done:NO];
}

-(void)busessRequest:(DXQBusessBaseRequest *)request didFinishWithData:(id)data{
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"评论成功")];
    [[ProgressHUD sharedProgressHUD]done:YES];
    [self dismissModalViewControllerAnimated:YES];
    if (_commentDelegate&&[_commentDelegate respondsToSelector:@selector(finishCommentViewController:)]) {
        [_commentDelegate finishCommentViewController:self];
    }
}
@end
