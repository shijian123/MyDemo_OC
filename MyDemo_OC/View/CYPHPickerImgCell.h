//
//  CYPHPickerImgCell.h
//  MyDemo_OC
//
//  Created by zcy on 2020/9/28.
//  Copyright © 2020 CY. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYPHPickerImgCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic) void(^deleteItemBlock)(CYPHPickerImgCell *cell);

@end

NS_ASSUME_NONNULL_END
