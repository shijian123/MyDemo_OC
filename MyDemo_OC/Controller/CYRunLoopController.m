//
//  CYRunLoopController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/7/15.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYRunLoopController.h"

@interface CYRunLoopController ()

@end

@implementation CYRunLoopController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 定义一个定时器，
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    // 将定时器添加到当前RunLoop的NSDefaultRunLoopMode下
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 100);
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    // 创建观察者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"RunLoop发生改变---%zd",activity);
    });
    
    // 添加观察者到当前RunLoop中
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    
    // 释放observer，最后添加完需要释放掉
    CFRelease(observer);
}


- (void)clickMethod {
    NSLog(@"***clickMethod***");
}

- (void)run{
    NSLog(@"***run***");
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
