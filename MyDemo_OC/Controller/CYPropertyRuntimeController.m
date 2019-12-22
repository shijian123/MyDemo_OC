//
//  CYPropertyRuntimeController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/26.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYPropertyRuntimeController.h"
#import "CYPropertyRuntimeController2.h"
#import "UIViewController+Swizzling.h"
#import <objc/runtime.h>

//static char *propertyKey = "CYPropertyKey";

@interface CYPropertyRuntimeController ()

@end

@implementation CYPropertyRuntimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(100, 200, 100, 40);
    [btn1 setTitle:@"clickAlert" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(clickAlertMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(100, 300, 100, 40);
    [btn2 setTitle:@"clickSheet" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(clickSheetMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    
}

//- (NSString *)title {
//    return objc_getAssociatedObject(self, @"CYPropertyKey");
//}
//
//- (void)setTitle:(NSString *)title {
//    objc_setAssociatedObject(self, @"CYPropertyKey", @"myTitle", OBJC_ASSOCIATION_COPY_NONATOMIC);
//}

- (void)clickBtnMethod {
//    NSLog(@"title:%@", self.title);
    self.cyTitle = @"大的罚款";
    NSLog(@"clickBtnMethod:%@", self.cyTitle);

    CYPropertyRuntimeController2 *vc = [[CYPropertyRuntimeController2 alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:vc animated:YES completion:nil];

}


- (void)clickAlertMethod {
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"标题" message:@"这是Sheet内容" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击sheet");
    }];
    [alertCon addAction:alertAct];
    [self presentViewController:alertCon animated:YES completion:nil];
}


- (void)clickSheetMethod {
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"标题" message:@"这是Alert内容" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击Alert");
    }];
    [alertCon addAction:alertAct];
    [self presentViewController:alertCon animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 
 属性的get set 方法替换
 
 OBJC_EXPORT void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
     OBJC_AVAILABLE(10.6, 3.1, 9.0, 1.0);//set方法

 OBJC_EXPORT id objc_getAssociatedObject(id object, const void *key)
     OBJC_AVAILABLE(10.6, 3.1, 9.0, 1.0);//get方法

 OBJC_EXPORT void objc_removeAssociatedObjects(id object)
     OBJC_AVAILABLE(10.6, 3.1, 9.0, 1.0);//移除
 
 
 //    OBJC_ASSOCIATION_ASSIGN = 0,           //assign
 //    OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, //retaion , nonatomic
 //    OBJC_ASSOCIATION_COPY_NONATOMIC = 3,   //copy ,  nonatomic
 //    OBJC_ASSOCIATION_RETAIN = 01401,       //retain
 //    OBJC_ASSOCIATION_COPY = 01403          //copy
 
 
 
------------------------------------------------------------------
 
 
 两个方法的执行替换
 
 SEL originalSelector = NSSelectorFromString(@"原来方法名");
 SEL swizzledSelector = NSSelectorFromString(@"需要替换的方法名");
 Method originalMethod = class_getInstanceMethod([self class], originalSelector);
 Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
 method_exchangeImplementations(originalMethod, swizzledMethod);

 
 
 */

@end
