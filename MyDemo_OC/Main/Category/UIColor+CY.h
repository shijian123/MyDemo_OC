//
//  UIColor+CY.h
//  MyDemo_OC
//
//  Created by zcy on 2019/8/29.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CY)
/**
 * 通过十六进制字符串进行创建标签color
 */
+ (UIColor *)labelColorWithHexString:(NSString *)colorStrig;
/**
 * 通过十六进制数字进行创建color
 */
+ (UIColor *)colorWithHex:(long)hexColor;
/**
 * 通过十六进制数字进行创建color 设置alpha通道的值，alpha并不是透明度，而是通过这个alpha的可以影响渲染的效果达到透明度的调整
 */
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)alpha;

@end

NS_ASSUME_NONNULL_END
