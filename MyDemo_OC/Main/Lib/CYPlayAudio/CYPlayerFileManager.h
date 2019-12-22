//
//  CYPlayerFileManager.h
//  MyDemo_OC
//
//  Created by zcy on 2019/7/22.
//  Copyright © 2019 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 CYPlayer缓存文件管理器
 */
@interface CYPlayerFileManager : NSObject

/**cache文件夹创建用户缓存目录*/
+ (void)cy_playerCreateCachePathWithId:(NSString *)Id;

/**当前用户Id缓存文件夹地址*/
+ (NSString *)cy_playerUserCachePath;

/**创建临时文件*/
+ (BOOL)cy_createTempFile;

/**往临时文件写入数据*/
+ (void)cy_writeDataToAudioFileTempPathWithData:(NSData *)data;

/**读取临时文件数据*/
+ (NSData *)cy_readTempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length;

/**保存临时文件到缓存文件夹*/
+ (void)cy_moveAudioFileFromTempPathToCachePath:(NSURL *)url blcok:(void(^)(BOOL isSuccess,NSError *error))block;

/**是否存在缓存文件 存在：返回文件路径 不存在：返回nil*/
+ (NSString *)cy_isExistAudioFileWithURL:(NSURL *)url;

/**清除url对应的本地缓存*/
+ (void)cy_playerClearCacheWithUrl:(NSURL *)url block:(void(^)(BOOL isSuccess, NSError *error))block;

/**计算缓存大小*/
+ (CGFloat)cy_countCacheSizeForCurrentUser:(BOOL)isCurrentUser;

/**清除缓存*/
+ (void)cy_clearCacheForCurrentUser:(BOOL)isClearCurrentUser block:(void(^)(BOOL isSuccess, NSError *error))block;

/**计算系统磁盘空间 剩余可用空间*/
+ (void)cy_countSystemSizeBlock:(void(^)(CGFloat totalSize,CGFloat freeSize))block;

@end


static NSMutableDictionary *_archiverDic;
UIKIT_EXTERN NSString * const CYPlayerCurrentAudioInfoModelAudioUrl;
UIKIT_EXTERN NSString * const CYPlayerCurrentAudioInfoModelCurrentTime;
UIKIT_EXTERN NSString * const CYPlayerCurrentAudioInfoModelTotalTime;
UIKIT_EXTERN NSString * const CYPlayerCurrentAudioInfoModelProgress;
/**
 DFPlayer归档管理器
 */
@interface CYPlayerArchiverManager : NSObject

/**已经归档的数据*/
+ (NSMutableDictionary *)cy_hasArchivedFileDictionary;

/**归档*/
+ (BOOL)cy_archiveValue:(id)value forKey:(NSString *)key;

/**如果已经归档则删除该路径归档*/
+ (void)deleteKeyValueIfHaveArchivedWithUrl:(NSURL *)url;


#pragma mark - infoModel归档
/**解档infoModel*/
+ (NSDictionary *)cy_unarchiveInfoModelDictionary;

/**归档infoModel*/
+ (BOOL)cy_archiveInfoModelWithAudioUrl:(NSURL *)audioUrl
                            currentTime:(CGFloat)currentTime
                              totalTime:(CGFloat)totalTime
                               progress:(CGFloat)progress;

@end


NS_ASSUME_NONNULL_END
