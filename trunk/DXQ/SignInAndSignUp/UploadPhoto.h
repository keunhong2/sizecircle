//
//  UploadPhoto.h
//  DXQ
//
//  Created by Yuan on 12-11-26.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserChangeFaceRequest.h"

@protocol UploadPhotoDelegate;

@interface UploadPhoto : NSObject<UserChangeFaceRequestDelegate>
{
    UserChangeFaceRequest *userChangeFaceRequest;
    
    id<UploadPhotoDelegate>delegate;
}

@property(nonatomic,assign)id<UploadPhotoDelegate>delegate;

-(void)startUploadImage:(UIImage *)uploadimage;

-(id)initWithDelegate:(id)_delegate;

@end


@protocol UploadPhotoDelegate <NSObject>

-(void)uploadPhotoFinished:(UploadPhoto*)up;

@end
