//
//  Tool.h
//  DXQ
//
//  Created by Yuan on 12-10-10.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <commoncrypto/CommonDigest.h>

@interface Tool : NSObject

+(void)showAlertWithTitle:(NSString *)titel msg:(NSString *)msg;

+(NSString *)trimmingWhiteSpaceCharacter:(NSString *)str;

+(NSString*) ConMD5:(NSString*) str;

+ (NSString *)calculateDate:(NSDate*)todate;

+(NSString*)convertTimestampToNSDate:(NSInteger)sp;

+(NSString*)convertTimestampToOnlyDate:(NSInteger)sp;

+(NSString*)convertDateToString:(NSDate *)confromTime;

+(NSString *)convertTimestampToNSDate:(NSInteger)sp dateStyle:(NSString *)dateStyle;

+(NSString *)TrimJsonChar:(NSString *)jsonstr;

+(CGFloat)getDistanceFromPoint:(CLLocationCoordinate2D)startpoint toPoint:(CLLocationCoordinate2D)endpoint;

+ (NSString*)encodeBase64:(NSString*)input;

+ (NSString*)decodeBase64:(NSString*)input;

+(NSString *)checkData:(id)data;

+(CGSize)getFitSizeFromCGSize:(CGSize)fitSize withMaxWidth:(CGFloat)w withMaxHeight:(CGFloat)h;

+(NSString *)convertTimeBySecound:(NSTimeInterval)time;

+(BOOL)checkUrlValue:(NSString*)string;

+(void)setImageView:(UIImageView *)imageView toImage:(UIImage *)image;

+ (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size;

@end


@interface NSNull (Value)
-(NSInteger)integerValue;
-(int)intValue;
@end