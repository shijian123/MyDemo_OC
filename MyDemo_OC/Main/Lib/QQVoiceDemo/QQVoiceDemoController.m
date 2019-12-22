//
//  QQVoiceDemoController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/6/26.
//  Copyright © 2019 CY. All rights reserved.
//

#import "QQVoiceDemoController.h"
#import "CYVoiceView.h"

@interface QQVoiceDemoController ()

@end

@implementation QQVoiceDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    CYVoiceView *view = [[CYVoiceView alloc] initWithFrame:CGRectMake(0, MainScreenHeight - 252, MainScreenWidth, 252)];
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
