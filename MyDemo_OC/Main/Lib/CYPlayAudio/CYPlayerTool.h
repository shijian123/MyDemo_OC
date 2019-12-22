//
//  CYPlayerTool.h
//  MyDemo_OC
//
//  Created by zcy on 2019/7/22.
//  Copyright © 2019 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CY_WeakSelf __weak __typeof(&*self)weakSelf = self;

//网络状态
typedef NS_ENUM(NSInteger, CYPlayerNetworkStatus) {
    CYPlayerNetworkStatusUnknown          = -1, //未知
    CYPlayerNetworkStatusNotReachable     = 0,  //无网络链接
    CYPlayerNetworkStatusReachableViaWWAN = 1,  //2G/3G/4G
    CYPlayerNetworkStatusReachableViaWiFi = 2   //WIFI
};

NS_ASSUME_NONNULL_BEGIN

@interface CYPlayerTool : NSObject

//链接
+ (NSURL *)customUrlWithUrl:(NSURL *)url;
+ (NSURL *)originalUrlWithUrl:(NSURL *)url;

//判断是否是本地音频
+ (BOOL)isLocalWithUrl:(NSURL *)url;
+ (BOOL)isLocalWithUrlString:(NSString *)urlString;

+ (CYPlayerTool *)shareInstance;
- (void)startMonitoringNetworkStatus:(void(^)(void))block;

@property (nonatomic) CYPlayerNetworkStatus networkStatus;

@end

NS_ASSUME_NONNULL_END
