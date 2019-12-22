//
//  CYHttpTool.m
//  MyBooks
//
//  Created by zcy on 2018/7/25.
//  Copyright © 2018年 CY. All rights reserved.
//

#import "CYHttpTool.h"
#import "AFNetworking.h"

@implementation CYHttpTool
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [self checkNetWorkStatusChange];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.securityPolicy = [self securityPolicy];
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        //加载中
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CYLog(@"task.response.URL : ## %@ ",task.response.URL);
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            CYLog(@"task.response.URL : ## %@, ERROR ## : %@",task.response.URL,error);
            failure(error);
        }
    }];
    
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 10.0f;
    manager.securityPolicy = [self securityPolicy];
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        //加载中
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CYLog(@"task.response.URL : ## %@ ",task.response.URL);
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            CYLog(@"task.response.URL : ## %@, ERROR ## : %@",task.response.URL,error);
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params image:(UIImage *)image success:(void(^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [self securityPolicy];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:imgData name:@"files" fileName:@"iosImage.jpg" mimeType:@"image/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //加载中
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CYLog(@"task.response.URL : ## %@ ",task.response.URL);
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            CYLog(@"task.response.URL : ## %@, ERROR ## : %@",task.response.URL,error);
            failure(error);
        }
    }];

}

+ (void)post:(NSString *)url params:(NSDictionary *)params imageList:(NSArray *)imageArr imageNameList:(NSArray *)nameArr success:(void(^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [self securityPolicy];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int count = 0; count < imageArr.count; count ++) {
            UIImage *image = imageArr[count];
            NSData *imgData = UIImageJPEGRepresentation(image, 0.8);
            CYLog(@"imgData : %zd",[imgData length]);
            NSString *fileName = nameArr[count];
            [formData appendPartWithFileData:imgData name:@"files" fileName:fileName mimeType:@"image/jpg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //加载中
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CYLog(@"task.response.URL : ## %@ ",task.response.URL);
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            CYLog(@"task.response.URL : ## %@, ERROR ## : %@",task.response.URL,error);
            failure(error);
        }
    }];

}

+ (void)postSingleFile:(NSString *)url params:(NSDictionary *)params and:(UIImage*)icon success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.securityPolicy = [self securityPolicy];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *eachImgData = UIImagePNGRepresentation(icon);
        [formData appendPartWithFileData:eachImgData name:[NSString stringWithFormat:@"files"] fileName:[NSString stringWithFormat:@"image111.png"] mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //加载中
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CYLog(@"task.response.URL : ## %@ ",task.response.URL);
        if (responseObject) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            CYLog(@"task.response.URL : ## %@, ERROR ## : %@",task.response.URL,error);
            failure(error);
        }
    }];

}

+ (NSDictionary *)jsonStringWithObject:(id)jsonData imei:(NSString *)imei{
    NSMutableDictionary *base = [NSMutableDictionary dictionary];
//    base[@"imei"] = [FCUUID uuidForDevice];
//    base[@"params"] = [self jsonStringWithObject:jsonData];
//    base[@"token"] = [FCUUID uuidForDevice];
    return base;
}

/**
 将统一的参数添加到param中
 
 @param objectData 自定义param的字段
 @return 装配后的param
 */
+ (NSDictionary *)assembleDicWithObject:(NSDictionary *)objectData{
    NSMutableDictionary *base = [NSMutableDictionary dictionaryWithDictionary:objectData];
    
//    base[@"adult"] = @"0";
    base[@"appid"] = @"com.lovebizhi.ipad";
    base[@"appver"] = @"5.1";
    base[@"appvercode"] = @"64";
    base[@"channel"] = @"ipicture";
//    base[@"first"] = @"1";
    base[@"lan"] = @"zh-Hans-CN";
    base[@"sys_model"] = @"iPhone";
    base[@"sys_name"] = @"iOS";
    base[@"sys_ver"] = @"11.3";
    
    return base;
}

/**
 *  字典或者数组转json语句
 *
 *  @param objectData 需要转换的数据
 *
 *  @return 转换之后的json语句
 */
+ (NSString *)jsonStringWithObject:(NSDictionary *)objectData{
    NSData *queryData = [NSJSONSerialization dataWithJSONObject:objectData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *queryJson = [[NSString alloc] initWithData:queryData encoding:NSUTF8StringEncoding];
    return queryJson;
}

+ (void)checkNetWorkStatusChange{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                CYLog(@"网络状态未知");
                [MBProgressHUD showText:@"当前网络状态未知"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                CYLog(@"WIFI状态");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                CYLog(@"自带网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [MBProgressHUD showText:@"当前网络不可用"];
                break;
            default:
                break;
        }
    }];
    //开启监控
    [mgr startMonitoring];
}

+ (AFSecurityPolicy *)securityPolicy{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = NO;
    securityPolicy.validatesDomainName = YES;
    return securityPolicy;
}
@end
