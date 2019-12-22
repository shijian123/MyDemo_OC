//
//  CYHelperTool.m
//  MyDemo_OC
//
//  Created by zcy on 2019/8/27.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYHelperTool.h"

@implementation CYHelperTool

/**
 保存当前手机是否含有刘海
 */
+ (void)saveIsHaveBang{
    //保存当前设备是否带有刘海
    BOOL isHaveBang = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) == 44 ? YES:NO;
    [CYUserDefaults setBool:isHaveBang forKey:CYDeviceBangKey];
    [CYUserDefaults synchronize];
}

/**
 获取当前手机是否含有刘海
 */
+ (BOOL)isHaveBang{
    BOOL isHaveBang = [CYUserDefaults boolForKey:CYDeviceBangKey];
    return isHaveBang;
}

@end
