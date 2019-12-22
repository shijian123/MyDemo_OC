//
//  CYPropertyRuntimeController2.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/26.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYPropertyRuntimeController2.h"

@interface CYPropertyRuntimeController2 ()

@end

@implementation CYPropertyRuntimeController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    imgV.frame = CGRectMake(100, 100, 100, 100);
    imgV.userInteractionEnabled = YES;
    imgV.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:imgV];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn setTitle:@"按钮" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtnMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
//    imgV.frame = CGRectMake(100, 100, 100, 100);
////    imgV.userInteractionEnabled = YES;
//    imgV.backgroundColor = [UIColor purpleColor];
//    [self.view addSubview:imgV];
    
    UIView *view = [[UIView alloc] initWithFrame:imgV.frame];
    view.backgroundColor = [UIColor redColor];
    view.userInteractionEnabled = NO;
    [self.view addSubview:view];
    
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
//    btn1.frame = CGRectMake(100, 100, 100, 40);
//    [btn1 setTitle:@"按钮" forState:UIControlStateNormal];
//    [btn1 addTarget:self action:@selector(clickBtn1Method) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn1];

    
}

- (void)clickBtnMethod {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)clickBtn1Method {
    NSLog(@"clickBtn1Method");
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
