//
//  Contact.m
//  DXQ
//
//  Created by 黄修勇 on 13-2-18.
//  Copyright (c) 2013年 http://www.heyuan110.com. All rights reserved.
//

#import "Contact.h"

@implementation Contact

-(id)init{

    self=[super init];
    if (self) {
        _phoneArray=[NSMutableArray new];
    }
    return self;
}

-(void)dealloc{

    [_firstName release];
    [_lastName release];
    [_phoneArray release];
    [super dealloc];
}

-(BOOL)isContainPhone:(NSString *)phone{

    return [_phoneArray containsObject:phone];
}

-(NSString *)fullName{

    return [self.firstName stringByAppendingFormat:@" %@",self.lastName];
}

-(BOOL)checkIsContainPhone:(NSArray *)array{

    for (NSString *phone in array) {
        if ([self isContainPhone:phone]) {
            return YES;
        }
    }
    return NO;
}
@end
