//
//  UIImage+CY.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UIImage+CY.h"

@implementation UIImage (CY)
/**
 根据颜色生成纯色图片
 
 @param color 颜色
 @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 拉伸图片，保护居中形状，拉伸两头
 
 @param size imageView的尺寸
 @return 返回拉伸后的图片
 */
- (UIImage *)stretchLeftAndRightWithContainerSize:(CGSize)size{
    CGSize imageSize = self.size;
    CGSize bgSize = size;
    
    //第一次拉伸右边，保护左边
    UIImage *image = [self stretchableImageWithLeftCapWidth:imageSize.width *0.8 topCapHeight:imageSize.height*0.5];
    //第一次拉伸的距离之后图片的总宽度
    CGFloat tempWidth = (bgSize.width)/2 + imageSize.width/2;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tempWidth, bgSize.height), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, tempWidth, bgSize.height)];
    //拿到拉伸过的图片
    UIImage *firstStrechImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //第二次拉伸左边，保护右边
    UIImage *secondStrechImage = [firstStrechImage stretchableImageWithLeftCapWidth:imageSize.width *0.2 topCapHeight:imageSize.height*0.5];
    return secondStrechImage;
}

/**
 按比例拉伸图片
 
 @param ratio 右边的拉伸比例
 @return 返回拉伸后的图片
 */
- (UIImage *)stretchLeftAndRightWithContainerSize:(CGSize)size rightRatio:(CGFloat)ratio{
    CGSize imageSize = self.size;
    CGSize bgSize = size;
    
    //第一次拉伸右边，保护左边
    UIImage *image = [self stretchableImageWithLeftCapWidth:imageSize.width *0.8 topCapHeight:imageSize.height*0.5];
    //第一次拉伸的距离之后图片的总宽度
    CGFloat tempWidth = (bgSize.width) *ratio + imageSize.width/2;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(tempWidth, bgSize.height), NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, tempWidth, bgSize.height)];
    //拿到拉伸过的图片
    UIImage *firstStrechImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //第二次拉伸左边，保护右边
    UIImage *secondStrechImage = [firstStrechImage stretchableImageWithLeftCapWidth:imageSize.width *0.2 topCapHeight:imageSize.height*0.5];
    return secondStrechImage;
}

/**
 *  压缩图片至目标尺寸
 *
 *  @param targetWidth 图片最终尺寸的宽
 *
 *  @return 返回按照源图片的宽、高比例压缩至目标宽、高的图片
 */
- (UIImage *)imageCompressTargetWidth:(CGFloat)targetWidth{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [self drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)screenShotImageWithTableView:(UITableView *)tableView size:(CGSize )size{
    UIImage* image = nil;
    
    [tableView reloadData];
    [tableView layoutIfNeeded];
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    CGPoint savedContentOffset = tableView.contentOffset;
    CGRect savedFrame = tableView.frame;
    tableView.contentOffset = CGPointZero;
    tableView.frame = CGRectMake(0, 0, tableView.contentSize.width, tableView.contentSize.height);
    [tableView reloadData];
    [tableView layoutIfNeeded];
    tableView.frame = CGRectMake(0, 0, tableView.contentSize.width, tableView.contentSize.height);
    [tableView.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    tableView.contentOffset = savedContentOffset;
    tableView.frame = savedFrame;
    UIGraphicsEndImageContext();
    if (image != nil) {
        return image;
    }else{
        return nil;
    }
}

+ (UIImage *)screenShotImageWithScrollView:(UIScrollView *)scrollView size:(CGSize )size{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect saveFrame = scrollView.frame;
    scrollView.contentOffset = CGPointZero;
    
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
    [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = saveFrame;
    UIGraphicsEndImageContext();
    if (image != nil) {
        return image;
    }else {
        return nil;
    }
}

+ (UIImage *)screenShotImageWithView:(UIView *)view size:(CGSize )size{
    UIGraphicsBeginImageContextWithOptions(size,NO, 0);
    [[UIColor clearColor] setFill];
    [[UIBezierPath bezierPathWithRect:view.bounds] fill];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
