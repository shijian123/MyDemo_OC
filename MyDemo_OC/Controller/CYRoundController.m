//
//  CYRoundController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/8/7.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYRoundController.h"

@interface CYRoundController ()
@property (nonatomic, strong) UIView *roundView;

@end

@implementation CYRoundController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
    // 圆角大小
    CGFloat radius = 36;
    UIRectCorner corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.roundView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.roundView.bounds;
    maskLayer.path = path.CGPath;
//    [self.view.layer addSublayer:maskLayer];
    
    self.roundView.layer.mask = maskLayer;
    
}

- (UIView *)roundView {
    if (_roundView == nil) {
        _roundView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
        _roundView.backgroundColor = [UIColor purpleColor];
        [self.view addSubview:_roundView];

    }
    return _roundView;
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
