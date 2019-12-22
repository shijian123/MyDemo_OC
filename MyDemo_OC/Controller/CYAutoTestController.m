//
//  CYAutoTestController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/7/15.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYAutoTestController.h"
#import "UILabel+CY1.h"
#import "UILabel+CY2.h"

@interface CYAutoTestController ()
@property (nonatomic, strong) UILabel *testLabel;

@end

@implementation CYAutoTestController

+ (void)load {
    extern NSString * const kAutoTestUITurnOnKey;
    extern NSString * const kAutoTestUILongPressKey;
    
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:kAutoTestUITurnOnKey];
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:kAutoTestUILongPressKey];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.testLabel = [[UILabel alloc] init];
    self.testLabel.textColor = [UIColor blackColor];
    self.testLabel.text = @"测试";
    [self.testLabel sizeToFit];
    self.testLabel.center = (CGPoint){self.view.bounds.size.width/2, self.view.bounds.size.height/2};
    [self.view addSubview:self.testLabel];
    self.testLabel.userInteractionEnabled = YES;
    
    [self.testLabel labelColor];
    
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
