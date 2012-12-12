//
//  UploadImageToAlbum.m
//  DXQ
//
//  Created by Yuan on 12-11-28.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "UploadImageToAlbum.h"

@implementation UploadImageToAlbum
@synthesize delegate;
@synthesize imageInfo;

-(id)initWithDelegate:(id)_delegate info:(NSDictionary *)info
{
    if (self = [super init])
    {
        self.imageInfo = [NSDictionary dictionaryWithDictionary:info];
        self.delegate = _delegate;
    }
    return self;
}

-(void)startUploadImage:(UIImage *)uploadimage isHD:(BOOL)isHD
{
    NSData *imageData = UIImageJPEGRepresentation(uploadimage,isHD?1.0:0.5);
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
        [self userCreatePhotoRequest:[o objectForKey:@"Id"]];
    }
    else
    {
        [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"上传失败!")];
        [[ProgressHUD sharedProgressHUD]done:NO];
        if (delegate && [delegate respondsToSelector:@selector(uploadImageToAlbumFinished:)])
        {
            [delegate uploadImageToAlbumFinished:self];
        }
    }
}

-(void)failUpload:(ASIHTTPRequest*)request
{
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"上传失败!")];
    [[ProgressHUD sharedProgressHUD]done:NO];
    if (delegate && [delegate respondsToSelector:@selector(uploadImageToAlbumFinished:)])
    {
        [delegate uploadImageToAlbumFinished:self];
    }
}

-(void)userCreatePhotoRequest:(NSString *)fileid
{
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil, nil];
    [parametersDic setObject:[[SettingManager sharedSettingManager]loggedInAccount] forKey:@"AccountId"];
    [parametersDic setObject:fileid forKey:@"FileId"];
    if ([self.imageInfo objectForKey:@"FileDesc"])[parametersDic setObject:[self.imageInfo objectForKey:@"FileDesc"] forKey:@"FileDesc"];
    
    if ([self.imageInfo objectForKey:@"AddressInfo"])[parametersDic setObject:[self.imageInfo objectForKey:@"AddressInfo"] forKey:@"AddressInfo"];
    
    [parametersDic setObject:@"1" forKey:@"DeviceInfo"];
    
    if ([self.imageInfo objectForKey:@"Label"])[parametersDic setObject:[self.imageInfo objectForKey:@"Label"] forKey:@"Label"];
    
    if ([self.imageInfo objectForKey:@"JingDu"])[parametersDic setObject:[self.imageInfo objectForKey:@"JingDu"] forKey:@"JingDu"];
    
    if ([self.imageInfo objectForKey:@"WeiDu"])[parametersDic setObject:[self.imageInfo objectForKey:@"WeiDu"] forKey:@"WeiDu"];
    
    if ([self.imageInfo objectForKey:@"ProductCode"])[parametersDic setObject:[self.imageInfo objectForKey:@"ProductCode"] forKey:@"ProductCode"];
    
    [[ProgressHUD sharedProgressHUD]setText:AppLocalizedString(@"正在处理...")];
    userCreatePhotoRequest = [[UserCreatePhotoRequest alloc] initRequestWithDic:parametersDic];
    userCreatePhotoRequest.delegate = self;
    [userCreatePhotoRequest startAsynchronous];
}

-(void)userCreatePhotoRequestDidFinishedWithParamters:(NSDictionary *)dic
{
    HYLog(@"%@",dic);
    userCreatePhotoRequest.delegate = nil,
    [userCreatePhotoRequest release];
    userCreatePhotoRequest=nil;
    [[ProgressHUD sharedProgressHUD] setText:AppLocalizedString(@"上传成功!")];
    [[ProgressHUD sharedProgressHUD]done];
    [[AppDelegate sharedAppDelegate]dismissLoginViewControl];
    if (delegate && [delegate respondsToSelector:@selector(uploadImageToAlbumFinished:)])
    {
        [delegate uploadImageToAlbumFinished:self];
    }
}

-(void)userCreatePhotoRequestDidFinishedWithErrorMessage:(NSString *)errorMsg
{
    userCreatePhotoRequest.delegate = nil,
    [userCreatePhotoRequest release];
    userCreatePhotoRequest=nil;
    [[ProgressHUD sharedProgressHUD] setText:errorMsg];
    [[ProgressHUD sharedProgressHUD]done:NO];
    if (delegate && [delegate respondsToSelector:@selector(uploadImageToAlbumFinished:)])
    {
        [delegate uploadImageToAlbumFinished:self];
    }
}


@end
