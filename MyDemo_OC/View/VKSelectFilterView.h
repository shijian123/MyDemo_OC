//
//  VKSelectFilterView.h
//  MyDemo_OC
//
//  Created by zcy on 2019/8/26.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VKSelectFilterView : UIView
@property (nonatomic, strong) NSArray *itemArr;

/**
 开始筛选
 */
- (void)showFilterView;

@end

NS_ASSUME_NONNULL_END
