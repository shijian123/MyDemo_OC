//
//  CYCameraMovieController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/17.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYCameraMovieController.h"
#import "XFCameraController.h"

@interface CYCameraMovieController ()

@end

@implementation CYCameraMovieController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
- (IBAction)startRecordMovieAction:(UIButton *)sender {
    sender.avoidRepeatEventInterval = 1.f;
    XFCameraController *cameraController = [XFCameraController defaultCameraController];
    __weak XFCameraController *weakCameraController = cameraController;
    cameraController.takePhotosCompletionBlock = ^(UIImage *image, NSError *error) {
        NSLog(@"takePhotosCompletionBlock");
        
        [weakCameraController dismissViewControllerAnimated:YES completion:nil];
    };
    cameraController.shootCompletionBlock = ^(NSURL *videoUrl, CGFloat videoTimeLength, UIImage *thumbnailImage, NSError *error) {
        NSLog(@"shootCompletionBlock");
        [weakCameraController dismissViewControllerAnimated:YES completion:nil];
//        [ws requestServerUploadMovieWithToken:self.uploadToken filePath:videoUrl];
    };
    cameraController.userName = @"测试人";
    cameraController.coreEnterpriseName = @"测试企业";
    [self presentViewController:cameraController animated:YES completion:nil];
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
