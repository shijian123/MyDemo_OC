//
//  CYWebView.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/6.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYWebView.h"
#import <objc/runtime.h>

@implementation CYWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//重写load方法，使用runtime替换掉WKWebView的loadRequest方法；
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(loadRequest:);
        SEL swizzledSelector = @selector(post_loadRequest:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (WKNavigation *)post_loadRequest:(NSURLRequest *)request
{
    if ([[request.HTTPMethod uppercaseString] isEqualToString:@"POST"]){
        NSString *url = request.URL.absoluteString;
        NSString *params = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        //        [params stringByRemovingPercentEncoding];
        //        NSLog(@"*********params*************:%@", params);
        //        NSData *jsonData = [params dataUsingEncoding:NSUTF8StringEncoding];
        //
        //        if ([params containsString:@"="]) {
        ////            params = [params stringByReplacingOccurrencesOfString:@"%7B" withString:@"\"{\""];
        ////            params = [params stringByReplacingOccurrencesOfString:@"%7D" withString:@"\"}\""];
        //            params = [params stringByReplacingOccurrencesOfString:@"=" withString:@"\":\""];
        //            params = [params stringByReplacingOccurrencesOfString:@"&" withString:@"\",\""];
        //            params = [NSString stringWithFormat:@"{\"%@\"}", params];
        //        }else{
        //            params = @"{}";
        //        }
        
        //        NSDictionary *params = [NSJSONSerialization JSONObjectWithData:request.HTTPBody options:NSJSONReadingMutableContainers error:nil];
        //
        NSLog(@"*********dic*************:%@", params);
        /*
         {
         keySerial = 1;
         platformNo = 9100004001;
         reqData = "{\"amount\":1,\"expired\":\"20190905173646\",\"platformUserNo\":\"LMP2018060620866909\",\"redirectUrl\":\"https://wap.daokoudai.com//lmService/withdrawReturn\",\"requestNo\":\"W2019090555492274\",\"withdrawForm\":\"IMMEDIATE\",\"withdrawType\":\"NORMAL_URGENT\",\"timestamp\":\"20190905170646\"}";
         serviceName = WITHDRAW;
         sign = "An620m1kow/1xKZayq+MCm0y+G6C7CT5A7KF8KpaeQkWcYnRC49Cbgo2RHCCGzmpuuAdFRk8d3qsxj7fGxXrdQe/2WTWiM3pMjOck+D0h/MSPxbeBrfj6Ln2uxKmZKPe+Px4WzBkc8jPMUIffb8uZA8JichfpW2HzQB1r0I1Vl7UFSqRN0aKD353OPm7zWCslvZX8zsV6T2pP+7ojrmwJoLsQujS4WLdCu0TJnrSpBp/QcyE0IVbEtv1ZdLeXOARK6Fno4dW1LO6sMr946uybTZVM9Qdjf6/wiUz/7UBn/xuglpEHZqqg7rj9fwzF8Hpi8cuXSpNPLwpzhs3ulN/Yw==";
         userDevice = MOBILE;
         }
         */
        
        //        NSString *postJavaScript = [NSString stringWithFormat:@"\
        //                                    var url = %@;\
        //                                    var params = %@;\
        //                                    var form = document.createElement('form');\
        //                                    form.setAttribute('method', 'post');\
        //                                    form.setAttribute('action', url);\
        //                                    for(var key in params) {\
        //                                    if(params.hasOwnProperty(key)) {\
        //                                    var hiddenField = document.createElement('input');\
        //                                    hiddenField.setAttribute('type', 'hidden');\
        //                                    hiddenField.setAttribute('name', key);\
        //                                    hiddenField.setAttribute('value', params[key]);\
        //                                    form.appendChild(hiddenField);\
        //                                    }\
        //                                    }\
        //                                    document.body.appendChild(form);\
        //                                    form.submit();", url, params];
        //"var iOSApp = {\"getUserInfo\":function(){return \(jsonText!)}}"
        NSString *postJavaScript = [NSString stringWithFormat:@"document.write(isNaN(123)+ \"<br />\")"];
        __weak typeof(self) wself = self;
        [self evaluateJavaScript:postJavaScript completionHandler:^(id object, NSError * _Nullable error) {
            if (error && [wself.navigationDelegate respondsToSelector:@selector(webView:didFailProvisionalNavigation:withError:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [wself.navigationDelegate webView:wself didFailProvisionalNavigation:nil withError:error];
                });
            }
        }];
    }
    return nil;
}


@end
