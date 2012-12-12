//
//  HandSocketOperation.h
//
//  Created by he yuan on 12-10-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandSocketOperation : NSOperation
{
    NSNumber *senttime;
    NSString *rString;
    NSDictionary *rDict;
}
@property(nonatomic,retain)NSNumber *senttime;
@property(nonatomic,retain)NSString *rString;
@property(nonatomic,retain)NSDictionary *rDict;

-(id)initWithInitWithReveivedString:(NSString *)rString_ rDict:(NSDictionary *)rDict_;

@end
