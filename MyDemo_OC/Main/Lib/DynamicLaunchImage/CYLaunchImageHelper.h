//
//  CYLaunchImageHelper.h
//  MyDemo_OC
//
//  Created by zcy on 2020/9/27.
//  Copyright © 2020 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYLaunchImageHelper : NSObject

+ (UIImage *)snapshotStoryboardForPortrait:(NSString *)sbName;
+ (UIImage *)snapshotStoryboardForLandscape:(NSString *)sbName;

/// 替换所有的启动图为竖屏
+ (void)changeAllLaunchImageToPortrait:(UIImage *)image;
/// 替换所有的启动图为横屏
+ (void)changeAllLaunchImageToLandscape:(UIImage *)image;
/// 使用单独的图片分别替换竖、横屏启动图
+ (void)changePortraitLaunchImage:(UIImage *)portraitImage
             landscapeLaunchImage:(UIImage *)landScapeImage;

@end

NS_ASSUME_NONNULL_END

