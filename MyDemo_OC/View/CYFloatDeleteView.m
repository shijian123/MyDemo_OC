//
//  CYFloatDeleteView.m
//  MyDemo_OC
//
//  Created by zcy on 2020/7/7.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYFloatDeleteView.h"

@implementation CYFloatDeleteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)sharedInstance {
    static CYFloatDeleteView *view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[CYFloatDeleteView alloc] initWithFrame:CGRectMake(0, MainScreenHeight, MainScreenWidth, 100)];
        UILabel *lab = [[UILabel alloc] initWithFrame:view.bounds];
        lab.text = @"Delete";
        lab.font = [UIFont systemFontOfSize:20 weight:UIFontWeightHeavy];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = [UIColor colorWithHex:0xeeeeee];
        [view addSubview:lab];
        view.backgroundColor = [UIColor redColor];
        [[UIApplication sharedApplication].keyWindow addSubview:view];
    });
    return view;
}

- (void)showDeleteView {
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    if (self.origin.y == MainScreenHeight-100) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.origin = CGPointMake(0, MainScreenHeight-100);
    }];
}

- (void)hiddenDeleteView {
    if (self.origin.y == MainScreenHeight) {
        return;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.origin = CGPointMake(0, MainScreenHeight);
    }];
}

@end
