//
//  CYPlayAudioController.h
//  MyDemo_OC
//
//  Created by zcy on 2019/7/19.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYBaseController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

NS_ASSUME_NONNULL_BEGIN
//状态码
typedef NS_ENUM(NSUInteger, CYPlayerStatusCode) {
    CYPlayerStatus_NetworkUnavailable    = 0,//没有网络连接（注意：对于未缓存的网络音频，点击播放时若无网络会返回该状态码,播放时若无网络也会返回该状态码哦。CYPlayer支持运行时断点续传，即缓冲时网络从无到有，可以断点续传，而某音频没缓冲完就退出app，再进入app没做断点续传，以上特点与QQ音乐一致）
    CYPlayerStatus_NetworkViaWWAN        = 1,//WWAN网络状态（注意：属性isObserveWWAN（默认NO）为YES时，对于未缓存的网络音频，只在点击该音频时返回该状态码。而音频正在缓冲时，网络状态由wifi到wwan并不会返回该状态码，以上特点与QQ音乐一致）
    CYPlayerStatus_RequestTimeOut        = 2,//音频请求超时
    CYPlayerStatus_UnavailableData       = 3,//无法获得该音频资源
    CYPlayerStatus_UnavailableURL        = 4,//无效的URL地址
    CYPlayerStatus_PlayError             = 5,//音频无法播放
    CYPlayerStatus_DataError             = 6,//点击的音频ID不在当前数据源里（即数组越界）
    CYPlayerStatus_CacheFailure          = 7,//当前音频缓存失败
    CYPlayerStatus_CacheSuccess          = 8,//当前音频缓存完成
    CYPlayerStatus_SetPreviousAudioModelError = 9,//配置历史音频信息失败
    CYPlayerStatus_UnknownError          = 100,//未知错误
};

@interface CYPlayAudioController : CYBaseController

/**当前音频播放进度*/
@property (nonatomic, readonly, assign) CGFloat                 progress;
/**当前音频当前时间*/
@property (nonatomic, readonly, assign) CGFloat                 currentTime;
/**当前音频总时长*/
@property (nonatomic, readonly, assign) CGFloat                 totalTime;

@end

NS_ASSUME_NONNULL_END
