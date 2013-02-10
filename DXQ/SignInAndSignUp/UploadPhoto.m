//
//  UploadPhoto.m
//  DXQ
//
//  Created by Yuan on 12-11-26.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UploadPhoto.h"

@implementation UploadPhoto
@synthesize delegate;

-(id)initWithDelegate:(id)_delegate;
{
    if (self = [super init])
    {
        self.delegate = _delegate;
    }
    return self;
}

-(void)startUploadImage:(UIImage *)uploadimage
{
    NSData *imageData = UIImageJPEGRepresentation(uploadimage,0.5);
	NSString *url = [NSString stringWithFormat:@"%@?a=UploadFile",WebServiceURL];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self ;
    [request  setData:imageData withFileName:@"file.jpg" andContentType:@"image/jpg" forKey:@"image"];
    [request setTimeOutSeconds:20];
    [request setDidFinishSelector:@selector(finishUpload:)];
    [request setDidFailSelector:@selector(failUpload:)];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在上传...")];
    [[ProgressHUD sharedProgressHUD]showInView:[[UIApplication sharedApplication].windows lastObject]];
    [request startAsynchronous]; //start upload
}

-(void)finishUpload:(ASIHTTPRequest*)request
{
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"上传完成...")];
    NSString *responseString = [[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    responseString = [Tool TrimJsonChar:responseString];
    NSDictionary *responseDic = [responseString JSONValue];
    HYLog(@"%@",responseDic);
    NSDictionary *o = [responseDic objectForKey:@"o"];
    [responseString release];
    if (o && [o isKindOfClass:[NSDictionary class]])
    {
        [self userChangeFaceRequest:[o objectForKey:@"FilePath"]];
    }
    else
    {
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"上传失败!")];
        [[ProgressHUD sharedProgressHUD]done:NO];
        if (delegate && [delegate respondsToSelector:@selector(uploadPhotoFinished:)])
        {
            [delegate uploadPhotoFinished:self];
        }
    }
}

-(void)failUpload:(ASIHTTPRequest*)request
{
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"上传失败!")];
    [[ProgressHUD sharedProgressHUD]done:NO];
    if (delegate && [delegate respondsToSelector:@selector(uploadPhotoFinished:)])
    {
        [delegate uploadPhotoFinished:self];
    }
}

-(void)userChangeFaceRequest:(NSString *)url
{
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
    [parametersDic setObject:[[SettingManager sharedSettingManager]loggedInAccount] forKey:@"AccountId"];
    [parametersDic setObject:url forKey:@"FileUrl"];
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理...")];
    userChangeFaceRequest = [[UserChangeFaceRequest alloc] initRequestWithDic:parametersDic];
    userChangeFaceRequest.delegate = self;
    [userChangeFaceRequest startAsynchronous];
}

-(void)userChangeFaceRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    userChangeFaceRequest.delegate = nil,
    [userChangeFaceRequest release];
    userChangeFaceRequest=nil;
    [[ProgressHUD sharedProgressHUD] setText:errorMsg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    if (delegate && [delegate respondsToSelector:@selector(uploadPhotoFinished:)])
    {
        [delegate uploadPhotoFinished:self];
    }
}

-(void)userChangeFaceRequestDidFinishedWithParamters:(NSDictionary *)dic
{
    userChangeFaceRequest.delegate = nil,
    [userChangeFaceRequest release];
    userChangeFaceRequest=nil;
    [[ProgressHUD sharedProgressHUD]done];
    
    if (dic&&[dic isKindOfClass:[NSDictionary class]])
    {
        DXQAccount *account = [[DXQCoreDataManager sharedCoreDataManager]getAccountByAccountID:[[SettingManager sharedSettingManager]loggedInAccount]];
        if (account)
        {
            account.dxq_PhotoUrl = [dic objectForKey:@"FileUrl"];
            [[DXQCoreDataManager sharedCoreDataManager]saveChangesToCoreData];
        }
    }
    
    [[AppDelegate sharedAppDelegate]dismissLoginViewControl];
    
    if (delegate && [delegate respondsToSelector:@selector(uploadPhotoFinished:)])
    {
        [delegate uploadPhotoFinished:self];
    }
}

@end

