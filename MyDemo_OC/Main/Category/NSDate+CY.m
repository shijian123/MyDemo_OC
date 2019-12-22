//
//  NSDate+CY.m
//  MyDemo_OC
//
//  Created by zcy on 2019/8/27.
//  Copyright © 2019 CY. All rights reserved.
//

#import "NSDate+CY.h"

@implementation NSDate (CY)

/**
 *  判断某个时间是否为今年
 */
- (BOOL)isThisYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得某个时间的年月日时分秒
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return dateCmps.year == nowCmps.year;
}

/**
 *  判断某个时间是否为当月
 */
- (BOOL)isCurrentMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //比较两个时间的
    BOOL year = [calendar isDate:self equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitYear];
    BOOL month = [calendar isDate:self equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitMonth];
    if (year&&month) {
        return YES;
    }else
        return NO;
}

/**
 *  判断某个时间是否为昨天
 */
- (BOOL)isYesterday{
    NSDate *now = [NSDate date];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    NSDate *date = [fmt dateFromString:dateStr];
    now = [fmt dateFromString:nowStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

/**
 *  判断某个时间是否为今天
 */
- (BOOL)isToday{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}

/**
 *  判断某个时间跟Date的时间相比是否为今天
 */
- (BOOL)isTodayComparedToDate:(NSDate *)date{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:date];
    
    return [dateStr isEqualToString:nowStr];
}

/**
 *  判断某个时间是否为明天
 */
- (BOOL)isTomorrow{
    NSDate *now = [NSDate date];
    NSDate *tomorrow = [now dateByAddingTimeInterval:24*60*60];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *tomorrowStr = [fmt stringFromDate:tomorrow];
    
    return [dateStr isEqualToString:tomorrowStr];
}

/**
 *  判断某个时间跟Date的时间相比是否为明天
 */
- (BOOL)isTomorrowComparedToDate:(NSDate *)date{
    NSDate *tomorrow = [date dateByAddingTimeInterval:24*60*60];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *tomorrowStr = [fmt stringFromDate:tomorrow];
    
    return [dateStr isEqualToString:tomorrowStr];
}

/**
 *  判断某个时间是否已经过去
 */
- (BOOL)isPreviousTime{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:self toDate:now options:0];
    if (cmps.year>0) {
        return YES;
    }else if (cmps.month>0)
    {
        return YES;
    }else if(cmps.day >=1){
        return YES;
    }else{
        return NO;
    }
}

/**
 *  判断某个时间跟date相比是否是过去
 */
- (BOOL)isPreviousTimeToDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:self toDate:date options:0];
    if (cmps.year>0) {
        return YES;
    }else if (cmps.month>0)
    {
        return YES;
    }else if(cmps.day >=1){
        return YES;
    }else if(cmps.hour >= 1){
        return YES;
    }else if(cmps.minute >= 1){
        return YES;
    }else if(cmps.hour >= 1){
        return YES;
    }else{
        return NO;
    }
}

/**
 *  将时间转化成字符串
 */
- (NSString *)dateWithLongLongString{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd hh:MM:ss";
    NSString *dateStr = [fmt stringFromDate:self];
    return dateStr;
}

- (NSString *)dateWithLongLongStringWithYMD{
    return [self dateWithLongLongStringWithFormatter:@"yyyy-MM-dd"];
}

- (NSString *)dateWithLongLongStringWithFormatter:(NSString *)formatStr{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:formatStr];
    return [formatter stringFromDate:self];
}

@end
