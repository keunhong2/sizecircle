//
//  Device.h
//  DXQ
//
//  Created by Yuan on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject
{
	UIDevice *myDevice;  // 获取设备
	
	NSString *deviceID;
    // 设备号,e.g:9648E1D4-0FA1-5EBA-9DC1-A97CF9AA1CB3
    
	NSString *deviceTYPE; //设备型号 e.g APPLEIOS
    
	NSString *appVERSION;//软件版本号 e.g 2.0
	
	NSString *deviceVERSION; //系统版本号 e.g 4.0.2
	
	NSString *deviceName; ////设备名称 e.g iphone/ipod/ipad
    
	NSString *deviceRESOLUTION; //设备实际分辨率 e.g 320*480
	
	NSString *deviceCURRENTLANGUAGE; //设备当前使用的语言 e.g zh_Hans
    
	NSString *deviceTime; //上传当前的时间
}

@property (nonatomic, retain) UIDevice *myDevice;
@property (nonatomic, retain) NSString *deviceTYPE;
@property (nonatomic, retain) NSString *deviceID;
@property (nonatomic, retain) NSString *appVERSION;
@property (nonatomic, retain) NSString *deviceVERSION;
@property (nonatomic, retain) NSString *deviceName;
@property (nonatomic, retain) NSString *deviceRESOLUTION;
@property (nonatomic, retain) NSString *deviceCURRENTLANGUAGE;
@property (nonatomic, retain) NSString *deviceTime;
@property (nonatomic, retain) NSString *deviceInfo;

+(NSString *)deviceInfo;

-(NSString *)convertString:(NSString *)str;

- (NSString *) platform;

@end