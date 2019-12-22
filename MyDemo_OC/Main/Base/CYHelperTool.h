//
//  CYHelperTool.h
//  MyDemo_OC
//
//  Created by zcy on 2019/8/27.
//  Copyright © 2019 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYHelperTool : NSObject
/**
 保存当前手机是否含有刘海
 */
+ (void)saveIsHaveBang;

/**
 获取当前手机是否含有刘海
 */
+ (BOOL)isHaveBang;

@end

NS_ASSUME_NONNULL_END
