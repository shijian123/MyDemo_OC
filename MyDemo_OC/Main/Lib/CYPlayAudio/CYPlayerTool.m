//
//  CYPlayerTool.m
//  MyDemo_OC
//
//  Created by zcy on 2019/7/22.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYPlayerTool.h"
#import "AFNetworkReachabilityManager.h"

@implementation CYPlayerTool
+ (NSURL *)customUrlWithUrl:(NSURL *)url{
    NSString *urlStr = [url absoluteString];
    if ([urlStr rangeOfString:@":"].location != NSNotFound) {
        NSString *scheme = [[urlStr componentsSeparatedByString:@":"] firstObject];
        if (scheme) {
            NSString *newScheme = [scheme stringByAppendingString:@"-streaming"];
            urlStr = [urlStr stringByReplacingOccurrencesOfString:scheme withString:newScheme];
            return [NSURL URLWithString:urlStr];
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

+ (NSURL *)originalUrlWithUrl:(NSURL *)url{
    NSURLComponents * components = [[NSURLComponents alloc] initWithURL:url
                                                resolvingAgainstBaseURL:NO];
    components.scheme = [components.scheme stringByReplacingOccurrencesOfString:@"-streaming" withString:@""];
    return [components URL];
}

+ (BOOL)isLocalWithUrl:(NSURL *)url{
    return [self isLocalWithUrlString:url.absoluteString];
}

+ (BOOL)isLocalWithUrlString:(NSString *)urlString{
    if ([urlString hasPrefix:@"http"]) {
        return NO;
    }
    return YES;
}

+ (CYPlayerTool *)shareInstance {
    static CYPlayerTool *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}
- (void)startMonitoringNetworkStatus:(void(^)(void))block{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"-- DFPlayer： 网络状态：%ld",(long)status);
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.networkStatus = CYPlayerNetworkStatusUnknown;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self.networkStatus = CYPlayerNetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.networkStatus = CYPlayerNetworkStatusReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.networkStatus = CYPlayerNetworkStatusReachableViaWiFi;
                break;
        }
        if (block) {block();}
    }];
    [mgr startMonitoring];
}


@end
