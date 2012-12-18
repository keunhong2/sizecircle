//
//  ChatUserManager.m
//  DXQ
//
//  Created by 黄修勇 on 12-12-18.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "ChatUserManager.h"

@interface ChatUserManager (){

    NSMutableArray *chatUserArray;
}
@end
@implementation ChatUserManager

static ChatUserManager *chatManager=nil;

+(ChatUserManager *)shareChatUserManager{

    if (!chatManager) {
        chatManager=[[ChatUserManager alloc]init];
    }
    return chatManager;
}

-(id)init{

    self=[super init];
    if (self) {
        chatUserArray=[NSMutableArray new];
    }
    return self;
}


-(void)chatWithUser:(Users *)user{

    
}
@end
