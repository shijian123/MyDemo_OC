//
//  CYPlayerControlView.m
//  MyDemo_OC
//
//  Created by zcy on 2020/9/22.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYPlayerControlView.h"

#define BTN_H 44

@interface CYPlayerControlView ()<UIGestureRecognizerDelegate, AVPictureInPictureControllerDelegate>

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UIVisualEffectView *blurView;
@property (nonatomic, strong) UIButton *resumeBtn;
@property (nonatomic, strong) UIButton *pipBtn;
@property (nonatomic, strong) UIView *controlView;
@property (nonatomic) BOOL isShowControl;
@property (nonatomic) BOOL isPlayDone;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
/// 显示操作界面time
@property (nonatomic, strong) NSTimer *controlTimer;
@property (nonatomic, strong) AVPictureInPictureController *pipVC;

@end

@implementation CYPlayerControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _controlView = [[UIView alloc] initWithFrame:self.bounds];
        _controlView.backgroundColor = [UIColor clearColor];
        
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.height-3, self.width, 3)];
        _progressView.trackTintColor = [UIColor lightGrayColor];
        _progressView.progressTintColor = [UIColor whiteColor];
        _progressView.progress = 0;
        [_progressView setUserInteractionEnabled:false];
        _progressView.alpha = 1.0;
        
        _blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _blurView.layer.cornerRadius = 8;
        _blurView.layer.masksToBounds = YES;
        UIImage *playIcon = [[UIImage imageNamed:@"find_play_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *pauseIcon = [[UIImage imageNamed:@"find_suspend_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _resumeBtn = [self creatBtnNoramlImg:playIcon selectedImg:pauseIcon action:@selector(clickResumeMethod)];
        _resumeBtn.frame = CGRectMake(0, 0, BTN_H, BTN_H);
        _resumeBtn.tintColor = [UIColor clearColor];

        [_blurView.contentView addSubview:_resumeBtn];
        
        if (@available(iOS 13.0, *)) {
            if (AVPictureInPictureController.isPictureInPictureSupported) {
                UIImage *startImg = [AVPictureInPictureController pictureInPictureButtonStartImage];
                UIImage *stopImg = [AVPictureInPictureController pictureInPictureButtonStopImage];
                _pipBtn = [self creatBtnNoramlImg:startImg selectedImg:stopImg action:@selector(clickPipMethod)];
                _pipBtn.frame = CGRectMake(CGRectGetMaxX(_resumeBtn.frame), 0, BTN_H, BTN_H);
                _pipBtn.tintColor = [UIColor whiteColor];

                [_blurView.contentView addSubview:_pipBtn];
            }
        }
        
        if (_pipBtn) {
            _blurView.frame = CGRectMake(15, self.height-BTN_H-10, CGRectGetMaxX(_pipBtn.frame), BTN_H);
        }else {
            _blurView.frame = CGRectMake(15, self.height-BTN_H-10, CGRectGetMaxX(_resumeBtn.frame), BTN_H);
        }
        [_controlView addSubview:_blurView];
        [_controlView addSubview:_progressView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapContentMethod)];
        tap.delegate = self;
        [_controlView addGestureRecognizer:tap];
    }
    return self;
    
}

- (UIButton *)creatBtnNoramlImg:(UIImage *)noramlImg selectedImg:(UIImage *)selectedImg action:(nullable SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setImage:noramlImg forState:UIControlStateNormal];
    [btn setImage:noramlImg forState:UIControlStateNormal | UIControlStateHighlighted];
    [btn setImage:selectedImg forState:UIControlStateSelected];
    [btn setImage:selectedImg forState:UIControlStateSelected | UIControlStateHighlighted];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIImage *)creatImg:(UIImage *)img {
    UIGraphicsBeginImageContextWithOptions(img.size, false, 0);
    [[UIColor whiteColor] setFill];
    UIRectFill(CGRectMake(0, 0, img.size.width, img.size.height));
    [img drawInRect:CGRectZero blendMode:kCGBlendModeDestinationIn alpha:1.0];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

- (void)setupVideoURL:(NSURL *)url pipController:(AVPictureInPictureController *)pipController {
//    self.pipVC = pipController;

    self.playerItem = [AVPlayerItem playerItemWithAsset:[AVURLAsset assetWithURL:url]];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerLayer.frame = self.bounds;
    [self.layer addSublayer:self.playerLayer];
    [self.player play];
    self.resumeBtn.selected = YES;
    [self addSubview:self.controlView];
    
    if (AVPictureInPictureController.isPictureInPictureSupported) {// 是否支持画中画
        @try {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionOrientationBack error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
        } @catch (NSException *exception) {
            NSLog(@"AVAudioSession发生错误");
        } @finally {
            self.pipVC = [[AVPictureInPictureController alloc] initWithPlayerLayer:self.playerLayer];
            self.pipVC.delegate = self;
            if (self.pipVC.pictureInPicturePossible) {
                NSLog(@"pictureInPicturePossible");
            }
            
            if (self.pipVC.pictureInPictureActive) {
                NSLog(@"pictureInPictureActive");
            }
            if (self.pipVC.pictureInPictureSuspended) {
                NSLog(@"pictureInPictureSuspended");
            }
        }
    }
    
    
    CY_WeakSelf;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSArray *loadedRanges = weakSelf.playerItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && weakSelf.playerItem.duration.timescale != 0) {
            weakSelf.progressView.progress = CMTimeGetSeconds(time) / CMTimeGetSeconds(weakSelf.playerItem.duration);
        }else {
            weakSelf.progressView.progress = 0;
        }
    }];
    
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidEndNoti) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    if (pipController) {
        [pipController addObserver:self forKeyPath:@"isPictureInPicturePossible" options:NSKeyValueObservingOptionNew context:nil];
        [pipController addObserver:self forKeyPath:@"isPictureInPictureActive" options:NSKeyValueObservingOptionNew context:nil];
    }
    
}

- (void)addTimer {
    [self removeTimer];
    _controlTimer = [NSTimer timerWithTimeInterval:5.0 repeats:false block:^(NSTimer * _Nonnull timer) {
        self.isShowControl = NO;
    }];
    [[NSRunLoop mainRunLoop] addTimer:_controlTimer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    if (_controlTimer) {
        [_controlTimer invalidate];
        _controlTimer = nil;
    }
}

/// 点击播放、暂停
- (void)clickResumeMethod {
    [self removeTimer];
    if (_player) {
        [self.resumeBtn setSelected: !self.resumeBtn.isSelected];
        if (self.resumeBtn.selected) {
            if (_isPlayDone) {
                _isPlayDone = false;
                [_player seekToTime:kCMTimeZero];
            }
            [_player play];
            [self addTimer];
        }else {
            [_player pause];
        }
    }
}

/// 点击画中画
- (void)clickPipMethod {
    [self addTimer];
    if (_pipVC) {
        if (_pipVC.isPictureInPictureActive) {
            [self.pipBtn setSelected:NO];
            [_pipVC stopPictureInPicture];
        }else {
            [self.pipBtn setSelected:YES];
            [_pipVC startPictureInPicture];
        }
    }
}

/// 点击播放内容
- (void)tapContentMethod {
    self.isShowControl = !self.isShowControl;
    if (self.isShowControl) {
        [self addTimer];
    }
}

#pragma mark - KVO  && Noti

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (_player) {
        BOOL isSelected = _player.rate > 0;
        if (self.resumeBtn.isSelected != isSelected) {
            [self clickResumeMethod];
        }
    }
    
    if (self.pipVC && self.pipBtn) {
        [self.pipBtn setEnabled:_pipVC.isPictureInPicturePossible];
        [self.pipBtn setSelected:_pipVC.isPictureInPictureActive];
    }
    
}

/// 监控播放结束Noti
- (void)playDidEndNoti {
    _isPlayDone = YES;
    [self.resumeBtn setSelected:NO];
    [self removeTimer];
    self.isShowControl = YES;
}

#pragma mark - delegate
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.isShowControl) {
        CGPoint location = [gestureRecognizer locationInView:self.controlView];
        if (CGRectContainsPoint(self.blurView.frame, location)) {
            return false;
        }
    }
    return true;
}

#pragma mark - setters && getters

- (void)setIsShowControl:(BOOL)isShowControl {
    _isShowControl = isShowControl;
    if (!isShowControl) {
        self.blurView.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.blurView.alpha = 0.1;
        } completion:^(BOOL finished) {
            self.blurView.hidden = YES;
        }];
    }else {
        self.blurView.alpha = 0.1;
        self.blurView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.blurView.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }
}


@end
