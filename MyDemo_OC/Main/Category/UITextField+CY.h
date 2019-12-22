//
//  UITextField+CY.h
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (CY)
/**
 动态设置placeholder的字体、字体大小以及输入框的字体大小
 
 @param placeholder 占位符
 @param placeholderFont 占位符的字体的大小
 @param textFont 输入框字体的大小
 */
- (void)setPlaceholder:(NSString *)placeholder placeholderFont:(UIFont *)placeholderFont textFont:(UIFont *)textFont;

@end

NS_ASSUME_NONNULL_END
