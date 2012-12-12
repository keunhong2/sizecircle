//
//  Tool.m
//  DXQ
//
//  Created by Yuan on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "Tool.h"
#import "GTMBase64.h"
#import "Reachability.h"
#import "RegexKitLite.h"

@implementation Tool

+(void)showAlertWithTitle:(NSString *)titel msg:(NSString *)msg{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:titel message:msg delegate:nil cancelButtonTitle:AppLocalizedString(@"确定") otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

//MD5加密
+(NSString*)ConMD5:(NSString*)origin
{
	const char *cStr = [origin UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	
	return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

//时间戳转时间
+(NSString*)convertTimestampToNSDate:(NSInteger)sp
{
    
    return [[self class]convertTimestampToNSDate:sp dateStyle:@"YYYY-MM-dd HH:mm:ss"];
}

+(NSString *)convertTimestampToNSDate:(NSInteger)sp dateStyle:(NSString *)dateStyle{

    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:sp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateStyle];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTime];
    [formatter release];
    return confromTimespStr;
}

//时间戳转时间
+(NSString*)convertTimestampToOnlyDate:(NSInteger)sp
{
    NSDate *confromTime = [NSDate dateWithTimeIntervalSince1970:sp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTime];
    [formatter release];
    return confromTimespStr;
}

+(NSString*)convertDateToString:(NSDate *)confromTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTime];
    [formatter release];
    return confromTimespStr;
}

//计算已经距离当前的时间，取最大值
+ (NSString *)calculateDate:(NSDate*)todate
{
    NSCalendar *cal = [NSCalendar currentCalendar];//定义一个NSCalendar对象
    NSDate *today = [NSDate date];//得到当前时间
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *d = [cal components:unitFlags fromDate:todate toDate:today options:0];
    NSInteger year = [d year];
    NSInteger month = [d month];
    NSInteger day = [d day];
    NSInteger hour = [d hour];
    NSInteger minute = [d minute];
    NSInteger second = [d second];
    if (year > 0)
    {
        return [NSString stringWithFormat:@"%d年",year];
    }
    else if(month > 0)
    {
        return [NSString stringWithFormat:@"%d月",month];
    }
    else if(day > 0)
    {
        return [NSString stringWithFormat:@"%d天",day];
    }
    else if(hour > 0)
    {
        return [NSString stringWithFormat:@"%d小时",hour];
        
    }
    else if(minute > 0)
    {
        return [NSString stringWithFormat:@"%d分",minute];
    }
    else if(second > 0)
    {
        return [NSString stringWithFormat:@"%d秒",second];
    }
    else
        return @"0秒";
}

//去掉空格
+(NSString *)trimmingWhiteSpaceCharacter:(NSString *)str
{
    if (str == nil || [str length]<1)return nil;
    NSString *newstr = [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    newstr = [newstr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return newstr;
}

+(NSString *)TrimJsonChar:(NSString *)jsonstr
{
	NSString *responseString;
	
	responseString = [jsonstr
					  stringByReplacingOccurrencesOfString:@"\15" withString:@""];
	responseString = [responseString
					  stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	responseString = [responseString
					  stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	responseString = [responseString
					  stringByTrimmingCharactersInSet:
					  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	return responseString;
}

//在使用的时候释放
+ (NSString*)encodeBase64:(NSString*)input
{
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    data = [GTMBase64 encodeData:data];
    NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return base64String;
}

//在使用的时候释放
+ (NSString*)decodeBase64:(NSString*)input
{
    NSData *data = [GTMBase64 decodeString:input];
    NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    return base64String;
}

+(BOOL) isNetworkEnabled
{
    NSInteger nNetworkStatus = 0;
    
	if (nNetworkStatus == 0)
    {
		nNetworkStatus = 1;
		// check wifi first
		Reachability* wifi = [Reachability reachabilityForLocalWiFi];
		[wifi startNotifier];
		NetworkStatus netStatus = [wifi currentReachabilityStatus];
		if (netStatus == NotReachable) {
			// check WWAN
			Reachability* internet = [Reachability reachabilityForInternetConnection];
			[internet startNotifier];
			netStatus = [internet currentReachabilityStatus];
			if (netStatus == NotReachable) {
				nNetworkStatus = -1;
			}
		}
	}
	if (nNetworkStatus == -1)
    {
		// show alet
		UIAlertView * alert = [[UIAlertView alloc]
							   initWithTitle:@""
							   message:@"当前网络不可用!"
							   delegate:nil
							   cancelButtonTitle:nil
							   otherButtonTitles:@"确定", nil];
		[alert show];
		[alert release];
		return NO;
	}
	return YES;
}

//计算两点之间的距离
+(CGFloat)getDistanceFromPoint:(CLLocationCoordinate2D)startpoint toPoint:(CLLocationCoordinate2D)endpoint
{
    CLLocation *startLocation = [[CLLocation alloc]initWithLatitude:startpoint.latitude longitude:startpoint.longitude];
    
    CLLocation *endLocation = [[CLLocation alloc]initWithLatitude:endpoint.latitude longitude:endpoint.longitude];
    
    CGFloat distance = [startLocation distanceFromLocation:endLocation];
    
    [startLocation release];[endLocation release];

    return distance;
}

+(NSString *)checkData:(id)data
{
    if ([data isEqual:[NSNull null]]) {
        return @"";
    }
    if ([data isKindOfClass:[NSString class]]) {
        return (NSString *)data;
    }
    return [NSString stringWithFormat:@"%@",data];
}

+(CGSize)getFitSizeFromCGSize:(CGSize)fitSize withMaxWidth:(CGFloat)w withMaxHeight:(CGFloat)h
{
    float _originalWidth = fitSize.width;
    float _originalHeight = fitSize.height;
    float _resultWidth = 0.0f;
    float _resultHeight = 0.0f;
    if (_originalWidth <= w && _originalHeight <=h) {
        _resultWidth = _originalWidth;
        _resultHeight = _originalHeight;
    }
    else
    {
        if (_originalWidth/_originalHeight > w/h ) {
            if (_originalWidth >= w) {
                _resultWidth = w;
                _resultHeight = _resultWidth*_originalHeight/_originalWidth;
            }
            else
            {
                _resultWidth = _originalWidth;
                _resultHeight = _resultWidth*_originalHeight/_originalWidth;
            }
        }
        else
        {
            if (_originalHeight >= h) {
                _resultHeight = h;
                _resultWidth = _resultHeight*_originalWidth/_originalHeight;
            }
            else
            {
                _resultHeight = _originalHeight;
                _resultWidth = _resultHeight*_originalWidth/_originalHeight;
            }
        }
    }
    return CGSizeMake(_resultWidth, _resultHeight);
}

+(NSString *)convertTimeBySecound:(NSTimeInterval)time{

    if (time<=0) {
        return @"";
    }
    //24*60*60
    NSInteger dayInt=time/(24*60*60);
    NSInteger lessDaySec=time-dayInt*(24*60*60);
    NSInteger hours=lessDaySec/(60*60);
    NSInteger lessHours=lessDaySec-hours*(60*60);
    NSInteger min=lessHours/60;
    NSInteger sec=lessHours-min*60;
    NSString *dayText=@"";
    if (dayInt!=0) {
        dayText=[NSString stringWithFormat:@"%d天",dayInt];
    }
    NSString *hourText=@"";
    if (hours!=0)
    {
        hourText=[NSString stringWithFormat:@"%d小时",hours];
    }
    NSString *minText=@"";
    if (min!=0)
    {
        minText=[NSString stringWithFormat:@"%d分钟",min];
    }
    NSString *secText=@"";
    if (sec!=0)
    {
        secText=[NSString stringWithFormat:@"%d秒",sec];
    }
    return [NSString stringWithFormat:@"%@%@%@%@",dayText,hourText,minText,secText];
}

+(BOOL)checkUrlValue:(NSString*)string
{
    if (![string isMatchedByRegex:@"\\b(https?)://(?:(\\S+?)(?::(\\S+?))?@)?([a-zA-Z0-9\\-.]+)(?::(\\d+))?((?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?"])
    {
        return NO;
    }
    return YES;
}


+(void)setImageView:(UIImageView *)imageView toImage:(UIImage *)image
{
    CGPoint point=imageView.center;
    if (image.size.width<imageView.frame.size.width&&image.size.height<imageView.frame.size.height) {
        [imageView sizeToFit];
    }else
    {
        float imgScale=image.size.width/image.size.height;
        
        float viewScale=imageView.frame.size.width/imageView.frame.size.height;
        if (imgScale>viewScale) {
            float imageHeight=imageView.frame.size.width/imgScale;
            imageView.frame=CGRectMake(0.f, 0, imageView.frame.size.width, imageHeight);
        }else
        {
            float imageWidth=imageView.frame.size.height*imgScale;
            imageView.frame=CGRectMake(0.f, 0.f, imageWidth, imageView.frame.size.height);
        }
    }
    imageView.center=point;
}

+ (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
