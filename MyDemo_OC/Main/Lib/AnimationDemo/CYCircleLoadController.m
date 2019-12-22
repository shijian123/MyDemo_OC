//
//  CYCircleLoadController.m
//  MyDome_OC
//
//  Created by zcy on 2019/6/4.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYCircleLoadController.h"

@interface CYCircleLoadController ()
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) UILabel *tapLab;
@end

@implementation CYCircleLoadController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tapLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.tapLab.text = @"请点击屏幕";
    [self.view addSubview:self.tapLab];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startLoadingAnim:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)startLoadingAnim: (UITapGestureRecognizer *)tap {
    self.tapLab.hidden = YES;
    // 取得所点击的点的坐标
    CGPoint location = [tap locationInView:self.view];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:location radius:50 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    _circleLayer.path = circlePath.CGPath;
    [self.view.layer addSublayer:_circleLayer];
    [self startLoading];
}

- (void)startLoading {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.duration = 2.0;
    [self.circleLayer addAnimation:animation forKey:@"end"];
}

#pragma mark - setters && getters

- (CAShapeLayer *)circleLayer {
    if (_circleLayer == nil) {
        _circleLayer = [[CAShapeLayer alloc] init];
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
        _circleLayer.strokeColor = [UIColor greenColor].CGColor;
        _circleLayer.lineWidth = 3.0;
        _circleLayer.strokeStart = 0.0;
        _circleLayer.strokeEnd = 1.0;
    }
    return _circleLayer;
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
