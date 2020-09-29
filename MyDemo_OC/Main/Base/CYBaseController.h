//
//  CYBaseController.h
//  MyDome_OC
//
//  Created by zcy on 2019/6/4.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYBaseController : UIViewController
/**
 客服电话
 */
- (void)callServerPhone;

/// 添加截屏、录屏的通知
- (void)addShotScreenNotiMethod;

@end

NS_ASSUME_NONNULL_END
