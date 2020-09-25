//
//  CYPicInPicController.m
//  MyDemo_OC
//
//  Created by zcy on 2020/9/22.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYPicInPicController.h"
#import <AVKit/AVKit.h>
#import "CYPlayerControlView.h"

@interface CYPicInPicController ()<AVPictureInPictureControllerDelegate>
@property (nonatomic, strong) AVPictureInPictureController *pipContr;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIViewController *playerVC;
@property (nonatomic, strong) CYPlayerControlView *playerControlView;
@end

@implementation CYPicInPicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUI];
    // iOS14的系统才有

    
    /**
     不过现在退出控制器后画中画也会跟着关闭，这里参考哔哩哔哩App的画中画，人家是开启画中画的同时退出当前播放器，另外开启新的画中画，会先关闭当前的画中画再打开新的画中画，所以目前的画中画功能还不够完善。
     */
//    if (_pipContr.isPictureInPictureActive) {
//        [_pipContr stopPictureInPicture];
//    }else {
//        [_pipContr startPictureInPicture];
//    }
    
}

// 如果不是点击画中画的按钮，而是是通过其他途径打开当前画中画的控制器，这时也应该关闭画中画，可以在viewWillAppear里面进行判断并关闭：
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 如果打开的控制器是当前画中画的控制器
    if (self.playerVC == self) {
        [_pipContr stopPictureInPicture];
    }
}

- (void)setUI {
    
    if (AVPictureInPictureController.isPictureInPictureSupported) {// 是否支持画中画
        @try {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionOrientationBack error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
        } @catch (NSException *exception) {
            NSLog(@"AVAudioSession发生错误");
        } @finally {
            self.pipContr = [[AVPictureInPictureController alloc] initWithPlayerLayer:self.playerLayer];
            self.pipContr.delegate = self;
            if (self.pipContr.pictureInPicturePossible) {
                NSLog(@"pictureInPicturePossible");
            }
            
            if (self.pipContr.pictureInPictureActive) {
                NSLog(@"pictureInPictureActive");
            }
            if (self.pipContr.pictureInPictureSuspended) {
                NSLog(@"pictureInPictureSuspended");
            }
        }
    }
    
    _playerControlView = [[CYPlayerControlView alloc] initWithFrame:CGRectMake(0, 100, MainScreenWidth, 200)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"测试视频01" ofType:@"mp4"];
    [_playerControlView setupVideoURL:[NSURL fileURLWithPath:path] pipController:self.pipContr];
    [self.view addSubview:_playerControlView];
    
}

#pragma mark - delegate
#pragma mark - AVPictureInPictureControllerDelegate

- (void)pictureInPictureControllerWillStartPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    //在即将开启画中画时持有该控制器，接着退出控制器，这样控制器就能苟住
    self.playerVC = self;
}

- (void)pictureInPictureControllerDidStopPictureInPicture:(AVPictureInPictureController *)pictureInPictureController {
    //在确保已经关闭画中画后释放引用，销毁控制器（只要关闭画中画最后都会来到这里，所以个人认为在这里释放比较合适）
    self.playerVC = nil;
}

/// 这个代理方法，这是用来恢复播放界面的，只需要在代理方法里面执行一下回调的闭包即可开启恢复动画;不过由于前面的做法是开启画中画的同时退出控制器的，想要恢复播放界面还得重新打开控制器：
- (void)pictureInPictureController:(AVPictureInPictureController *)pictureInPictureController restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:(void (^)(BOOL))completionHandler {
    
    
    /**
     // 如果当前导航控制器的栈里并没有当前控制器，则重新打开
             if let navCtr = navCtr, navCtr.viewControllers.contains(self) != true {
                 playerVC_ = nil // 确定关闭，置空防止后续误判
                 navCtr.pushViewController(self, animated: true)
                 // 因为push有动画过程，延时一点再恢复，不然动画会恢复到错误位置
                 DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15) {
                     completionHandler(true)
                 }
                 return
             }
     */
    
    
    completionHandler(true);
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
