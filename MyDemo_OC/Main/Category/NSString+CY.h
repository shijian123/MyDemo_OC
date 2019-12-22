//
//  NSString+CY.h
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CY)

/**
 *  MD5加密
 *
 *  @return 返回加密之后的string
 */
- (NSString *) md5HexDigest;

/**
 *  判断是不是手机号码格式
 *
 *  @return 返回判断结果
 */
- (BOOL)isPhoneNum;

/**
 是否是固定电话
 
 @return 返回判断结果
 */
- (BOOL)isLandlineTelephone;

/**
 *  判断是不是正确的密码格式
 *
 *  @return 返回判断结果
 */
- (BOOL)isCorrectPassWord;

/**
 *  判断是否都是数字
 */
- (BOOL)isCheckPureNumAndCharacters;


/**
 *  判断是否为字母、数字
 */
- (BOOL)isCheckLetterAndNumber;

/**
 *  判断昵称是否为中文、字母或数字
 */
- (BOOL)isCheckNickName;

/**
 判断地址是否为中英文、数字、特殊字符
 */
- (BOOL)isCheckAddress;

/**
 *  判断输入的为金额（数字和小数点）
 */
- (BOOL)isCheckMoney;

/**
 *  判断字符串是否包含系统表情
 */
- (BOOL)detectionStringContainsEmoji:(NSString *)string;

/**
 *  判断是否是系统表情
 */
- (BOOL)stringContainsEmoji:(NSString *)string;

/**
 *  去掉字符串中的空格
 *  @return 返回去掉空格之后的字符串
 */
- (NSString *)removeThePlace;

/**
 *  计算字符串的size大小
 *
 *  @param font 字体大小
 *  @param maxW 最大的宽度
 *
 *  @return 返回size尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;

/**
 *  计算字符串的size大小（默认宽度为最大）
 */
- (CGSize)sizeWithFont:(UIFont *)font;

/**
 *  将毫秒转换成正常的时间显示(yyyy-MM-dd HH:mm:ss)
 *
 *  @return 返回转好的时间字符串
 */
- (NSString *)dateWithLongLongString;

/**
 *  将毫秒转换成正常的时间显示(yyyy-MM-dd)
 *
 *  @return 返回转好的时间字符串
 */
- (NSString *)dateWithLongLongStringWithYMD;

/**
 *  获取到date类型的时间
 *
 *  @return 返回转好的date类型的时间
 */
- (NSDate *)timeDateWithLongLongString;

/**
 *   将毫秒转换成正常的时间显示(自定义)
 *
 *  @param formatStr format 的显示类型
 *
 *  @return 返回转好的时间字符串
 */
- (NSString *)dateWithLongLongStringWithFormatter:(NSString *)formatStr;

/**
 *  进行attribute字体设置
 *
 *  @param range 改变的字符串的范围
 *  @param font  改变的字体大小
 *  @param color 改变的字体的颜色
 *
 *  @return 返回设置好的attribute
 */
- (NSMutableAttributedString *)attributeStringWithRange:(NSRange)range font:(UIFont *)font textColor:(UIColor *)color;

/**
 *  将月份转化为汉字
 *
 *  @param month 4
 *
 *  @return 4月
 */
+ (NSString *)becomeChineseStrWithNum:(NSInteger)month;

/**
 *  获得月份的最后日期
 *
 *  @param startString @"2015-7-1 00:00:00"
 *
 *  @return @"2015-7-31 00:00:00"
 */
+ (NSString *)getMonthEndStringWithMonthStartString:(NSString *)startString;

/**
 *  替换字符串中的“\\n为"\n"”
 *
 *  @return 处理好的字符串
 */
- (NSString *)replaceWrapMark;

/**
 替换图片地址中的"\\"为"/"
 
 @return 处理好的图片url
 */
- (NSString *)replaceImgURLMark;

/**
 *  给字符串添加千分符
 *
 *  @return 返回添加好的千分符
 */
- (NSString *)addThousandMark;

/**
 *  给字符串添加千分符(内部识别是否有小数点)
 *
 *  @return 返回添加好的千分符
 */
- (NSString *)addThousandSep;

/**
 *  给带有小数点后两位的字符串添加千分符
 *
 *  @return 返回添加好的千分符
 */
- (NSString *)addThousandMarkWithTwoPoint;

/**
 *  获取手机ip
 *
 *  @return 手机ip
 */
+ (NSString *)deviceIPAdress;

/**
 *  将date转成时间字符串
 */
+ (NSString *)dateStringByDate:(NSDate *)date;

/**
 *  闪退时间转换
 */
+ (NSString *)crashTimeStringByDate:(NSDate *)date;

/**
 *  当前设备的型号
 *
 *  @return 设备的型号
 */
+ (NSString *)currentDeviceModel;

/**
 *  获取到date类型的 将格林尼治时间转化为北京时间
 *
 *  @return 返回转好的date类型的时间
 */
- (NSDate *)timeDateWithLongLongStringWith8Hour;

/**
 *  获取跟当前时间对比的时间差
 *
 *  @return 返回时间差：xx分钟前、xx小时前、xx天前
 */
- (NSString *)timeIntervalFromNow;


- (NSString *)timeIntervalFromNow01;

/**
 获取跟当前时间对比的时间差
 
 @return 返回当前时间是否已经到达
 */
- (BOOL)timeIsArrived;

/**
 *  检测输入的小数点是不是合法的
 *
 *  @param text 输入框的输入文字
 *
 *  @param range 输入框的文本rangge
 *
 *  @param string replaceString
 *
 *  @return 是否合法
 */
+ (BOOL)checkNumbersIsAvailableWithFieldText:(NSString *)text range:(NSRange)range replacementString:(NSString *)string;

/**
 通过校验正则表达式来判断是否条件是否符合
 
 @param regex 正则表达式
 @return 是否合法
 */
- (BOOL)checkIsLegalByRegex:(NSString *)regex;


/**
 url decode
 
 @return decode urlString
 */
- (NSString *)URLDecode;

/**
 url encode
 
 @return encode urlString
 */
- (NSString *)urlEncode;

/**
 比较两个时间差
 
 @return 比较之后处理的时间串
 */
- (NSString *)differenceValueWithTime:(NSString *)subTime;

/**
 检测是否是url
 
 @return 返回yes or no
 */
- (BOOL)isUrl;

/**
 将空字符串替换成- -
 
 @return 返回替换后的字符串
 */
- (NSString *)replaceEmptyString;

/**
 将字符串左右添加空格 @“ 文字  ”
 */
- (NSString *)addSpaces;
@end

NS_ASSUME_NONNULL_END
