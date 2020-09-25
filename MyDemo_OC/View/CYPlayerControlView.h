//
//  CYPlayerControlView.h
//  MyDemo_OC
//
//  Created by zcy on 2020/9/22.
//  Copyright © 2020 CY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYPlayerControlView : UIView

- (void)setupVideoURL:(NSURL *)url pipController:(AVPictureInPictureController *)pipController;

@end

NS_ASSUME_NONNULL_END
