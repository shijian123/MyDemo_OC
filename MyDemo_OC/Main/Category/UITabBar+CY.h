//
//  UITabBar+CY.h
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (CY)
/**
 显示小红点
 
 @param index item的下标
 */
- (void)showBadgeOnItemIndex:(int)index;

/**
 隐藏小红点
 
 @param index item的下标
 */
- (void)hideBadgeOnItemIndex:(int)index;
@end

NS_ASSUME_NONNULL_END
