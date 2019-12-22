//
//  CYHttpTool.h
//  MyBooks
//
//  Created by zcy on 2018/7/25.
//  Copyright © 2018年 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYHttpTool : NSObject

/**
 *  get请求
 *
 *  @param url     请求的url地址
 *  @param params  传入的参数
 *  @param success 成功返回值
 *  @param failure 失败返回值
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params
    success:(void (^) (id json))success
    failure:(void (^) (NSError * error))failure;

/**
 *  post请求
 *
 *  @param url     请求的url地址
 *  @param params  传入的参数
 *  @param success 成功返回值
 *  @param failure 失败返回值
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params
     success:(void (^) (id json))success
     failure:(void (^)(NSError *error))failure;

/**
 *  上传图片
 *
 *  @param url     请求地址
 *  @param params  传入参数
 *  @param image   传入图片
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image success:(void(^)(id))success failure:(void (^)(NSError *))failure;

/**
 上传多张图片
 
 @param url 请求地址
 @param params 传入参数
 @param imageArr 多张图片的数组
 @param nameArr 多张图片对应的命名
 @param success 成功回调
 @param failure 失败回调
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params imageList:(NSArray *)imageArr imageNameList:(NSArray *)nameArr success:(void(^)(id))success failure:(void (^)(NSError *))failure;

/**
 *  数组或字典转json语句
 *
 *  @param jsonData 要进行转换的数组或字典
 *  @param imei     当前设备的唯一标识
 *  @return 返回的json语句
 */
+ (NSDictionary *)jsonStringWithObject:(id)jsonData imei:(NSString *)imei;

/**
 *  检查网络的变化
 */
+ (void)checkNetWorkStatusChange;

/**
 *  字典或者数组转json语句
 *
 *  @param objectData 需要转换的数据
 *
 *  @return 转换之后的json语句
 */
+ (NSString *)jsonStringWithObject:(NSDictionary *)objectData;

/**
 将统一的参数添加到param中

 @param objectData 自定义param的字段
 @return 装配后的param
 */
+ (NSDictionary *)assembleDicWithObject:(NSDictionary *)objectData;

@end
