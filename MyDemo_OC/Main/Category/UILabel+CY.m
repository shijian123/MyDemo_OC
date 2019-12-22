//
//  UILabel+CY.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UILabel+CY.h"

@implementation UILabel (CY)

- (void)setAnimationFromLocX:(NSInteger)fromX toLocX:(NSInteger)toX duration:(NSTimeInterval)duration{
    self.x = fromX;
    [UIView beginAnimations:@"animation" context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    self.x = toX;
    [UIView commitAnimations];
}



- (UILabel *)getHeightSpaceLabelwithFont:(UIFont*)font withMaxW:(CGFloat)maxW withLineSpacing:(CGFloat)lineSpacing withWordSpacing:(CGFloat)wordSpacing{
    //如果lab的text没有，直接返回self
    if (self.text.length>0) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        //行高
        paraStyle.lineSpacing = lineSpacing;
        paraStyle.hyphenationFactor = 1.0;
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0;
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
        NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:[NSNumber numberWithFloat:wordSpacing]
                              };
        //设置高度
        CGSize size = [self.text boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
        
        //设置属性
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:self.text];
        [attrStr setAttributes:dic range:NSMakeRange(0, attrStr.length)];
        self.attributedText = attrStr;
        self.size = CGSizeMake(size.width, size.height+5);
        return self;
        
    }else
        return self;
}

- (UILabel *)getHeightSpaceLabelwithFont:(UIFont*)font withMaxW:(CGFloat)maxW withLineSpacing:(CGFloat)lineSpacing{
    UILabel *label = [self getHeightSpaceLabelwithFont:font withMaxW:maxW withLineSpacing:lineSpacing withWordSpacing:1.0f];
    return label;
}

@end
