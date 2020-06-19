//
//  CYSnapshotPreviewController.m
//  MyDemo_OC
//
//  Created by zcy on 2020/6/16.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYSnapshotPreviewController.h"
#import <Photos/Photos.h>

@interface CYSnapshotPreviewController ()
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImage *image;

@end

@implementation CYSnapshotPreviewController

- (instancetype)initWithImage:(UIImage *)image {
    if (self= [super init]) {
        self.image = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"预览"
    
    self.imageView = [UIImageView new];
    self.imageView.image = self.image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.scrollView = [UIScrollView new];
    [self.scrollView addSubview:self.imageView];
    
    [self.view addSubview:self.scrollView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.scrollView.frame = self.view.bounds;
        
        CGFloat height = self.image.size.height;
        CGFloat width = self.image.size.width;
        self.scrollView.contentSize = CGSizeMake(width, height);
        self.imageView.frame = CGRectMake(0, 0, width, height);
    });
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存截图" style:UIBarButtonItemStylePlain target:self action:@selector(saveImage)];

}

- (void)saveImage {
    
    // 图片会被压缩
//    UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    // 图片会被压缩
//    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//        if (status == PHAuthorizationStatusAuthorized) {//权限判断
//            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                [PHAssetChangeRequest creationRequestForAssetFromImage:self.image];
//            } completionHandler:^(BOOL success, NSError * _Nullable error) {
//                NSString *barItemTitle = @"保存成功";
//                if (error != nil) {
//                    barItemTitle = @"保存失败";
//                }
//                NSLog(@"%@", barItemTitle);
//            }];
//        }
//    }];
    
    // 图片不会被压缩
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {//权限判断
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                NSData *imgData = UIImagePNGRepresentation(self.image);
                [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:imgData options:nil];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                NSString *barItemTitle = @"保存成功";
                if (error != nil) {
                    barItemTitle = @"保存失败";
                }
                NSLog(@"%@", barItemTitle);
            }];
        }
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
