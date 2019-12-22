//
//  CYRippleAnimController.m
//  MyDome_OC
//
//  Created by zcy on 2019/6/4.
//  Copyright © 2019 CY. All rights reserved.
//

#define ripple_W 100

#import "CYRippleAnimController.h"

@interface CYRippleAnimController ()
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) UILabel *tapLab;

@end

@implementation CYRippleAnimController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tapLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.tapLab.text = @"请点击屏幕";
    [self.view addSubview:self.tapLab];
    
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(startLoadingAnim:)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)startLoadingAnim: (UITapGestureRecognizer *)tap {
    self.tapLab.hidden = YES;
    // 取得所点击的点的坐标
    CGPoint location = [tap locationInView:self.view];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.bounds = CGRectMake(0, 0, ripple_W, ripple_W);
    _shapeLayer.position = location;
    _shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ripple_W, ripple_W)].CGPath;
    _shapeLayer.fillColor = [UIColor redColor].CGColor;
    _shapeLayer.opacity = 0.0;
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.bounds = CGRectMake(0, 0, ripple_W, ripple_W);
    replicator.position = location;
    replicator.instanceDelay = 0.5;
    replicator.instanceCount = 8;
    [replicator addSublayer:_shapeLayer];
    
    [self.view.layer addSublayer:replicator];
    
    [self startAnimation];
}

- (void)startAnimation {
    CABasicAnimation *alphaAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnim.fromValue = [NSNumber numberWithFloat:0.6];
    alphaAnim.toValue = [NSNumber numberWithFloat:0.0];
    
    CABasicAnimation *scaleAnim =[CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D t = CATransform3DIdentity;
    CATransform3D t2 = CATransform3DScale(t, 0.0, 0.0, 0.0);
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:t2];
    CATransform3D t3 = CATransform3DScale(t, 1.0, 1.0, 0.0);
    scaleAnim.toValue = [NSValue valueWithCATransform3D:t3];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[alphaAnim, scaleAnim];
    groupAnimation.duration = 3.0;
    groupAnimation.autoreverses = NO;
    groupAnimation.repeatCount = 1;
    
    [_shapeLayer addAnimation:groupAnimation forKey:nil];
    
    [self.view.layer addSublayer:_shapeLayer];
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
