//
//  UINavigationBar+CY.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UINavigationBar+CY.h"
#import <objc/runtime.h>

@implementation UINavigationBar (CY)

static char *navAlphaKey = "navAlphaKey";
-(CGFloat)navAlpha {
    if (objc_getAssociatedObject(self, navAlphaKey) == nil) {
        return 1;
    }
    return [objc_getAssociatedObject(self, navAlphaKey) floatValue];
}
-(void)setNavAlpha:(CGFloat)navAlpha {
    CGFloat alpha = MAX(MIN(navAlpha, 1), 0);// 必须在 0~1的范围
    
    UIView *barBackground = self.subviews[0];
    if (self.translucent == NO || [self backgroundImageForBarMetrics:UIBarMetricsDefault] != nil) {
        barBackground.alpha = alpha;
        
    } else {
        
        if (@available(iOS 10.0, *)) {
            UIView *effectFilterView = barBackground.subviews.lastObject;
            effectFilterView.alpha = alpha;
        } else {
            UIView *effectFilterView = barBackground.subviews.firstObject;
            effectFilterView.alpha = alpha;
        }
    }
#warning 适配iOS13
    if (@available(iOS 13.0, *)) {
        
    }else {
        /// 黑线
        UIImageView *shadowView = [barBackground valueForKey:@"_shadowView"];
        if (alpha < 0.01) {
            shadowView.hidden = YES;
        } else {
            shadowView.hidden = NO;
            shadowView.alpha = alpha;
        }
    }
    
    objc_setAssociatedObject(self, navAlphaKey, @(alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
