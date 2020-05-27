//
//  CYLifeCycleController.m
//  MyDemo_OC
//
//  Created by zcy on 2020/5/27.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYLifeCycleController.h"
#import "CYLifeCycleView.h"

@interface CYLifeCycleController ()
@property (nonatomic, strong) CYLifeCycleView *myView;
@property (weak, nonatomic) IBOutlet CYLifeCycleView *view1;

@end

@implementation CYLifeCycleController

- (instancetype)init{
    if (self = [super init]) {
        NSLog(@"Controller_init");
    }
    return self;
}

/**
 如果Controller的加载方式为init时，若重写loadView，导致不加载xib，除非加载方式变为initWithframe
 */
/// 此函数自定义UIViewController的view用的
//- (void)loadView {
//    [super loadView];
//    NSLog(@"Controller_loadView");
//}

- (void)loadViewIfNeeded {
    [super loadViewIfNeeded];
    NSLog(@"Controller_loadViewIfNeeded");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Controller_viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"Controller_viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"Controller_viewWillDisappear");
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"Controller_viewWillLayoutSubviews");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"Controller_viewDidLayoutSubviews");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Controller_viewDidLoad");

    self.myView = [[CYLifeCycleView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    self.myView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.myView];
    self.view1.frame = CGRectMake(100, 100, 100, 100);
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
