//
//  CYNavigationController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/17.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYNavigationController.h"

@interface CYNavigationController ()

@end

@implementation CYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationBar.titleTextAttributes =@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - custom method

+ (void)initialize{
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    [barItem setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [barItem setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0 ) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [leftBtn setImage:[UIImage imageNamed:@"nav_return"] forState:UIControlStateNormal];
        leftBtn.contentMode = UIViewContentModeLeft;
        [leftBtn addTarget:self action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
        viewController.navigationItem.leftBarButtonItem = leftItem;
    }
    
    [super pushViewController:viewController animated:animated];
}

@end
