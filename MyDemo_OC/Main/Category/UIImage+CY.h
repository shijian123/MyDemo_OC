//
//  UIImage+CY.h
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CY)
/**
 根据颜色生成纯色图片
 
 @param color 颜色
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 拉伸图片，保护居中形状，拉伸两头
 
 @param size imageView的尺寸
 @return 返回拉伸后的图片
 */
- (UIImage *)stretchLeftAndRightWithContainerSize:(CGSize)size;

/**
 按比例拉伸图片
 
 @param ratio 右边的拉伸比例
 @return 返回拉伸后的图片
 */
- (UIImage *)stretchLeftAndRightWithContainerSize:(CGSize)size rightRatio:(CGFloat)ratio;

/**
 *  压缩图片至目标尺寸
 *
 *  @param targetWidth 图片最终尺寸的宽
 *
 *  @return 返回按照源图片的宽、高比例压缩至目标宽、高的图片
 */
- (UIImage *)imageCompressTargetWidth:(CGFloat)targetWidth;

/**
 截图tableView
 
 @param tableView
 @param size
 */
+ (UIImage *)screenShotImageWithTableView:(UITableView *)tableView size:(CGSize )size;

/**
 截图scrollview
 
 @param scrollView
 @param size
 */
+ (UIImage *)screenShotImageWithScrollView:(UIScrollView *)scrollView size:(CGSize )size;

/**
 截图View
 
 @param view
 @param size
 */
+ (UIImage *)screenShotImageWithView:(UIView *)view size:(CGSize )size;
@end

NS_ASSUME_NONNULL_END
