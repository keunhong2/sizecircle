//  Created by Yuan on 12-11-14.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//
/**********************************************/

//如果要添加更多的表情请在这个文件添加数据

/**********************************************/


#import <Foundation/Foundation.h>
#define kHYEMOJI_IMG @"img"
#define kHYEMOJI_EM @"em"

typedef enum
{
    EmojiTypeHistory = 0,
    EmojiTypeSmile,
    EmojiTypeAnimal,
    EmojiTypeRemind,
    EmojiTypeCar,
    EmojiTypeChar
}EmojiType;

@interface HYEmojiData : NSObject
{
    NSDictionary *emojiDictionary;
}

@property(nonatomic,readonly)NSDictionary *emojiDictionary;

+(NSString*)historyFilePath;

@end
