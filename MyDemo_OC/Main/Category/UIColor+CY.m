//
//  UIColor+CY.m
//  MyDemo_OC
//
//  Created by zcy on 2019/8/29.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UIColor+CY.h"

@implementation UIColor (CY)
+ (UIColor *)colorWithHex:(long)hexColor{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)labelColorWithHexString:(NSString *)colorStrig{
    const char *hexChar = [colorStrig cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return [UIColor colorWithHex:(NSInteger)hexNumber alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}
@end
