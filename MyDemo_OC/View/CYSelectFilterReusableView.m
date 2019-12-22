//
//  CYSelectFilterReusableView.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/11.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYSelectFilterReusableView.h"

@implementation CYSelectFilterReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLab];
    }
    return self;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, self.height)];
        _titleLab.textColor = DefaultTextBlackColor;
        _titleLab.font = [UIFont boldSystemFontOfSize:14];
        
    }
    return _titleLab;
}
@end
