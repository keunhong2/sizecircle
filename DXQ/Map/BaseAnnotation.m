//
//  BaseAnnotation.m
//  DXQ
//
//  Created by 黄修勇 on 12-11-12.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import "BaseAnnotation.h"

@implementation BaseAnnotation

-(void)dealloc{

    [_dic release];
    [_latKey release];
    [_longKey release];
    [_titleKey release];
    [_subTitleKey release];
    [super dealloc];
}

-(id)init{

    self=[super init];
    if (self) {
        self.latKey=@"WeiDu";
        self.longKey=@"JingDu";
        self.titleKey=@"Title";
    }
    return self;
}

-(NSString *)title{

    return [_dic objectForKey:_titleKey];
}

-(NSString *)subtitle{

    return [_dic objectForKey:_subTitleKey];
}

-(CLLocationCoordinate2D)coordinate{

    CLLocationCoordinate2D coord;
    coord.latitude=[[_dic objectForKey:_latKey] doubleValue];
    coord.longitude=[[_dic objectForKey:_longKey] doubleValue];
    return coord;
}

@end
