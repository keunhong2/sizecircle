//
//  DXQBaseRequest.h
//  DXQ
//
//  Created by Yuan on 12-10-12.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <objc/message.h>

@interface DXQBaseRequest : NSObject
{
    ASIFormDataRequest *request;
    
    //所属manager的名称，例如uim (user info manager)
    NSString  *managerName;

    //manager下的action，例如login登陆
    NSString  *actionName;
    
    //参数
    NSString  *parameterJSONString;
}

@property (nonatomic, retain) ASIFormDataRequest *request;
@property (nonatomic, retain) NSString *managerName;
@property (nonatomic, retain) NSString *actionName;
@property (nonatomic, retain) NSString *parameterJSONString;

- (DXQBaseRequest *)initWithBackendManagerName:(NSString*)managerName;

- (void)startSynchronous;

- (void)startAsynchronous;

- (NSMutableDictionary *)defaultParameterDic;

-(void)cancel;

@end
