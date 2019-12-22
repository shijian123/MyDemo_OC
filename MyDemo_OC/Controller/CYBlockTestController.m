//
//  CYBlockTestController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/9.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYBlockTestController.h"

@interface CYBlockTestController ()

@end

@implementation CYBlockTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self.view.backgroundColor = [UIColor purpleColor];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self.view.backgroundColor = [UIColor purpleColor];
    }];
    
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
