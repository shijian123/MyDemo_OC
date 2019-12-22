//
//  CYSelectFilterViewCell.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/11.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYSelectFilterViewCell.h"

@interface CYSelectFilterViewCell ()

@end

@implementation CYSelectFilterViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.titleLab];
        self.backgroundColor = DefaultBackgroundColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
    }
    return self;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLab.textColor = DefaultTextBlackColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLab];
        
    }
    return _titleLab;
}


@end
