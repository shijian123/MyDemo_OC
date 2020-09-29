//
//  CYPHPickerImgCell.m
//  MyDemo_OC
//
//  Created by zcy on 2020/9/28.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYPHPickerImgCell.h"

@implementation CYPHPickerImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteAction:(id)sender {
    if (self.deleteItemBlock) {
        self.deleteItemBlock(self);
    }
}

@end
