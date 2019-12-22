//
//  CYDrawHeartController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/7/9.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYDrawHeartController.h"
#import "DMHeartFlyView.h"
#import "TYWaterWaveView.h"

@interface CYDrawHeartController ()

@end

@implementation CYDrawHeartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    


    TYWaterWaveView *waterWaveView = [[TYWaterWaveView alloc] initWithFrame:CGRectMake(100, 200, 200, 200)];
    waterWaveView.percent = 0.6;
    waterWaveView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:waterWaveView];
    [waterWaveView startWave];
//    waterWaveView.layer.cornerRadius = 100;

    DMHeartFlyView *view = [[DMHeartFlyView alloc] initWithFrame:CGRectMake(100, 300, 200, 200)];
    view.backgroundColor = [UIColor clearColor];
    [view drawHeart];
    [self.view addSubview:view];
    
    
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
