//
//  UITabBar+CY.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UITabBar+CY.h"

@implementation UITabBar (CY)

- (void)showBadgeOnItemIndex:(int)index{
    [self removeBadgeOnItemIndex:index];
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    CGFloat cornerRadius = 3.5;
    badgeView.layer.cornerRadius = cornerRadius;
    badgeView.backgroundColor = DefaultRedColor;
    CGRect tabFrame = self.frame;
    float percentX = (index +0.56) /4.0;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, cornerRadius *2, cornerRadius *2);
    
    [self addSubview:badgeView];
}

- (void)hideBadgeOnItemIndex:(int)index{
    [self removeBadgeOnItemIndex:index];
}

- (void)removeBadgeOnItemIndex:(int)index{
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
