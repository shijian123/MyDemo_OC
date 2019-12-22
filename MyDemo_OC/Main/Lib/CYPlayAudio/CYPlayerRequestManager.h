//
//  CYPlayerRequestManager.h
//  MyDemo_OC
//
//  Created by zcy on 2019/7/22.
//  Copyright © 2019 CY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSURLError.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CYPlayerRequestDelegate <NSObject>
/**
 得到服务器响应
 
 @param statusCode 状态码
 */
- (void)requestManagerDidReceiveResponseWithStatusCode:(NSInteger)statusCode;

/**
 从服务器接收到数据
 */
- (void)requestManagerDidReceiveData;

/**
 缓存结果
 
 @param isCached 是否完成了缓存
 */
- (void)requestManagerIsCached:(BOOL)isCached;

/**
 接收数据完成
 
 @param errorCode 错误码
 */
- (void)requestManagerDidCompleteWithError:(NSInteger)errorCode;

@end

/**
 CYPlayer请求管理器
 */
@interface CYPlayerRequestManager : NSObject
@property (nonatomic, weak) id<CYPlayerRequestDelegate> delegate;

@property (nonatomic) NSInteger requestOffset;//请求起始位置
@property (nonatomic) NSInteger fileLength;//文件长度
@property (nonatomic) NSInteger cacheLength;//缓冲长度
@property (nonatomic) BOOL cancel;//是否取消请求
@property (nonatomic) BOOL isHaveCache;//是否有缓存
@property (nonatomic) BOOL isObserveFileModifiedTime;//是否观察修改时间

+ (instancetype)requestWithUrl:(NSURL *)url;
- (instancetype)initWithUrl:(NSURL *)url;

- (void)requestStart;

@end

NS_ASSUME_NONNULL_END
