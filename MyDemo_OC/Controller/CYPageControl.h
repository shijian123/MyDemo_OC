//
//  CYPageControl.h
//  MyDemo_OC
//
//  Created by zcy on 2019/7/5.
//  Copyright © 2019 CY. All rights reserved.
//  自定义PageControl

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYPageControl : UIView
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) NSInteger currentPage;

@end

NS_ASSUME_NONNULL_END
