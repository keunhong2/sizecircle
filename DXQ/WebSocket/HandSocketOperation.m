//
//  HandSocketOperation.m
//
//  Created by he yuan on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HandSocketOperation.h"

@implementation HandSocketOperation
@synthesize rString;
@synthesize rDict;
@synthesize senttime;

-(id)initWithInitWithReveivedString:(NSString *)rString_ rDict:(NSDictionary *)rDict_
{
    if(self = [super init])
    {
        [self setRDict:rDict_];
        [self setRString:rString_];
    }    
    return self;
}

-(void)main
{
    if (self.isCancelled)
    {
        return;
    }   
}



@end
