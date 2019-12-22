//
//  CYFireAnimController.m
//  MyDome_OC
//
//  Created by zcy on 2019/6/4.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYFireAnimController.h"

@interface CYFireAnimController ()
@property (nonatomic, strong) CAEmitterLayer * fireEmitter;//发射器对象
@property (nonatomic, strong) UILabel *tapLab;

@end

@implementation CYFireAnimController

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
    //设置发射器
    _fireEmitter = [CAEmitterLayer layer];
    _fireEmitter.emitterPosition = location;
    _fireEmitter.emitterMode = kCAEmitterLayerOutline;
    _fireEmitter.renderMode = kCAEmitterLayerOldestFirst;
    _fireEmitter.emitterSize = CGSizeMake(50, 50);
    _fireEmitter.emitterShape = kCAEmitterLayerCircle;
    _fireEmitter.zPosition = -1;
    
    //烟雾
//        CAEmitterCell *smoke = [CAEmitterCell emitterCell];
//        smoke.birthRate=10;
//        smoke.lifetime=2.0;
//        smoke.lifetimeRange=1.5;
//        smoke.color=[[UIColor colorWithRed:1 green:1 blue:1 alpha:0.05] CGColor];
//        smoke.contents=(id)[[UIImage imageNamed:@"fire"] CGImage];
//        [smoke setName:@"smoke"];
//
//        smoke.velocity=5;
//        smoke.velocityRange=10;
//        smoke.emissionLongitude=M_PI+M_PI_2;
//        smoke.emissionRange=M_PI_2;
//        smoke.alphaSpeed = -0.2;
//
//        _fireEmitter.emitterCells = @[smoke];
    
    
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    spark.name = @"spark";
    spark.birthRate = 20;
    spark.velocity = 55;
    spark.emissionRange = 2* M_PI;
    spark.yAcceleration = 25; //粒子y方向的加速度分量
    spark.lifetime = 3;
    spark.lifetimeRange = 2;

    spark.contents = (id) [[UIImage imageNamed:@"fire"] CGImage];
    spark.scaleSpeed =-0.2;
    spark.greenSpeed =-0.1;
    spark.redSpeed = 0.4;
    spark.blueSpeed =-0.1;
    spark.alphaSpeed =-0.25; // 例子透明度的改变速度
    spark.spin = 2* M_PI; // 子旋转角度
    spark.spinRange = 2* M_PI;

    self.fireEmitter.emitterCells = @[spark];
    
    [self.view.layer addSublayer:_fireEmitter];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.fireEmitter setValue:@0 forKeyPath:@"emitterCells.spark.birthRate"];
    });
    
    
//    [UIView animateWithDuration:1.0 animations:^{
//
//    } completion:^(BOOL finished) {
//    }]
//
//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"emitterCells.spark.birthRate"];
//    anim.fromValue = @(10.0);
//    anim.toValue   = @(0.0);
//    anim.duration  = 2.0;
//
//    [_fireEmitter addAnimation:anim forKey:nil];
    
}

- (void)startAnimation {

    //发射单元
    //火焰
//    CAEmitterCell *fire = [CAEmitterCell emitterCell];
//    fire.birthRate=50;
//    fire.lifetime=1.0;
//    fire.lifetimeRange=1.5;
//    fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
//    fire.contents=(id)[[UIImage imageNamed:@"fire"] CGImage];
//    [fire setName:@"fire"];
//
//    fire.velocity=10;
//    fire.velocityRange=20;
//    fire.emissionLongitude=M_PI+M_PI_2;
//    fire.emissionRange=M_PI_2;
//
//    fire.scaleSpeed=0.3;
//    fire.spin=0.2;
//    fire.alphaSpeed = -2;
    
    //烟雾
    CAEmitterCell *smoke = [CAEmitterCell emitterCell];
    smoke.birthRate=10;
    smoke.lifetime=2.0;
    smoke.lifetimeRange=1.5;
    smoke.color=[[UIColor colorWithRed:1 green:1 blue:1 alpha:0.05] CGColor];
    smoke.contents=(id)[[UIImage imageNamed:@"fire"] CGImage];
    [smoke setName:@"smoke"];
    
    smoke.velocity=5;
    smoke.velocityRange=10;
    smoke.emissionLongitude=M_PI+M_PI_2;
    smoke.emissionRange=M_PI_2;
    smoke.alphaSpeed = -0.2;

    _fireEmitter.emitterCells=[NSArray arrayWithObjects:smoke,nil];

//    _fireEmitter.emitterCells=[NSArray arrayWithObjects:smoke, fire,nil];
    [self.view.layer addSublayer:_fireEmitter];
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
