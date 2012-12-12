//  Created by Yuan on 12-11-14.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "HYEmojiData.h"

@implementation HYEmojiData
@synthesize emojiDictionary;

-(id)init
{
    if (self = [super init])
    {
        NSArray  *smileEmojiArray = [NSArray arrayWithObjects:
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue415",kHYEMOJI_EM, @"e415",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue056",kHYEMOJI_EM, @"e056",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue057",kHYEMOJI_EM, @"e057",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue414",kHYEMOJI_EM, @"e414",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue106",kHYEMOJI_EM, @"e106",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue418",kHYEMOJI_EM, @"e418",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue417",kHYEMOJI_EM, @"e417",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue40d",kHYEMOJI_EM, @"e40d",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue40a",kHYEMOJI_EM, @"e40a",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue404",kHYEMOJI_EM, @"e404",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue105",kHYEMOJI_EM, @"e105",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue409",kHYEMOJI_EM, @"e409",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue40e",kHYEMOJI_EM, @"e40e",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue402",kHYEMOJI_EM, @"e402",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue108",kHYEMOJI_EM, @"e108",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue403",kHYEMOJI_EM, @"e403",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue058",kHYEMOJI_EM, @"e058",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue407",kHYEMOJI_EM, @"e407",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue401",kHYEMOJI_EM, @"e401",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue40f",kHYEMOJI_EM, @"e40f",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue40b",kHYEMOJI_EM, @"e40b",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue406",kHYEMOJI_EM, @"e406",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue413",kHYEMOJI_EM, @"e413",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue411",kHYEMOJI_EM, @"e411",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue412",kHYEMOJI_EM, @"e412",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue410",kHYEMOJI_EM, @"e410",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue107",kHYEMOJI_EM, @"e107",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue059",kHYEMOJI_EM, @"e059",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue416",kHYEMOJI_EM, @"e416",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue408",kHYEMOJI_EM, @"e408",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue40c",kHYEMOJI_EM, @"e40c",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue11a",kHYEMOJI_EM, @"e11a",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue10c",kHYEMOJI_EM, @"e10c",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue32c",kHYEMOJI_EM, @"e32c",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue022",kHYEMOJI_EM, @"e022",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue023",kHYEMOJI_EM, @"e023",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue00e",kHYEMOJI_EM, @"e00e",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue421",kHYEMOJI_EM, @"e421",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue420",kHYEMOJI_EM, @"e420",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue010",kHYEMOJI_EM, @"e010",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue41c",kHYEMOJI_EM, @"e41c",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue41f",kHYEMOJI_EM, @"e41f",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue425",kHYEMOJI_EM, @"e425",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue04a",kHYEMOJI_EM, @"e04a",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue032",kHYEMOJI_EM, @"e032",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue24d",kHYEMOJI_EM, @"e24d",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue24f",kHYEMOJI_EM, @"e24f",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue24e",kHYEMOJI_EM, @"e24e",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue214",kHYEMOJI_EM, @"e214",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue01b",kHYEMOJI_EM, @"e01b",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue01d",kHYEMOJI_EM, @"e01d",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\ue437",kHYEMOJI_EM, @"e437",kHYEMOJI_IMG,nil],
                                     nil];
        
        NSArray  *animalEmojiArray = [NSArray arrayWithObjects:
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\ue415",kHYEMOJI_EM, @"e415",kHYEMOJI_IMG, nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\ue056",kHYEMOJI_EM, @"e056",kHYEMOJI_IMG, nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\ue057",kHYEMOJI_EM, @"e057",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\ue414",kHYEMOJI_EM, @"e414",kHYEMOJI_IMG, nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\ue106",kHYEMOJI_EM, @"e106",kHYEMOJI_IMG, nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\ue418",kHYEMOJI_EM, @"e418",kHYEMOJI_IMG, nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\ue417",kHYEMOJI_EM, @"e417",kHYEMOJI_IMG,nil],
                                      nil];
        
        NSArray  *remindEmojiArray = [NSArray arrayWithObjects:
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\ue214",kHYEMOJI_EM, @"e214",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\ue01b",kHYEMOJI_EM, @"e01b",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\ue01d",kHYEMOJI_EM, @"e01d",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\ue437",kHYEMOJI_EM, @"e437",kHYEMOJI_IMG,nil], nil];
        
        NSArray  *carEmojiArray = [NSArray arrayWithObjects:
                                   [NSDictionary dictionaryWithObjectsAndKeys:@"\ue04a",kHYEMOJI_EM, @"e04a",kHYEMOJI_IMG,nil],
                                   [NSDictionary dictionaryWithObjectsAndKeys:@"\ue032",kHYEMOJI_EM, @"e032",kHYEMOJI_IMG,nil],
                                   [NSDictionary dictionaryWithObjectsAndKeys:@"\ue24d",kHYEMOJI_EM, @"e24d",kHYEMOJI_IMG,nil] ,
                                   nil];
        
        NSArray  *charEmojiArray = [NSArray arrayWithObjects:
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"\ue421",kHYEMOJI_EM, @"e421",kHYEMOJI_IMG,nil],
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"\ue420",kHYEMOJI_EM, @"e420",kHYEMOJI_IMG,nil],
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"\ue010",kHYEMOJI_EM, @"e010",kHYEMOJI_IMG,nil],
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"\ue41c",kHYEMOJI_EM, @"e41c",kHYEMOJI_IMG,nil],
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"\ue41f",kHYEMOJI_EM, @"e41f",kHYEMOJI_IMG,nil], nil];
        
        emojiDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                           smileEmojiArray,[NSString stringWithFormat:@"%d",EmojiTypeSmile],
                           animalEmojiArray,[NSString stringWithFormat:@"%d",EmojiTypeAnimal],
                           remindEmojiArray,[NSString stringWithFormat:@"%d",EmojiTypeRemind],
                           carEmojiArray,[NSString stringWithFormat:@"%d",EmojiTypeCar],
                           charEmojiArray,[NSString stringWithFormat:@"%d",EmojiTypeChar], nil];
        
    }
    return self;
}

+(NSString*)historyFilePath
{
    NSString *tmpDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    return [tmpDirectory stringByAppendingPathComponent:@"hyemoji_history.dat"];
}

@end
