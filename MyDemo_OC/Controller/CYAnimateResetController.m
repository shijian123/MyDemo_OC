//
//  CYAnimateResetController.m
//  MyDemo_OC
//
//  Created by zcy on 2020/5/27.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYAnimateResetController.h"
#import "CYLifeCycleView.h"

@interface CYAnimateResetController (){
    int pageNum;
}
@property (nonatomic, strong) UIButton *resetBtn;

@end

@implementation CYAnimateResetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.resetBtn];

}

- (void)resetAnimMethod {
    for (int a=0; a<10; a++) {
        UIView *view = [self makeShadowView];
        [self.view addSubview:view];
        [UIView animateWithDuration:0.6*(a+1) animations:^{
            view.frame = CGRectMake(view.x, 100, view.width, view.height);
        } completion:^(BOOL finished) {
            if (finished) {
                view.hidden = YES;
                [view removeFromSuperview];
                NSLog(@"finish_%d", a);
                if (self.view.subviews.count < 3) {
                    [self resetAnimMethod];
                }
            }
        }];
    }
}

- (UIView *)makeShadowView {
    UIView *view = [[CYLifeCycleView alloc] init];
    view.frame = CGRectMake(20+arc4random()%8 * 40, 300+arc4random()%8 * 40, 40, 40);
    view.backgroundColor = [self randomColor];
    return view;
}

/// 随机色值
- (UIColor *)randomColor {
    CGFloat hue = arc4random() % 100 / 100.0; //色调：0.0 ~ 1.0
    CGFloat saturation = (arc4random() % 50 / 100) + 0.5; //饱和度：0.5 ~ 1.0
    CGFloat brightness = (arc4random() % 50 / 100) + 0.5; //亮度：0.5 ~ 1.0
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (UIButton *)resetBtn {
    if (_resetBtn == nil) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _resetBtn.frame = CGRectMake((MainScreenWidth-60)/2.0, MainScreenHeight - 100, 60, 30);
        [_resetBtn setTitle:@"RESET" forState:UIControlStateNormal];
        [_resetBtn addTarget:self action:@selector(resetAnimMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
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
