//
//  JMSGTools.h
//  JMessageDemo
//
//  Created by deng on 16/8/23.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ShootVideoHandler)(NSData *videoData,NSData *thumbData,NSNumber *duration,NSString *format,NSError *error);
typedef void(^GetImageHandler)(NSData *imageData,NSString *format,NSError *error);

typedef NS_ENUM(NSInteger , PickerType){
    imageType = 1,
    videoType = 2,
};

@interface JMSGTools : NSObject<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    ShootVideoHandler videoBlock;
    GetImageHandler imageBlock;
    PickerType pickerType;
    
    UIImagePickerController *imagePickerController;
}

+ (instancetype)shareTools;


+ (void)showTitle:(NSString*)title message:(NSString *)msg image:(UIImage *)image ;
+ (void)showResponseResultWithInfo:(NSString *)info error:(NSError *)error;

+ (NSData *)getDataWithFileName:(NSString *)fileName;

+ (NSData *)getTestImageDate;

+ (NSData *)getTestVoiceDate;

+ (NSData *)getTestFileDate;
+ (void)showMessage:(NSString *)info;
+ (void)showTitle:(NSString *)title message:(NSString *)message;

//获取照片
- (void)getImageWithComplete:(GetImageHandler)handler;
//拍摄视频
- (void)shootVideoWithComplete:(ShootVideoHandler)handler;
@end
