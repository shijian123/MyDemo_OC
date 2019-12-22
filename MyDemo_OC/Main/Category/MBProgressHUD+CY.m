//
//  MBProgressHUD+CY.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import "MBProgressHUD+CY.h"

@implementation MBProgressHUD (CY)

#pragma mark 显示信息

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view afterDelay:(NSTimeInterval)delay{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 2秒之后再消失
    if (delay == 0) {
        [hud hide:YES afterDelay:2];
    }else{
        [hud hide:YES afterDelay:delay];
    }
}

#pragma mark 显示提醒文字（不带成功与否标志）

+ (void)showText:(NSString *)text toView:(UIView *)view{
    [self show:text icon:nil view:view afterDelay:2];
}

+ (void)showText:(NSString *)text toView:(UIView *)view afterDelay:(NSTimeInterval)delay{
    [self show:text icon:nil view:view afterDelay:delay];
}

+ (void)showText:(NSString *)text {
    [self showText:text toView:nil];
}

+ (void)showText:(NSString *)text afterDelay:(NSTimeInterval)delay{
    [self showText:text toView:nil afterDelay:delay];
}

#pragma mark 显示错误信息

+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view afterDelay:2];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view afterDelay:2];
}

#pragma mark 显示一些信息

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

@end
