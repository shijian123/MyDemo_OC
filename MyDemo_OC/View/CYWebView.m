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
        
        NSString *postJavaScript = [NSString stringWithFormat:@"%@my_post(\"%@\", %@)",CYPOST_JS,url,@"{\"token\":\"cac6af340960485aa334416c8a34ddbf\"}"];

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
