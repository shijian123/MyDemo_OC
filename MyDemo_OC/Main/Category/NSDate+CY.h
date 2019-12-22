//
//  NSDate+CY.h
//  MyDemo_OC
//
//  Created by zcy on 2019/8/27.
//  Copyright © 2019 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (CY)

/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear;

/**
 *  判断某个时间是否为本月的
 */
- (BOOL)isCurrentMonth;

/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday;

/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday;

/**
 *  判断某个时间跟Date的时间相比是否为今天
 */
- (BOOL)isTodayComparedToDate:(NSDate *)date;

/**
 *  判断某个时间是否为明天
 */
- (BOOL)isTomorrow;

/**
 *  判断某个时间跟Date的时间相比是否为明天
 */
- (BOOL)isTomorrowComparedToDate:(NSDate *)date;

/**
 *  判断某个时间是否已经过去
 */
- (BOOL)isPreviousTime;

/**
 *  将时间转化成字符串
 */
- (NSString *)dateWithLongLongString;

/**
 *  将毫秒转换成正常的时间显示(yyyy-MM-dd)
 *
 *  @return 返回转好的时间字符串
 */
- (NSString *)dateWithLongLongStringWithYMD;

/**
 *   将毫秒转换成正常的时间显示(自定义)
 *
 *  @param formatStr format 的显示类型
 *
 *  @return 返回转好的时间字符串
 */
- (NSString *)dateWithLongLongStringWithFormatter:(NSString *)formatStr;

/**
 *  判断某个时间跟date相比是否是过去
 */
- (BOOL)isPreviousTimeToDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
