//
//  CYUploadPhotoCell.h
//  MyDemo_OC
//
//  Created by zcy on 2019/8/28.
//  Copyright © 2019 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYUploadPhotoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) id asset;

@end

NS_ASSUME_NONNULL_END
