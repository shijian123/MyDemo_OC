//
//  MBProgressHUD+CY.h
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (CY)
+ (void)showText:(NSString *)text toView:(UIView *)view;
+ (void)showText:(NSString *)text toView:(UIView *)view afterDelay:(NSTimeInterval)delay;
+ (void)showText:(NSString *)text;
+ (void)showText:(NSString *)text afterDelay:(NSTimeInterval)delay;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;
@end

NS_ASSUME_NONNULL_END
