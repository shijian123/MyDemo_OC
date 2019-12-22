//
//  UIButton+CY.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UIButton+CY.h"

@implementation UIButton (CY)
@dynamic avoidRepeatEventInterval;

- (void)setAvoidRepeatEventInterval:(NSTimeInterval)avoidRepeatEventInterval{
    self.enabled = NO;
    [self performSelector:@selector(changeButtonStatus)withObject:self afterDelay:avoidRepeatEventInterval];//防止重复点击
}

- (void)changeButtonStatus{
    self.enabled = YES;
}

@end
