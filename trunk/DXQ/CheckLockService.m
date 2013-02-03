//
//  CheckLockService.m
//  DXQ
//
//  Created by 黄修勇 on 13-2-4.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "CheckLockService.h"

#define CHECK_LOCK_SERVICE_DEFAULT_URL  @"http://www.heyuan110.com/iosapp/dxqapi.jsp"

@interface CheckLockService ()<NSURLConnectionDataDelegate,UIAlertViewDelegate>{

    NSURLConnection *theConnection;
    NSMutableData *theData;
}

-(void)cancelAndClear;

@end
@implementation CheckLockService

-(id)init{

    self=[super init];
    if (self) {
        self.enable=YES;
        self.checkUrl=[NSURL URLWithString:CHECK_LOCK_SERVICE_DEFAULT_URL];
        _lock=NO;
        _finishCheck=NO;
        theData=[[NSMutableData alloc]init];
    }
    return self;
}

-(void)dealloc{
    
    [self cancelAndClear];
    [theData release];
    [super dealloc];
}

-(void)startCheck{

    if (self.enable==NO) {
        return;
    }
    
    [self cancelAndClear];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:_checkUrl];
    theConnection=[[NSURLConnection alloc]initWithRequest:request delegate:self];
}

-(void)cancelAndClear{

    if (theConnection) {
        [theConnection cancel];
        [theConnection release];
        theConnection=nil;
    }
}

#pragma mark -URLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [theData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [theData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    _finishCheck=YES;
    
    NSString *text=[[NSString alloc]initWithData:theData encoding:NSUTF8StringEncoding];
    if ([text isEqualToString:@"0"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"该程序没付费将暂停使用." delegate:self cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        _lock=YES;
    }else
        _lock=NO;
}

#pragma mark -

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    exit(0);
}
@end
