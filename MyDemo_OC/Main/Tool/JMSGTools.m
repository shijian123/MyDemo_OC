//
//  JMSGTools.m
//  JMessageDemo
//
//  Created by deng on 16/8/23.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGTools.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation JMSGTools

static JMSGTools *instance = nil;
+ (instancetype)shareTools{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[JMSGTools alloc] init];
    });
    return instance;
}
- (id)init{
    self = [super init];
    if (self) {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePickerController.allowsEditing = YES;
    }
    return self;
}
+ (void)showTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok",nil];
    [alert show];
}
+ (void)showTitle:(NSString *)title message:(NSString *)msg image:(UIImage *)image {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok",nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)];
    imageView.image = image;
    
    [alert setValue:imageView forKey:@"accessoryView"];
    
    [alert show];
}

+ (void)showMessage:(NSString *)info {
    if (info) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:info delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
+ (void)showResponseResultWithInfo:(NSString *)info error:(NSError *)error {
    if (!error) {
        info = [info stringByAppendingString:@" success"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:info delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        info = [NSString stringWithFormat:@"%@, error: %@", info, error];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:info delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

+ (NSData *)getDataWithFileName:(NSString *)fileName {
    NSString *filePath = [[[NSBundle mainBundle] resourcePath]
                          stringByAppendingPathComponent:fileName];
    NSURL *localUrl = [NSURL fileURLWithPath:filePath];
    return [NSData dataWithContentsOfURL:localUrl];
}

+ (NSData *)getTestImageDate {
    UIImage *image = [UIImage imageNamed:@"jiguang.jpg"];
    return UIImageJPEGRepresentation(image, 0.5);
}

+ (NSData *)getTestVoiceDate {
    NSData *data = [JMSGTools getDataWithFileName:@"voice.mp3"];
    return data;
}

+ (NSData *)getTestFileDate {
    NSData *data = [JMSGTools getDataWithFileName:@"zipFile.zip"];
    return data;
}
//
- (void)getImageWithComplete:(GetImageHandler)handler {
    imageBlock = handler;
    pickerType = imageType;
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",@"取消", nil];
    sheet.tag = 2001;
    //显示消息框
    [sheet showInView:rootVC.view];
}

//拍摄视频
- (void)shootVideoWithComplete:(ShootVideoHandler)handler {
    videoBlock = handler;
    pickerType = videoType;
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium; //录像质量
        imagePickerController.videoMaximumDuration = 10.0f; //录像最长时间
        imagePickerController.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
        //跳转到拍摄页面
        
        [rootVC presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        [MBProgressHUD showMessage:@"当前设备不支持录像功能" toView:rootVC.view];
    }
}
- (void)prepareVideoMessage:(NSURL *)videoURL{
    
    [self convertVideoQuailtyWithInputURL:videoURL completeHandler:^(NSURL *outputVideoURL) {
        if (outputVideoURL) {
            NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
            ///thumb
            UIImage *thumb = [self firstFrameWithVideoURL:videoURL size:CGSizeMake(150, 100)];
            NSData *thumbData = UIImagePNGRepresentation(thumb);;
            if (!thumb) {
                thumbData = UIImageJPEGRepresentation([UIImage imageNamed:@"dog.jpg"], 1);
            }
            
            //duration
            AVURLAsset *avUrl = [AVURLAsset assetWithURL:videoURL];
            CMTime time = [avUrl duration];
            int seconds = ceil(time.value/time.timescale);
            
            if (videoBlock) {
                videoBlock(videoData,thumbData,@(seconds),@"mp4",nil);
            }
        }
    }];
}

#pragma mark -消息框代理实现-
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 2001) {
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        NSUInteger sourceType = 0;
        
        imagePickerController.allowsEditing = NO;
        imagePickerController.videoQuality=UIImagePickerControllerQualityTypeLow;
        imagePickerController.sourceType = sourceType; //图片来源
        
        // 判断系统是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if (buttonIndex == 0) {
                //拍照
                sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePickerController.sourceType = sourceType;
                [rootVC presentViewController:imagePickerController animated:YES completion:nil];
            }else if (buttonIndex == 1) {
                //相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerController.sourceType = sourceType;
                [rootVC presentViewController:imagePickerController animated:YES completion:nil];
            }else if (buttonIndex == 2){
            }
        }else {
            if (buttonIndex == 1 || buttonIndex == 0) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickerController.sourceType = sourceType;
                [rootVC presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
    }
}

#pragma mark - UIImagePickerController Delegate
//相机,相册Finish的代理
- (void)imagePickerController:(UIImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if (pickerType == imageType) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (image) {
            if (imageBlock) {
                imageBlock(UIImagePNGRepresentation(image),@"png",nil);
            }
        }
    }else{
        if ([mediaType isEqualToString:@"public.movie"]) {
            NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            [self prepareVideoMessage:videoURL];
            // 也可以转 MP4 再发送[self convertVideoQuailtyWithInputURL::]
        }else{
            
        }
    }
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVC dismissViewControllerAnimated:YES completion:nil];
}
//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePickerController {
    if (pickerType == imageType){
        if (imageBlock) {
            imageBlock(nil,nil,nil);
        }
    }else{
        if (videoBlock) {
            videoBlock(nil,nil,0,nil,nil);
        }
    }
    [imagePickerController dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark ---- 获取图片第一帧
- (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size
{
    // 获取视频第一帧
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:url options:opts];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(size.width, size.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    {
        return [UIImage imageWithCGImage:img];
    }
    return nil;
}

#pragma mark ---- video 转 MP4
- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                         completeHandler:(void (^)(NSURL *outputVideoURL))handler {
    NSURL *outputURL ; //一般.mp4
    //用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    //这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
    outputURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;
    
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 
                 //这个是保存到手机相册
                 //UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);
                 if (handler) {
                     handler(outputURL);
                 }
                 //[self alertUploadVideo:outputURL];
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
     }];
}
@end
