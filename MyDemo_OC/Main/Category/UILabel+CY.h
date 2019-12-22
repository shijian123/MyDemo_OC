//
//  UILabel+CY.h
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (CY)
/**
 *  跑马灯效果
 *
 *  @param fromX      起始X的位置
 *  @param toX        终止X的位置
 *  @param duration   动画的时长
 */
- (void)setAnimationFromLocX:(NSInteger)fromX toLocX:(NSInteger)toX duration:(NSTimeInterval)duration;

/**
 将lab设置间距并返回设置好宽高的lab
 
 @param font lab的字号
 @param maxW lab的最大宽度
 @param lineSpacing 行间距
 @param wordSpacing 字间距
 @return 返回间距、宽、高设置好的lab
 */
- (UILabel *)getHeightSpaceLabelwithFont:(UIFont*)font withMaxW:(CGFloat)maxW withLineSpacing:(CGFloat)lineSpacing withWordSpacing:(CGFloat)wordSpacing;

/**
 将lab设置间距并返回设置好宽高的lab(字间距默认为1.0f)
 
 @param font lab的字号
 @param maxW lab的最大宽度
 @param lineSpacing 行间距
 @return 返回间距、宽、高设置好的lab
 */
- (UILabel *)getHeightSpaceLabelwithFont:(UIFont*)font withMaxW:(CGFloat)maxW withLineSpacing:(CGFloat)lineSpacing;

@end

NS_ASSUME_NONNULL_END
