//
//  UIButton+CY.h
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (CY)
/** 可以用这个给重复点击加间隔*/
@property (nonatomic, assign) NSTimeInterval avoidRepeatEventInterval;
@end

NS_ASSUME_NONNULL_END
