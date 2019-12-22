//
//  CYLottieAnimationController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/19.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYLottieAnimationController.h"
#import "Lottie.h"

@interface CYLottieAnimationController ()
@property (nonatomic, strong) LOTAnimationView *mainAnim;

@end

@implementation CYLottieAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"music_bg"];
    [self.view addSubview:bgImageView];
    
    [self.mainAnim play];
}

#pragma mark - getter/setter

- (LOTAnimationView *)mainAnim {
    if (_mainAnim == nil) {
        _mainAnim = [LOTAnimationView animationNamed:@"breathe"];
        _mainAnim.frame = CGRectMake((MainScreenWidth-300)/2.0, 130, 300, 300);
        _mainAnim.loopAnimation = YES;
        [self.view addSubview:self.mainAnim];
//        00033d
    }
    return _mainAnim;
}

/*
 st：开始的 frame
 ip：开始的 frame，通常和 startFrame 值相同
 op：最后一帧的frame
 fr：动画变化率
 
 动画时间 = ((op-ip)-1 )/fr
 
 
 */




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
