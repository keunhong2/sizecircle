//
//  Device.m
//  DXQ
//
//  Created by Yuan on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//
#import "Device.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import "UIDevice+IdentifierAddition.h"
@implementation Device
@synthesize myDevice, deviceTYPE, deviceID,appVERSION,deviceVERSION,deviceName,deviceRESOLUTION,deviceCURRENTLANGUAGE;
@synthesize deviceTime;
@synthesize deviceInfo;

-(id) init
{
    if (self = [super init])
    {
		self.myDevice = [UIDevice currentDevice];
        
		self.deviceID = [self convertString:[[UIDevice currentDevice] uniqueDeviceIdentifier]];
		
		self.deviceTYPE =[self convertString:[myDevice systemName]];
		
		self.appVERSION = [self convertString:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]];
		
		self.deviceVERSION = [self convertString:[myDevice systemVersion]];
		
		NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		self.deviceTime = [self convertString:[dateFormatter stringFromDate:[NSDate date]]];
        [dateFormatter release];
        self.deviceName =  [myDevice model];
		
		CGSize pixelBufferSize = [[[UIScreen mainScreen] currentMode] size];
		
		self.deviceRESOLUTION = [self convertString:[NSString stringWithFormat:@"%0.f*%0.f",pixelBufferSize.width,pixelBufferSize.height]];
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
        
		self.deviceCURRENTLANGUAGE = [self convertString:[languages objectAtIndex:0]];
        
        NSString *platform = [self platform];
		
        self.deviceInfo = [NSString stringWithFormat:@"DeviceID:%@\n Platform:%@\n DeviceType:%@\n AppVersion:%@\n DeviceVersion:%@\n DeviceName:%@\n DeviceTime:%@\n DeviceResolution:%@\n DeviceLanguage:%@\n",deviceID,platform,deviceTYPE,appVERSION,deviceVERSION,deviceName,deviceTime,deviceRESOLUTION,deviceCURRENTLANGUAGE];
        
    }
    return self;
}

+(NSString *)deviceInfo{

    Device *device=[[Device alloc]init];
    NSString *deviceInfo=[NSString stringWithString:device.deviceInfo];
    [device release];
    return deviceInfo;
}

- (NSString *) platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform =[NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

#pragma mark 转换string
-(NSString *)convertString:(NSString *)str
{
    NSString *result_ =	(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                            (CFStringRef)str,
                                                                            NULL,
                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                            kCFStringEncodingUTF8 );
    return [result_ autorelease];
}

- (void)dealloc
{
    [deviceInfo release];
	[deviceTime release];
	[appVERSION release];
	[deviceVERSION release];
	[deviceName release];
	[deviceRESOLUTION release];
	[deviceCURRENTLANGUAGE release];
	[deviceTYPE release];
    [myDevice release];
    [deviceID release];
    [super dealloc];
}
@end