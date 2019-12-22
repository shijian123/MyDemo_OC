//
//  CYCarouselController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/7/9.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYCarouselController.h"
#import <objc/runtime.h>

@interface CYCarouselController ()

@end

@implementation CYCarouselController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"CYCarouselController";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(makeMyName) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:btn];
    
}

- (NSString *)title {
    return objc_getAssociatedObject(self, @"nameKey");
}

- (void)setTitle:(NSString *)title {
    objc_setAssociatedObject(self, @"nameKey", @"myTitle", OBJC_ASSOCIATION_COPY_NONATOMIC);

}

- (void)makeMyName {
    NSLog(@"title:%@", self.title);
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
