//
//  UITextField+CY.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UITextField+CY.h"

@implementation UITextField (CY)

- (void)setPlaceholder:(NSString *)placeholder placeholderFont:(UIFont *)placeholderFont textFont:(UIFont *)textFont{
    //输入金额的字体和“¥”一样
    self.font = textFont;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:placeholder];
    NSMutableParagraphStyle *style = [self.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    style.minimumLineHeight = self.font.lineHeight - (self.font.lineHeight - placeholderFont.lineHeight) / 2.0;
    NSDictionary *dic1 = @{NSFontAttributeName:placeholderFont,NSParagraphStyleAttributeName:style};
    [attributeStr addAttributes:dic1 range:NSMakeRange(0, placeholder.length)];
    self.minimumFontSize = self.height;//解决输入过大金额，字号变小问题
    self.attributedPlaceholder = attributeStr;
}

@end
