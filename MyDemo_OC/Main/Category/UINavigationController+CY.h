//
//  UINavigationController+CY.h
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (CY)
/**
 * 定制push的动画效果
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated animationType:(NSString *)type;

/**
 * 定制pop的动画效果
 */
- (void)popViewControllerAnimated:(BOOL)animated animationType:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
