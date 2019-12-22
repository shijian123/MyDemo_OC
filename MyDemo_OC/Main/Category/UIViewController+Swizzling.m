//
//  UIViewController+Swizzling.m
//  RuntimeCodeDome
//
//  Created by zcy on 2019/5/14.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (Swizzling)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(cy_viewWillApper:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {        //用到method_getImplementation去获取class_getInstanceMethod里面的方法实现。然后再进行class_replaceMethod来实现Swizzling。
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
        
        
        SEL originalSelector1 = @selector(presentViewController:animated:completion:);
        SEL swizzledSelector1 = @selector(cy_presentViewController:animated:completion:);
        
        Method originalMethod1 = class_getInstanceMethod(class, originalSelector1);
        Method swizzledMethod1 = class_getInstanceMethod(class, swizzledSelector1);
        
        BOOL didAddMethod1 = class_addMethod(class, originalSelector1, method_getImplementation(swizzledMethod1), method_getTypeEncoding(swizzledMethod1));
        
        if (didAddMethod1) {
            class_replaceMethod(class, swizzledSelector1, method_getImplementation(originalMethod1), method_getTypeEncoding(originalMethod1));
        }else {
            method_exchangeImplementations(originalMethod1, swizzledMethod1);
        }
        
        
        
        
    });
    
}

#pragma mark - Method Swizzling

- (void)cy_viewWillApper:(BOOL)animated {
    [self cy_viewWillApper:animated];
//    NSLog(@"viewWillAppear: %@", self);

    // 全局替换self.title
//    NSLog(@"********self.title:%@", self.title);
//    self.title = @"SwizzlingMyTitle";
    
}

// 重写Title方法
//- (NSString *)title {
//    NSLog(@"title: %@", self);
//
//    return @"大师傅";
//}


- (NSString *)cyTitle {
    return objc_getAssociatedObject(self, @"CYPropertyKey");
}

- (void)setCyTitle:(NSString *)cyTitle {
    objc_setAssociatedObject(self, @"CYPropertyKey", cyTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


- (void)cy_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{

    if (![self isKindOfClass:[UIAlertController class]]) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;

    }
    [self cy_presentViewController:viewControllerToPresent animated:flag completion:completion];
}


@end
