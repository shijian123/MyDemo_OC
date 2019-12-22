//
//  VKSelectRankView.h
//  MyDemo_OC
//
//  Created by zcy on 2019/8/26.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VKSelectRankView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleView_Y;
@property (nonatomic) void(^clickSelectRankBlock)(NSString *rankStr);
@property (nonatomic, strong) NSArray *titleArr;

- (void)showRankView;

@end

NS_ASSUME_NONNULL_END
