//
//  CYPlayerFileManager.m
//  MyDemo_OC
//
//  Created by zcy on 2019/7/22.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYPlayerFileManager.h"
#import "CYPlayerTool.h"

static NSString *CYPlayer_fileId = @"cacheFileId";
static NSString *CYPlayer_fileName = @"CYPlayerCache";//所有缓存文件都放在了沙盒Cache文件夹下CYPlayerCache文件夹里
static NSString *CYPlayer_archiverName = @"CYPlayer.archiver";
static NSString *CYPlayer_modelArchiverName = @"CYPlayerInfoModel.archiver";

@implementation CYPlayerFileManager

+ (void)cy_playerCreateCachePathWithId:(NSString *)Id{
    NSString *uniqueId = @"public";
    if (Id) {
        if ([Id rangeOfString:@" "].location != NSNotFound) {
            Id = [Id stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        if (Id.length != 0) {
            uniqueId = Id;
        }else{
            NSLog(@"warning:The length of userId is zero,CYPlayer use unified cache file named user_public.");
        }
    }else{
        NSLog(@"-- CYPlayer： Using unified cache file named user_public.");
    }
    [[NSUserDefaults standardUserDefaults] setObject:uniqueId forKey:CYPlayer_fileId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**CYPlayerCache文件夹的地址*/
+ (NSString *)cy_playerCachePath{
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [cachePath stringByAppendingPathComponent:CYPlayer_fileName];
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

/**CYPlayerCache文件夹下的当前用户Id缓存文件夹地址*/
+ (NSString *)cy_playerUserCachePath{
    NSString *fileId = [[NSUserDefaults standardUserDefaults] objectForKey:CYPlayer_fileId];
    NSString *fileName = [NSString stringWithFormat:@"user_%@",fileId];
    NSString *userPath = [[CYPlayerFileManager cy_playerCachePath] stringByAppendingPathComponent:fileName];
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:userPath]) {
        [manager createDirectoryAtPath:userPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return userPath;
}

/**临时文件路径*/
+ (NSString *)AudioFileTempPath{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"MusicTemp.mp4"];
}

/**创建临时文件*/
+ (BOOL)cy_createTempFile {
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString * path = [CYPlayerFileManager AudioFileTempPath];
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
    return [manager createFileAtPath:path contents:nil attributes:nil];
}

/**往临时文件写入数据*/
+ (void)cy_writeDataToAudioFileTempPathWithData:(NSData *)data{
    NSFileHandle * handle = [NSFileHandle fileHandleForWritingAtPath:[CYPlayerFileManager AudioFileTempPath]];
    [handle seekToEndOfFile];
    [handle writeData:data];
}

/**读取临时文件数据*/
+ (NSData *)cy_readTempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length{
    NSFileHandle * handle = [NSFileHandle fileHandleForReadingAtPath:[CYPlayerFileManager AudioFileTempPath]];
    [handle seekToFileOffset:offset];
    return [handle readDataOfLength:length];
}

/**保存临时文件到缓存文件夹*/
+ (void)cy_moveAudioFileFromTempPathToCachePath:(NSURL *)url blcok:(void(^)(BOOL isSuccess,NSError *error))block{
    
    NSString *path = [CYPlayerFileManager audioFileOfCachePathWithUrl:url];
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        NSError *error;
        NSNumber *numberId = [NSNumber numberWithInt:[CYPlayer_fileId intValue]];
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:@{NSFileOwnerAccountID:numberId} error:&error];
        if (error) {
            NSLog(@"-- CYPlayer:error-:%@",[error localizedDescription]);
        }
    }
    NSString *audioName = [url.path lastPathComponent];
    NSString *cacheFilePath = [NSString stringWithFormat:@"%@/%@", path, audioName];
    NSError *error;
    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:[CYPlayerFileManager AudioFileTempPath] toPath:cacheFilePath error:&error];
    
    if (!success) {//安全性处理 如果没有保存成功，删除归档文件中的对应键值对
        [CYPlayerArchiverManager deleteKeyValueIfHaveArchivedWithUrl:url];
    }
    
    if (block) {
        block(success,error);
    }
}

/**缓存文件是否存在*/
+ (NSString *)cy_isExistAudioFileWithURL:(NSURL *)url{
    NSString *path = [CYPlayerFileManager  audioFileOfCachePathWithUrl:url];
    NSString *audioName = [url.path lastPathComponent];
    NSString *cacheFilePath = [NSString stringWithFormat:@"%@/%@", path, audioName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath]) {
        return cacheFilePath;
    }
    return nil;
}

/**清除url对应的本地缓存*/
+ (void)cy_playerClearCacheWithUrl:(NSURL *)url block:(void(^)(BOOL isSuccess, NSError *error))block{
    NSString *cacheFilePath = [self cy_isExistAudioFileWithURL:url];
    if (cacheFilePath) {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *error;
        BOOL isSuccess = [manager removeItemAtPath:cacheFilePath error:&error];
        if (block) {
            block(isSuccess,error);
        }
    }
}

+ (NSString *)audioFileOfCachePathWithUrl:(NSURL *)url{
    NSString *filePath = [CYPlayerFileManager cy_playerUserCachePath];
    
    NSString *backStr = [[url.absoluteString componentsSeparatedByString:@"//"].lastObject stringByDeletingLastPathComponent];
    NSString *path = [filePath stringByAppendingPathComponent:backStr];
    return path;
}

/**计算缓存大小*/
+ (CGFloat)cy_countCacheSizeForCurrentUser:(BOOL)isCurrentUser{
    if (isCurrentUser) {
        return [CYPlayerFileManager sizeWithPath:[CYPlayerFileManager cy_playerUserCachePath]];
    }else{
        return [CYPlayerFileManager sizeWithPath:[CYPlayerFileManager cy_playerCachePath]];
    }
}
+ (CGFloat)sizeWithPath:(NSString *)cachePath{
    NSArray *fileArr = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    CGFloat size = 0;
    for (NSString *path in fileArr) {
        NSString *filePath = [cachePath stringByAppendingPathComponent:path];
        size += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    CGFloat sizeM = size/1000.0/1000.0;
    return sizeM;
}

/**清除缓存*/
+ (void)cy_clearCacheForCurrentUser:(BOOL)isClearCurrentUser block:(void(^)(BOOL isSuccess, NSError *error))block{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    if (isClearCurrentUser) {
        BOOL isSuccess = [manager removeItemAtPath:[CYPlayerFileManager cy_playerUserCachePath] error:&error];
        if (block) {
            block(isSuccess,error);
        }
    }else{
        BOOL isSuccess = [manager removeItemAtPath:[CYPlayerFileManager cy_playerCachePath] error:&error];
        if (block) {
            block(isSuccess,error);
        }
    }
}

/**计算系统磁盘剩余可用空间*/
+ (void)cy_countSystemSizeBlock:(void(^)(CGFloat totalSize,CGFloat freeSize))block{
    NSError *error = nil;
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    if (error){
        NSLog(@"-- CYPlayer: %@",[error localizedDescription]);
        if (block) {
            block(0,0);
        }
    }else{
        NSNumber *free = [dictionary objectForKey:NSFileSystemFreeSize];
        float freesize = [free unsignedLongLongValue]/1000.0;
        
        NSNumber *total = [dictionary objectForKey:NSFileSystemSize];
        float totalsize = [total unsignedLongLongValue]/1000.0;
        if (block) {
            block(totalsize,freesize);
        }
    }
}

@end

NSString *const CYPlayerCurrentAudioInfoModelAudioUrl       = @"CYPlayerCurrentAudioInfoModelAudioUrl";
NSString *const CYPlayerCurrentAudioInfoModelCurrentTime    = @"CYPlayerCurrentAudioInfoModelCurrentTime";
NSString *const CYPlayerCurrentAudioInfoModelTotalTime      = @"CYPlayerCurrentAudioInfoModelTotalTime";
NSString *const CYPlayerCurrentAudioInfoModelProgress       = @"CYPlayerCurrentAudioInfoModelProgress";

@implementation CYPlayerArchiverManager
#pragma mark - key归档
/**归档文件路径*/
+ (NSString *)archiverFilePath{
    NSString *cachePath = [CYPlayerFileManager cy_playerUserCachePath];
    NSString *path = [cachePath stringByAppendingPathComponent:CYPlayer_archiverName];
    return path;
}

/**如果已经归档则删除该路径归档*/
+ (void)deleteKeyValueIfHaveArchivedWithUrl:(NSURL *)url{
    NSMutableDictionary *dic = [CYPlayerArchiverManager cy_hasArchivedFileDictionary];
    __block BOOL isHave = NO;
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:url.absoluteString]) {
            [dic removeObjectForKey:key];
            isHave = YES;
            *stop = YES;
        }
    }];
    if (isHave) {
        NSString *path = [CYPlayerArchiverManager archiverFilePath];
        [NSKeyedArchiver archiveRootObject:dic toFile:path];
    }
}

/**已经归档的数据*/
+ (NSMutableDictionary *)cy_hasArchivedFileDictionary{
    NSString *path = [CYPlayerArchiverManager archiverFilePath];
    _archiverDic = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    if (!_archiverDic){
        _archiverDic = [NSMutableDictionary dictionary];
    }
    return _archiverDic;
}

/**归档*/
+ (BOOL)cy_archiveValue:(id)value forKey:(NSString *)key{
    NSMutableDictionary *dic = [CYPlayerArchiverManager cy_hasArchivedFileDictionary];
    [dic setValue:value forKey:key];
    NSString *path = [CYPlayerArchiverManager archiverFilePath];
    BOOL isSuccess = [NSKeyedArchiver archiveRootObject:dic toFile:path];
    return isSuccess;
}

#pragma mark - model归档
/**model归档文件路径*/
+ (NSString *)modelArchiverFilePath{
    NSString *cachePath = [CYPlayerFileManager cy_playerUserCachePath];
    NSString *path = [cachePath stringByAppendingPathComponent:CYPlayer_modelArchiverName];
    return path;
}
/**解档infoModel*/
+ (NSDictionary *)cy_unarchiveInfoModelDictionary{
    NSString *path = [CYPlayerArchiverManager modelArchiverFilePath];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}
/**归档infoModel*/
+ (BOOL)cy_archiveInfoModelWithAudioUrl:(NSURL *)audioUrl
                            currentTime:(CGFloat)currentTime
                              totalTime:(CGFloat)totalTime
                               progress:(CGFloat)progress{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (audioUrl && [audioUrl isKindOfClass:[NSURL class]]) {
        if ([CYPlayerTool isLocalWithUrl:audioUrl]) {
            [dic setObject:[[audioUrl absoluteString] lastPathComponent]
                    forKey:CYPlayerCurrentAudioInfoModelAudioUrl];
        }else{
            [dic setObject:[audioUrl absoluteString]
                    forKey:CYPlayerCurrentAudioInfoModelAudioUrl];
        }
    }
    if (currentTime) {
        [dic setObject:[NSNumber numberWithFloat:currentTime]
                forKey:CYPlayerCurrentAudioInfoModelCurrentTime];
    }
    if (totalTime) {
        [dic setObject:[NSNumber numberWithFloat:totalTime]
                forKey:CYPlayerCurrentAudioInfoModelTotalTime];
    }
    if (progress) {
        [dic setObject:[NSNumber numberWithFloat:progress]
                forKey:CYPlayerCurrentAudioInfoModelProgress];
    }
    NSString *path = [CYPlayerArchiverManager modelArchiverFilePath];
    return [NSKeyedArchiver archiveRootObject:dic toFile:path];
}

@end