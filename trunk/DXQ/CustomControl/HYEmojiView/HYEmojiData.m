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
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F604",kHYEMOJI_EM, @"e415",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F60A",kHYEMOJI_EM, @"e056",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F603",kHYEMOJI_EM, @"e057",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\u263A",kHYEMOJI_EM, @"e414",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F60D",kHYEMOJI_EM, @"e106",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F618",kHYEMOJI_EM, @"e418",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F618",kHYEMOJI_EM, @"e417",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F633",kHYEMOJI_EM, @"e40d",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F60C",kHYEMOJI_EM, @"e40a",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F601",kHYEMOJI_EM, @"e404",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F61C",kHYEMOJI_EM, @"e105",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F61D",kHYEMOJI_EM, @"e409",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F612",kHYEMOJI_EM, @"e40e",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F60F",kHYEMOJI_EM, @"e402",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F613",kHYEMOJI_EM, @"e108",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F614",kHYEMOJI_EM, @"e403",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F61E",kHYEMOJI_EM, @"e058",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F616",kHYEMOJI_EM, @"e407",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F625",kHYEMOJI_EM, @"e401",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F630",kHYEMOJI_EM, @"e40f",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F628",kHYEMOJI_EM, @"e40b",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F623",kHYEMOJI_EM, @"e406",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F622",kHYEMOJI_EM, @"e413",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F62D",kHYEMOJI_EM, @"e411",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F630",kHYEMOJI_EM, @"e412",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F632",kHYEMOJI_EM, @"e410",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F631",kHYEMOJI_EM, @"e107",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F620",kHYEMOJI_EM, @"e059",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F621",kHYEMOJI_EM, @"e416",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F62A",kHYEMOJI_EM, @"e408",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F637",kHYEMOJI_EM, @"e40c",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F47F",kHYEMOJI_EM, @"e11a",kHYEMOJI_IMG, nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F47D",kHYEMOJI_EM, @"e10c",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F49B",kHYEMOJI_EM, @"e32c",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\u2764",kHYEMOJI_EM, @"e022",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F494",kHYEMOJI_EM, @"e023",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F44D",kHYEMOJI_EM, @"e00e",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F44E",kHYEMOJI_EM, @"e421",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F44C",kHYEMOJI_EM, @"e420",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\u270A",kHYEMOJI_EM, @"e010",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F444",kHYEMOJI_EM, @"e41c",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F44F",kHYEMOJI_EM, @"e41f",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F491",kHYEMOJI_EM, @"e425",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\u2600",kHYEMOJI_EM, @"e04a",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F339",kHYEMOJI_EM, @"e032",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F197",kHYEMOJI_EM, @"e24d",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\u00AE",kHYEMOJI_EM, @"e24f",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\u00A9",kHYEMOJI_EM, @"e24e",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F192",kHYEMOJI_EM, @"e214",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F697",kHYEMOJI_EM, @"e01b",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\u2708",kHYEMOJI_EM, @"e01d",kHYEMOJI_IMG,nil],
                                     [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F49D",kHYEMOJI_EM, @"e437",kHYEMOJI_IMG,nil],
                                     nil];
        
        NSArray  *animalEmojiArray = [NSArray arrayWithObjects:
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F486",kHYEMOJI_EM, @"e31e",kHYEMOJI_IMG, nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F498",kHYEMOJI_EM, @"e329",kHYEMOJI_IMG, nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F647",kHYEMOJI_EM, @"e426",kHYEMOJI_IMG, nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F46B",kHYEMOJI_EM, @"e428",kHYEMOJI_IMG, nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F46F",kHYEMOJI_EM, @"e429",kHYEMOJI_IMG, nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F443",kHYEMOJI_EM, @"e41a",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F64F",kHYEMOJI_EM, @"e41d",kHYEMOJI_IMG, nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\u26C4",kHYEMOJI_EM, @"e048",kHYEMOJI_IMG, nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F42F",kHYEMOJI_EM, @"e050",kHYEMOJI_IMG, nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F477",kHYEMOJI_EM, @"e51b",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F478",kHYEMOJI_EM, @"e51c",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F483",kHYEMOJI_EM, @"e51f",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F436",kHYEMOJI_EM, @"e052",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F43A",kHYEMOJI_EM, @"e52a",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F430",kHYEMOJI_EM, @"e52c",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F40D",kHYEMOJI_EM, @"e52d",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F414",kHYEMOJI_EM, @"e52e",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F417",kHYEMOJI_EM, @"e52f",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F42D",kHYEMOJI_EM, @"e053",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F433",kHYEMOJI_EM, @"e054",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F427",kHYEMOJI_EM, @"e055",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F4F2",kHYEMOJI_EM, @"e104",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F435",kHYEMOJI_EM, @"e109",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F52B",kHYEMOJI_EM, @"e113",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F528",kHYEMOJI_EM, @"e116",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F3AF",kHYEMOJI_EM, @"e130",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F3B0",kHYEMOJI_EM, @"e133",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F6B2",kHYEMOJI_EM, @"e136",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F6BA",kHYEMOJI_EM, @"e139",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F6BD",kHYEMOJI_EM, @"e140",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F4E2",kHYEMOJI_EM, @"e142",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F512",kHYEMOJI_EM, @"e144",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F513",kHYEMOJI_EM, @"e145",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F6BB",kHYEMOJI_EM, @"e151",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F3E7",kHYEMOJI_EM, @"e154",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%C%C",0x0023,0x20E3],kHYEMOJI_EM, @"e210",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F195",kHYEMOJI_EM, @"e212",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F199",kHYEMOJI_EM, @"e213",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F21A",kHYEMOJI_EM, @"e216",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%C%C",(char*)0x0031,(char*)0x20E3],kHYEMOJI_EM, @"e21c",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%C%C",(char*)0x0032,(char*)0x20E3],kHYEMOJI_EM, @"e21d",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%C%C",(char*)0x0033,(char*)0x20E3],kHYEMOJI_EM, @"e21e",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%C%C",(char*)0x0034,(char*)0x20E3],kHYEMOJI_EM, @"e21f",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%C%C",(char*)0x0035,(char*)0x20E3],kHYEMOJI_EM, @"e220",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%C%C",0x0036,0x20E3],kHYEMOJI_EM, @"e221",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%C%C",0x0037,0x20E3],kHYEMOJI_EM, @"e222",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%C%C",0x0038,0x20E3],kHYEMOJI_EM, @"e223",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%C%C",0x0039,0x20E3],kHYEMOJI_EM, @"e224",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%C%C",0x0030,0x20E3],kHYEMOJI_EM, @"e225",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\u2B06",kHYEMOJI_EM, @"e232",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\u2B07",kHYEMOJI_EM, @"e233",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\u27A1",kHYEMOJI_EM, @"e234",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\u2B05",kHYEMOJI_EM, @"e235",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\u2197",kHYEMOJI_EM, @"e236",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\u2196",kHYEMOJI_EM, @"e237",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\u2198",kHYEMOJI_EM, @"e238",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\u2199",kHYEMOJI_EM, @"e239",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F6BE",kHYEMOJI_EM, @"e309",kHYEMOJI_IMG,nil],
                                      nil];
        
        NSArray  *remindEmojiArray = [NSArray arrayWithObjects:
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F192",kHYEMOJI_EM, @"e214",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F697",kHYEMOJI_EM, @"e01b",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\u2708",kHYEMOJI_EM, @"e01d",kHYEMOJI_IMG,nil],
                                      [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F49D",kHYEMOJI_EM, @"e437",kHYEMOJI_IMG,nil], nil];
        
        NSArray  *carEmojiArray = [NSArray arrayWithObjects:
                                   [NSDictionary dictionaryWithObjectsAndKeys:@"\u2600",kHYEMOJI_EM, @"e04a",kHYEMOJI_IMG,nil],
                                   [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F339",kHYEMOJI_EM, @"e032",kHYEMOJI_IMG,nil],
                                   [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F197",kHYEMOJI_EM, @"e24d",kHYEMOJI_IMG,nil] ,
                                   nil];
        
        NSArray  *charEmojiArray = [NSArray arrayWithObjects:
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F44E",kHYEMOJI_EM, @"e421",kHYEMOJI_IMG,nil],
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F44C",kHYEMOJI_EM, @"e420",kHYEMOJI_IMG,nil],
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"\u270A",kHYEMOJI_EM, @"e010",kHYEMOJI_IMG,nil],
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F444",kHYEMOJI_EM, @"e41c",kHYEMOJI_IMG,nil],
                                    [NSDictionary dictionaryWithObjectsAndKeys:@"\U0001F44F",kHYEMOJI_EM, @"e41f",kHYEMOJI_IMG,nil], nil];
        
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
