//
//  CYFloatPlayView.h
//  MyDemo_OC
//
//  Created by zcy on 2020/7/7.
//  Copyright © 2020 CY. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CYPlayerModel.h"

NS_ASSUME_NONNULL_BEGIN

// 停留方式
typedef NS_ENUM(NSUInteger,StayMode) {
    // 停靠左右两侧
    STAYMODE_LEFTANDRIGHT = 0,
    // 停靠左侧
    STAYMODE_LEFT,
    // 停靠右侧
    STAYMODE_RIGHT
};

@interface CYFloatPlayView : UIView
/** 悬浮图片停留的方式(默认为STAYMODE_LEFTANDRIGHT)*/
@property (nonatomic) StayMode stayMode;
/** 悬浮图片左右边距(默认5)*/
@property (nonatomic) CGFloat stayEdgeDistance;
/** 悬浮图片停靠的动画事件(默认0.3秒)*/
@property (nonatomic) CGFloat stayAnimateTime;
//@property (nonatomic, strong) RMPlayerModel *model;
@property (nonatomic, readonly) BOOL showing;
@property (nonatomic) void(^scrollBeganFloatViewBlock)(CGPoint currentPoint);
@property (nonatomic) void(^scrollingFloatViewBlock)(CGPoint currentPoint);
@property (nonatomic) void(^scrollEndedFloatViewBlock)(CGPoint currentPoint);
/**
 当滚动的时候悬浮图片居中在屏幕边缘
 */
- (void)moveToHalfInScreenWhenScrolling;

/**
 设置当前浮动图片的透明度
 */
- (void)setCurrentAlpha:(CGFloat)stayAlpha;

+ (instancetype)shareInstance;

- (void)addFloatView;
- (void)removeFloatView;
- (void)isShowFloatView:(BOOL)isShow;


- (void)startTestMethod;

@end

NS_ASSUME_NONNULL_END
