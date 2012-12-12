//
//  EmailManage.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-9.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "EmailManage.h"

@interface EmailManage ()

@property (nonatomic,assign)UIViewController *handleViewController;
@property (nonatomic,retain)NSArray *toRecipients;
@property (nonatomic,retain)NSString *sendText;

@end
@implementation EmailManage

static EmailManage *emailManage=nil;

+(void)showEmailViewControllerWithHandleViewController:(UIViewController *)controller sendToUser:(NSString *)user{

    if (!emailManage) {
        emailManage=[[EmailManage alloc]init];
    }else
    {
        emailManage.toRecipients=nil;
        emailManage.handleViewController=nil;
    }
    emailManage.handleViewController=controller;
    emailManage.toRecipients=[NSArray arrayWithObject:user];
    if([emailManage checkIsCanSendEmail])
        [emailManage showMailViewController];
    else
        [emailManage goSettingEmail];
}

-(void)dealloc{

    _handleViewController=nil;
    [_toRecipients release];
    [_sendText release];
    [super dealloc];
}

-(BOOL)checkIsCanSendEmail{

    Class mailClass=NSClassFromString(@"MFMailComposeViewController");
    if (mailClass) {
        return [MFMailComposeViewController canSendMail];
    }else
        return NO;
}

-(void)showMailViewController
{
    MFMailComposeViewController *mail=[[MFMailComposeViewController alloc]init];
    mail.mailComposeDelegate=self;
    [mail setValue:[[[NSClassFromString(@"CustomNavigationBar") alloc]init]autorelease] forKey:@"navigationBar"];
    if (_sendText) {
        [mail setMessageBody:_sendText isHTML:NO];
    }
    [mail setToRecipients:_toRecipients];
    [_handleViewController presentModalViewController:mail animated:YES];
    [mail release];
}

-(void)goSettingEmail{

    NSString *recipients = @"mailto:";
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, @""];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [_handleViewController dismissModalViewControllerAnimated:YES];
    switch (result) {
        case MFMailComposeResultSent:
            [[ProgressHUD sharedProgressHUD]showInView:[[[UIApplication sharedApplication]windows]objectAtIndex:0]];
            [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"已发送")];
            [[ProgressHUD sharedProgressHUD]done:YES];
            break;
        case MFMailComposeResultFailed:
            [[ProgressHUD sharedProgressHUD]showInView:[[[UIApplication sharedApplication]windows]objectAtIndex:0]];
            [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"发送失败")];
            [[ProgressHUD sharedProgressHUD]done:NO];
            break;
        default:
            break;
    }
}

@end
