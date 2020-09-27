//
//  CYBaseController.m
//  MyDome_OC
//
//  Created by zcy on 2019/6/4.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYBaseController.h"

@interface CYBaseController ()

@end

@implementation CYBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
}

/**
 客服电话
 */
- (void)callServerPhone {
    if (DeviceValue >= 10.3) {//10.3以后系统自动有弹窗
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006227618"] options:@{} completionHandler:nil];
    }else{
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"呼叫400-622-7618" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *leftAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *rightAct = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006227618"] options:@{} completionHandler:nil];
            
        }];
        [alertCon addAction:leftAct];
        [alertCon addAction:rightAct];
        [self presentViewController:alertCon animated:YES completion:nil];
    }
}

@end
