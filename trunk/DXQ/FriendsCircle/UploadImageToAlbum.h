//
//  UploadImageToAlbum.h
//  DXQ
//
//  Created by Yuan on 12-11-28.
//  Copyright (c) 2012年 http://www.heyuan110.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserCreatePhotoRequest.h"

@protocol UploadImageToAlbumDelegate;

@interface UploadImageToAlbum : NSObject<UserCreatePhotoRequestDelegate>
{
    UserCreatePhotoRequest *userCreatePhotoRequest;
    
    id<UploadImageToAlbumDelegate>delegate;
    
    NSDictionary *imageInfo;
}
@property(nonatomic,retain) NSDictionary *imageInfo;

@property(nonatomic,assign)id<UploadImageToAlbumDelegate>delegate;

-(void)startUploadImage:(UIImage *)uploadimage isHD:(BOOL)isHD;

-(id)initWithDelegate:(id)_delegate info:(NSDictionary *)info;

@end


@protocol UploadImageToAlbumDelegate <NSObject>

-(void)uploadImageToAlbumFinished:(UploadImageToAlbum*)up;

@end