//
//  UIViewController+Swizzling.h
//  RuntimeCodeDome
//
//  Created by zcy on 2019/5/14.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Swizzling)
/** 新增属性*/
@property (nonatomic,copy) NSString *cyTitle;

@end

NS_ASSUME_NONNULL_END
