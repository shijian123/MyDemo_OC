//
//  UIWindow+CY.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UIWindow+CY.h"

@implementation UIWindow (CY)
- (void)switchRootViewController{
    NSString *key = @"CFBundleShortVersionString";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    if ([currentVersion isEqualToString:lastVersion]) {//非第一次登陆或非升级之后第一次使用
//        if ([DKDAccountTool token].length == 0) {//没有进行登陆
//            DKDNavigationController *navVC = [[DKDNavigationController alloc]initWithRootViewController:[[DKDGuideViewController alloc]init]];
//            self.rootViewController = navVC;
//        }else{
//            self.rootViewController = [[DKDTabBarController alloc] init];
//        }
    } else {//添加新特性界面
//        self.rootViewController = [[DKDNewFeatureController alloc] init];
//        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
