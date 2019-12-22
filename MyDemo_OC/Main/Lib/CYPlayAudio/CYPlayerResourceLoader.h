//
//  CYPlayerResourceLoader.h
//  MyDemo_OC
//
//  Created by zcy on 2019/7/22.
//  Copyright © 2019 CY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CYPlayerRequestManager.h"
#define MimeType @"video/mp4"

NS_ASSUME_NONNULL_BEGIN

@class DFPlayerResourceLoader;
@protocol CYPlayerResourceLoaderDelegate <NSObject>

- (void)loader:(DFPlayerResourceLoader *)loader isCached:(BOOL)isCached;

- (void)loader:(DFPlayerResourceLoader *)loader requestError:(NSInteger)errorCode;
@end

/**
 DFPlayer资源加载器
 */
@interface CYPlayerResourceLoader : NSObject<AVAssetResourceLoaderDelegate, CYPlayerRequestDelegate>

@property (nonatomic, weak) id<CYPlayerResourceLoaderDelegate> delegate;

@property (nonatomic, copy) void(^checkStatusBlock)(NSInteger statusCode);
/**退出播放器和切换歌曲时调用该方法*/
- (void)stopLoading;


@end

NS_ASSUME_NONNULL_END
