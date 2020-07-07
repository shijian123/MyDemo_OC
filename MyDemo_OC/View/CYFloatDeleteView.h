//
//  CYFloatDeleteView.h
//  MyDemo_OC
//
//  Created by zcy on 2020/7/7.
//  Copyright © 2020 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYFloatDeleteView : UIView
+ (instancetype)sharedInstance;

- (void)showDeleteView;

- (void)hiddenDeleteView;

@end

NS_ASSUME_NONNULL_END
