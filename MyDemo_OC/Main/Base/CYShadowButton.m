//
//  CYShadowButton.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/17.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYShadowButton.h"

@implementation CYShadowButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    [self makeButtonShadowMethod];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    [self makeButtonShadowMethod];
    return self;
}

- (void)makeButtonShadowMethod{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
//    self.layer.shadowColor = [UIColor colorWithHex:0xF86965].CGColor;
    self.layer.shadowColor = self.backgroundColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.4;
    self.clipsToBounds = NO;
}

- (void)showShadow {
    [self makeButtonShadowMethod];
}

- (void)hiddenShadow {
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

@end
