//
//  NSString+CY.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import "NSString+CY.h"
#import <CommonCrypto/CommonDigest.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/sysctl.h>

#define AVAILABLEDOTNUMBERS @"0123456789.\n"
#define AVAILABLENUMBERS @"0123456789\n"

@implementation NSString (CY)

- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}

- (NSString *) md5HexDigest{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

- (BOOL)match:(NSString *)pattern{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    
    return results.count > 0;
}

- (BOOL)isPhoneNum{
    return [self match:@"^1[0-9]\\d{9}$"];
}

- (BOOL)isLandlineTelephone{//跟后台要正则吧
    return YES;
}

- (BOOL)isCorrectPassWord{
    return [self match:@"[A-Za-z0-9\\^$\\.\\+\\*_@!#%&amp;~=-]{6,20}"];
}

/**
 *  判断是否都是数字
 */
- (BOOL)isCheckPureNumAndCharacters{
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(str.length > 0){
        return NO;
    }
    return YES;
}

/**
 *  判断是否为字母、数字
 */
- (BOOL)isCheckLetterAndNumber{
    NSString *regex = @"[0-9a-zA-Z]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

/**
 *  判断昵称是否为中文、字母、数字、“-、_”
 */
- (BOOL)isCheckNickName{
    NSString *regex = @"[0-9a-zA-Z\u4e00-\u9fa5]+";
    return [self checkIsLegalByRegex:regex];
}

/**
 通过校验正则表达式来判断是否条件是否符合
 
 @param regex 正则表达式
 @return 是否合法
 */
- (BOOL)checkIsLegalByRegex:(NSString *)regex{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

/**
 判断地址是否为中英文、数字、特殊字符
 */
- (BOOL)isCheckAddress{
    NSString *regex = @"[0-9a-zA-Z\u4e00-\u9fa5\\^$\\.\\,\\+\\*_@!?#%&amp;~=-]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

/**
 *  判断输入的为金额（数字和小数点）
 */
- (BOOL)isCheckMoney{
    NSString *regex = @"[0-9\\.]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

/**
 *  判断字符串是否包含系统表情
 */
- (BOOL)detectionStringContainsEmoji:(NSString *)string{
    NSInteger strLength = string.length;
    if (strLength){
        for (NSInteger i = 0; i < strLength; i ++){
            if (i < strLength - 1){
                NSString *tempStr = [string substringWithRange:NSMakeRange(i, 2)];
                if ([self stringContainsEmoji:tempStr]){
                    //@"结果：输入的字符中含有系统表情";
                    return YES;
                }else{
                    //@"结果：输入的字符中不含系统表情";
                }
            }
        }
    }
    return NO;
}

/**
 *  判断是否是系统表情
 */
- (BOOL)stringContainsEmoji:(NSString *)string{
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff){
             if (substring.length > 1){
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f){
                     returnValue = YES;
                 }
             }
         }else if (substring.length > 1){
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3){
                 returnValue = YES;
             }
         }else{
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff){
                 returnValue = YES;
             }else if (0x2B05 <= hs && hs <= 0x2b07){
                 returnValue = YES;
                 
             }else if (0x2934 <= hs && hs <= 0x2935){
                 returnValue = YES;
                 
             }else if (0x3297 <= hs && hs <= 0x3299){
                 
                 returnValue = YES;
                 
             }else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50){
                 
                 returnValue = YES;
             }
         }
     }];
    return returnValue;
    
}

- (NSString *)removeThePlace{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)dateWithLongLongString{
    return [self dateWithLongLongStringWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)dateWithLongLongStringWithYMD{
    return [self dateWithLongLongStringWithFormatter:@"yyyy-MM-dd"];
}

- (NSString *)dateWithLongLongStringWithFormatter:(NSString *)formatStr{
    NSDate* confromTimesp = [self timeDateWithLongLongString];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:formatStr];
    //    DKDLog(@"time : ## %@",[formatter stringFromDate:confromTimesp]);
    return [formatter stringFromDate:confromTimesp];
}

- (NSDate *)timeDateWithLongLongString{
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[self longLongValue]/1000];
    return confromTimesp;
}

- (NSMutableAttributedString *)attributeStringWithRange:(NSRange)range font:(UIFont *)font textColor:(UIColor *)color{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:self];
    [attributeStr addAttribute:NSFontAttributeName value:font range:range];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attributeStr;
}

+ (NSString *)becomeChineseStrWithNum:(NSInteger)month{
    switch (month) {
        case 1:
            return @"一月";
            break;
        case 2:
            return @"二月";
            break;
        case 3:
            return @"三月";
            break;
        case 4:
            return @"四月";
            break;
        case 5:
            return @"五月";
            break;
        case 6:
            return @"六月";
            break;
        case 7:
            return @"七月";
            break;
        case 8:
            return @"八月";
            break;
        case 9:
            return @"九月";
            break;
        case 10:
            return @"十月";
            break;
        case 11:
            return @"十一月";
            break;
        case 12:
            return @"十二月";
            break;
        default:
            return @"";
            break;
    }
}

+ (NSString *)getMonthEndStringWithMonthStartString:(NSString *)startString{
    
    NSArray *startA = [startString componentsSeparatedByString:@"-"];
    NSInteger year = [startA[0] integerValue];
    NSInteger month = [startA[1] integerValue];
    
    switch (month) {
        case 1:
            return [self stringWithFormat:@"%ld-01-31 23:59:59",(long)year];
            break;
        case 2:
            if((year%4==0&&year%100!=0)||year%400==0)
                return [self stringWithFormat:@"%ld-02-29 23:59:59",(long)year];
            else
                return [self stringWithFormat:@"%ld-02-28 23:59:59",(long)year];
            break;
        case 3:
            return [self stringWithFormat:@"%ld-03-31 23:59:59",(long)year];
            break;
        case 4:
            return [self stringWithFormat:@"%ld-04-30 23:59:59",(long)year];
            break;
        case 5:
            return [self stringWithFormat:@"%ld-05-31 23:59:59",(long)year];
            break;
        case 6:
            return [self stringWithFormat:@"%ld-06-30 23:59:59",(long)year];
            break;
        case 7:
            return [self stringWithFormat:@"%ld-07-31 23:59:59",(long)year];
            break;
        case 8:
            return [self stringWithFormat:@"%ld-08-31 23:59:59",(long)year];
            break;
        case 9:
            return [self stringWithFormat:@"%ld-09-30 23:59:59",(long)year];
            break;
        case 10:
            return [self stringWithFormat:@"%ld-10-31 23:59:59",(long)year];
            break;
        case 11:
            return [self stringWithFormat:@"%ld-11-30 23:59:59",(long)year];
            break;
        case 12:
            return [self stringWithFormat:@"%ld-12-31 23:59:59",(long)year];
            break;
            
        default:
            return @"";
            break;
    }
}

- (NSString *)addThousandMark{
    NSMutableString *tmpAmt = [NSMutableString stringWithString:self];
    NSInteger investLength = self.length;
    for (NSInteger count = 1; count * 3 < investLength; count ++) {
        [tmpAmt insertString:@"," atIndex:investLength - count *3];
    }
    
    return (NSString *)tmpAmt;
}

- (NSString *)addThousandSep{
    if ([self containsString:@"."]) {
        if ([self containsString:@"-"]){
            NSString *tmpStr = [self substringFromIndex:1];
            return [NSString stringWithFormat:@"-%@",[tmpStr addThousandMark]];
        }else
            return [self addThousandMarkWithTwoPoint];
    }else {
        if ([self containsString:@"-"]){
            NSString *tmpStr = [self substringFromIndex:1];
            return [NSString stringWithFormat:@"-%@",[tmpStr addThousandMark]];
        }else
            return [self addThousandMark];
    }
}

- (NSString *)addThousandMarkWithTwoPoint{
    NSMutableString *tmpAmt = [NSMutableString stringWithString:self];
    NSInteger investLength = self.length;
    for (NSInteger count = 2; count * 3 < investLength; count ++) {
        [tmpAmt insertString:@"," atIndex:investLength - count *3];
    }
    
    return (NSString *)tmpAmt;
    
}

+ (NSString *)dateStringByDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

+ (NSString *)crashTimeStringByDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

- (NSString *)differenceValueWithTime:(NSString *)subTime{
    NSDate *date1 = [subTime timeDateWithLongLongString];
    NSDate *date2 = [self timeDateWithLongLongString];
    if ([date2 timeIntervalSinceDate:date1] < 0) {//date1时间在date2时间之后
        return @"0天0小时0分";
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    NSString *str;
    str = [NSString stringWithFormat:@"%zd天%zd小时%zd分",cmps.day,cmps.hour,cmps.minute];
    
    return str;
}

+ (NSString *)deviceIPAdress{
    NSString *address = @"";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    
    if (success == 0) {//0 表示获取成功
        
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfaces);
    return address;
}

+ (NSString *)currentDeviceModel{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6Plus_s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone7Plus";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    if ([platform isEqualToString:@"iPhone10,1"]) return @"iPhone8";
    if ([platform isEqualToString:@"iPhone10,2"]) return @"iPhone8Plus";
    if ([platform isEqualToString:@"iPhone10,3"]) return @"iPhoneX";
    if ([platform isEqualToString:@"iPhone10,4"]) return @"iPhone8";
    if ([platform isEqualToString:@"iPhone10,5"]) return @"iPhone8Plus";
    if ([platform isEqualToString:@"iPhone10,6"]) return @"iPhoneX";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([platform isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([platform isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([platform isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([platform isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([platform isEqualToString:@"iPad6,11"])    return @"iPad 5 (WiFi)";
    if ([platform isEqualToString:@"iPad6,12"])    return @"iPad 5 (Cellular)";
    if ([platform isEqualToString:@"iPad7,1"])     return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([platform isEqualToString:@"iPad7,2"])     return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([platform isEqualToString:@"iPad7,3"])     return @"iPad Pro 10.5 inch (WiFi)";
    if ([platform isEqualToString:@"iPad7,4"])     return @"iPad Pro 10.5 inch (Cellular)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

- (NSDate *)timeDateWithLongLongStringWith8Hour{
    NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)([self longLongValue]/1000+8*60*60)];
    
    return confromTimesp;
}

+ (BOOL)checkNumbersIsAvailableWithFieldText:(NSString *)text range:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [text rangeOfString:@"."].location;
    if (NSNotFound == nDotLoc && 0 != range.location) {
        cs = [[NSCharacterSet characterSetWithCharactersInString:AVAILABLEDOTNUMBERS] invertedSet];
    }
    else {
        cs = [[NSCharacterSet characterSetWithCharactersInString:AVAILABLENUMBERS] invertedSet];
    }
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    if (NSNotFound != nDotLoc && range.location > nDotLoc + 2) {
        return NO;
    }
    return YES;
}

- (NSString *)replaceWrapMark{
    return [self stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
}

- (NSString *)replaceImgURLMark{
    return [self stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
}

- (NSString *)timeIntervalFromNow{
    NSDate *oldDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval ) [self longLongValue]/1000];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = [nowDate timeIntervalSinceDate:oldDate];
    NSInteger timeInterval = [NSNumber numberWithDouble:interval].integerValue;
    NSString *timeStr = @"";
    if (timeInterval < 60) {
        timeStr = [NSString stringWithFormat:@"%zd秒前",timeInterval];
    }
    if (timeInterval >= 60 && timeInterval < 60 *60) {
        timeStr = [NSString stringWithFormat:@"%zd分钟前",timeInterval/60];
    }
    if (timeInterval >= 60 *60 && timeInterval < 24 *60 *60) {
        timeStr = [NSString stringWithFormat:@"%zd小时前",timeInterval/(60 *60)];
    }
    if (timeInterval >= 24 *60 *60) {
        timeStr = [NSString stringWithFormat:@"%zd天前",timeInterval/(24 *60 *60)];
    }
    return timeStr;
}

- (NSString *)timeIntervalFromNow01{
    NSDate *oldDate = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval ) [self longLongValue]/1000];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = [nowDate timeIntervalSinceDate:oldDate];
    NSInteger timeInterval = [NSNumber numberWithDouble:interval].integerValue;
    NSString *timeStr = @"";
    if (timeInterval < 60) {
        timeStr = [NSString stringWithFormat:@"%zd秒前",timeInterval];
    }
    if (timeInterval >= 60 && timeInterval < 60 *60) {
        timeStr = [NSString stringWithFormat:@"%zd分钟前",timeInterval/60];
    }
    if (timeInterval >= 60 *60 && timeInterval < 24 *60 *60) {
        timeStr = [NSString stringWithFormat:@"%zd小时前",timeInterval/(60 *60)];
    }
    if (timeInterval >= 24 *60 *60 && timeInterval < 24 *60 *60 * 3) {
        timeStr = [NSString stringWithFormat:@"%zd天前",timeInterval/(24 *60 *60)];
    }
    if (timeInterval >= 24 *60 *60 * 3) {
        timeStr = [self dateWithLongLongStringWithYMD];
    }
    return timeStr;
}

- (BOOL)timeIsArrived{
    NSDate *futureTime = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)[self longLongValue]/1000];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval interval = [futureTime timeIntervalSinceDate:nowDate];
    NSInteger timeInterval = [NSNumber numberWithDouble:interval].integerValue;
    if (timeInterval<=0) {
        return YES;
    }else{
        return NO;
    }
}

- (NSString *)URLDecode{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

- (NSString *)urlEncode{
    NSString *newString =
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              CFSTR(":/?#[]@!$ '()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    return self;
}

- (BOOL)isUrl{
    if(self == nil) {
        return NO;
    }
    NSString *url;
    if (self.length>4 && [[self substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",self];
    }else{
        url = self;
    }
    NSString *urlRegex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
}

- (NSString *)replaceEmptyString{
    if (self.length == 0) {
        return @"- -";
    }else{
        return self;
    }
}

- (NSString *)addSpaces {
    return [NSString stringWithFormat:@" %@  ", self];
}


@end
