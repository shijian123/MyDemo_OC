//
//  CYDynamicLaunchController.m
//  MyDemo_OC
//
//  Created by zcy on 2020/9/27.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYDynamicLaunchController.h"
#import "CYLaunchImageHelper.h"

@interface CYDynamicLaunchController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    BOOL autoExit;
}
@end

@implementation CYDynamicLaunchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    autoExit = YES;
    UISwitch *autoExit = [[UISwitch alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    autoExit.on = YES;
    [autoExit addTarget:self action:@selector(switchAutoExit:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:autoExit];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(autoExit.frame)+5, autoExit.y, 140, autoExit.height)];
    lab.text = @"开启自动退出";
    [self.view addSubview:lab];

    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(100, 160, 100, 40);
    [btn1 setTitle:@"选择启动图" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(selectPhotoMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(100, 220, 100, 40);
    [btn2 setTitle:@"重置启动页" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(resetSystemLaunchMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

#pragma mark - custom method

- (void)switchAutoExit:(UISwitch *)sender {
    autoExit = sender.on;
}

- (void)exitIfNeeded {
    if (autoExit) {
        self.view.userInteractionEnabled = NO;
        [MBProgressHUD showText:@"自动退出"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            exit(0);
        });
    }else {
        [MBProgressHUD showText:@"重启app，查看启动页"];

    }
}

- (void)selectPhotoMethod {
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickVC.delegate = self;
    [self presentViewController:pickVC animated:YES completion:nil];
}

- (void)resetSystemLaunchMethod {
    UIImage *portraitImage = [CYLaunchImageHelper snapshotStoryboardForPortrait:@"LaunchScreen"];
    UIImage *landscapeImage = [CYLaunchImageHelper snapshotStoryboardForLandscape:@"LaunchScreen"];
    [CYLaunchImageHelper changePortraitLaunchImage:portraitImage landscapeLaunchImage:landscapeImage];
    [self exitIfNeeded];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *selectImg = info[UIImagePickerControllerOriginalImage];
    [CYLaunchImageHelper changePortraitLaunchImage:selectImg landscapeLaunchImage:selectImg];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self exitIfNeeded];
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
