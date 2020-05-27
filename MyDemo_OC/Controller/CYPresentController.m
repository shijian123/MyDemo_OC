//
//  CYPresentController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/12/17.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYPresentController.h"

@interface CYPresentController ()

@end

@implementation CYPresentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    #if __has_include(<AFNetworking/AFNetworking.h>)
        NSLog(@"包含 ------- AFNetworking");
    #else
        NSLog(@"不包含  ------ AFNetworking");
    #endif
    
    
    UIViewController *vc1 = NSClassFromString(@"CYPresentController");
    UIViewController *vc2 = NSClassFromString(@"CYPresentController123");
    if (vc1) {
        NSLog(@"存在VC1");
    }
    if (vc2) {
        NSLog(@"存在VC2");
    }
    
    
#if __has_include("CYPresentController123.h")
    NSLog(@"存在");
#else
    NSLog(@"不存在");
#endif
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
