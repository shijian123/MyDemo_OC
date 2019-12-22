//
//  CYPlayAudioController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/7/19.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYPlayAudioController.h"
#import <AVFoundation/AVFoundation.h>
#import "CYPlayerResourceLoader.h"
#import "CYPlayerFileManager.h"
#import "CYPlayerTool.h"

/**类型KEY*/
NSString * const CYPlayerModeKey                = @"CYPlayerMode";
/**Asset KEY*/
NSString * const CYPlayableKey                  = @"playable";

NSString * const CYLoadedTimeRangesKey          = @"loadedTimeRanges";
NSString * const CYPlaybackBufferEmptyKey       = @"playbackBufferEmpty";
NSString * const CYPlaybackLikelyToKeepUpKey    = @"playbackLikelyToKeepUp";


@interface CYPlayAudioController ()<CYPlayerResourceLoaderDelegate>
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *playBtn2;
@property (nonatomic, strong) UIButton *playBtn3;

@property (nonatomic, strong) AVAudioPlayer *soloPlayer;
/**播放进度监测*/
@property (nonatomic, strong) id timeObserver;
/**其他应用是否正在播放*/
@property (nonatomic, assign) BOOL isOthetPlaying;
/**是否进入后台*/
@property (nonatomic, assign) BOOL isBackground;
/**是否正在播放*/
@property (nonatomic) BOOL isPlaying;
/**播放进度是否被拖拽了*/
@property (nonatomic, assign) BOOL isDraged;
/**当前音频是否缓存*/
@property (nonatomic, assign) BOOL isCached;
/**资源下载器*/
@property (nonatomic, strong) CYPlayerResourceLoader *resourceLoader;
/**组队列-网络*/
@property (nonatomic, strong) dispatch_group_t netGroupQueue;
/**组队列-数据*/
@property (nonatomic, strong) dispatch_group_t dataGroupQueue;
/**HIGH全局并发队列*/
@property (nonatomic, strong) dispatch_queue_t HighGlobalQueue;
/**DEFAULT全局并发队列*/
@property (nonatomic, strong) dispatch_queue_t defaultGlobalQueue;
/**player*/
@property (nonatomic, strong) AVPlayer *player;
/**playerItem*/
@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) NSURL *myAudioUrl;

@end

@implementation CYPlayAudioController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // http://aod.tx.xmcdn.com/group62/M02/1C/32/wKgMcVz3l2SgRr-UAAZcQiRx1Bc998.m4a
    // http://audio2.xmcdn.com/group59/M08/C5/5A/wKgLely1xr6AYCvAAA7MzLXkqg4157.m4a
    // http://aod.tx.xmcdn.com/group60/M09/C5/39/wKgLb1y1x32gIpSNABqml7r_rzk267.m4a
    // http://aod.tx.xmcdn.com/group58/M03/C5/1C/wKgLgly1x_fDhxmdAC8xDixImnw587.m4a
    [self.view addSubview:self.playBtn];
    [self.view addSubview:self.playBtn2];
    [self.view addSubview:self.playBtn3];

    
}

#pragma mark - 监测网络 监听播放结束 耳机插拔 播放器被打断
- (void)addPlayerObserver{
    self.defaultGlobalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.HighGlobalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    self.netGroupQueue = dispatch_group_create();
    self.dataGroupQueue = dispatch_group_create();
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_group_enter(self.netGroupQueue);
    });
    dispatch_group_async(self.netGroupQueue, self.defaultGlobalQueue, ^{
        [[CYPlayerTool shareInstance] startMonitoringNetworkStatus:^{
            static dispatch_once_t onceToken1;
            dispatch_once(&onceToken1, ^{
                dispatch_group_leave(self.netGroupQueue);
            });
        }];
    });
    
    //监测耳机
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CY_playerAudioRouteChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    //监听播放器被打断（别的软件播放音乐，来电话）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CY_playerAudioBeInterrupted:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    //监测其他app是否占据AudioSession
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CY_playerSecondaryAudioHint:) name:AVAudioSessionSilenceSecondaryAudioHintNotification object:nil];
}

- (void)CY_playerAudioRouteChange:(NSNotification *)notification {
    NSInteger routeChangeReason = [notification.userInfo[AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable://耳机插入
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable://耳机拔出，停止播放操作
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            break;
        default:
            break;
    }
}

- (void)CY_playerAudioBeInterrupted:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    if ([dic[AVAudioSessionInterruptionTypeKey] integerValue] == 1) {//打断开始
        NSLog(@"-- CYPlayer： 音频被打断开始，并记录了播放信息");
        
    }else {//打断结束
        NSLog(@"-- CYPlayer： 音频被打断结束");
    }
}

- (void)CY_playerSecondaryAudioHint:(NSNotification *)notification{
    NSInteger type = [notification.userInfo[AVAudioSessionSilenceSecondaryAudioHintTypeKey] integerValue];
    if (type == 1) {//开始被其他音频占据
        NSLog(@"-- CYPlayer： 其他音频占据开始");
    }else{//占据结束
        NSLog(@"-- CYPlayer： 其他音频占据结束");
    }
}



#pragma mark - DFPLayer -资源准备 IMPORTANT
- (void)audioPrePlayToLoadPreviousAudio{

    [self audioPrePlayToLoadAudio:self.myAudioUrl];
    
}

/**加载音频*/
- (void)audioPrePlayToLoadAudio:(NSURL *)audioUrl{
    //音频地址安全性判断
    if(![audioUrl isKindOfClass:[NSURL class]]){
        NSLog(@"-- CYPlayer:音频地址错误，支持NSURL类型");
        return;
    }
    //播放本地音频
    if ([CYPlayerTool isLocalWithUrl:audioUrl]) {
        NSLog(@"-- CYPlayer： 播放本地音频");
        [self loadPlayerWithItemUrl:audioUrl];
    }else {//播放网络音频
        NSString *cacheFilePath = [CYPlayerFileManager cy_isExistAudioFileWithURL:audioUrl];
        NSLog(@"-- CYPlayer： 是否有缓存：%@",cacheFilePath?@"有":@"无");
        [self loadPlayerItemWithUrl:audioUrl cacheFilePath:cacheFilePath];
    }
}

- (void)loadPlayerItemWithUrl:(NSURL *)currentAudioUrl
                cacheFilePath:(NSString *)cacheFilePath{
    dispatch_group_notify(self.netGroupQueue, self.defaultGlobalQueue, ^{
        //如果监听WWAN，本地无缓存，网络状态是WWAN，三种情况同时存在时发起代理8
        if (!cacheFilePath &&
            [CYPlayerTool shareInstance].networkStatus == CYPlayerNetworkStatusReachableViaWWAN){
//            [self cy_playerStatusWithStatusCode:CYPlayerStatus_NetworkViaWWAN];
            UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"" message:@"继续播放将产生流量费用" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *leftAct = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self loadNetAudioWithUrl:currentAudioUrl
                            cacheFilePath:cacheFilePath];
            }];
            UIAlertAction *rightAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertCon addAction:leftAct];
            [alertCon addAction:rightAct];
            [self presentViewController:alertCon animated:YES completion:nil];
            
        }else{
            //加载音频
            if ([CYPlayerTool shareInstance].networkStatus == CYPlayerNetworkStatusUnknown ||
                [CYPlayerTool shareInstance].networkStatus == CYPlayerNetworkStatusNotReachable)
            {//无网络
                if (cacheFilePath){//无网络 有缓存，播放缓存
                    [self loadPlayerWithItemUrl:[NSURL fileURLWithPath:cacheFilePath]];
                }else{//无网络 无缓存，提示联网
                    NSLog(@"暂无网络，请稍后再试");
                }
            }
            else{//有网络
                if (cacheFilePath) {//有缓存且不监听改变时间，直接播放缓存
                    [self loadPlayerWithItemUrl:[NSURL fileURLWithPath:cacheFilePath]];
                }else{//无缓存 或 需要兼听
                    [self loadNetAudioWithUrl:currentAudioUrl
                                cacheFilePath:cacheFilePath];
                }
            }
        }
    });
}

- (void)loadNetAudioWithUrl:(NSURL *)currentAudioUrl cacheFilePath:(NSString *)cacheFilePath{
    if (self.resourceLoader) {
        [self.resourceLoader stopLoading];
    }
    self.resourceLoader = [[CYPlayerResourceLoader alloc] init];
    self.resourceLoader.delegate = self;
    NSURL *customUrl = [CYPlayerTool customUrlWithUrl:currentAudioUrl];

    if (!customUrl) {
        [self cy_playerStatusWithStatusCode:CYPlayerStatus_UnavailableURL];
        return;
    }
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:customUrl options:nil];
    [asset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_get_main_queue()];
    [asset loadValuesAsynchronouslyForKeys:@[CYPlayableKey] completionHandler:^{
        dispatch_async( dispatch_get_main_queue(),^{
            if (!asset.playable) {
                [self.resourceLoader stopLoading];
                [asset cancelLoading];
            }
        });
    }];
    
    CY_WeakSelf;
    self.resourceLoader.checkStatusBlock = ^(NSInteger statusCode){
        if (statusCode == 200) {
            [weakSelf loadPlayerWithAsset:asset];
        }else if (statusCode == 304) {
            NSLog(@"-- CYPlayer： 服务器音频资源未更新，播放本地");
            [weakSelf loadPlayerWithItemUrl:[NSURL fileURLWithPath:cacheFilePath]];
        }else if(statusCode == 206){
            
        }else{
            if (weakSelf.player) {
                weakSelf.player = nil;
            }
            [weakSelf.player.currentItem cancelPendingSeeks];
            [weakSelf.player.currentItem.asset cancelLoading];
            [weakSelf cy_playerStatusWithStatusCode:CYPlayerStatus_UnavailableData];
        }
    };
}

/**加载 AVPlayerItem*/
- (void)loadPlayerWithAsset:(AVURLAsset *)asset{
    NSURL *myURL = [CYPlayerTool originalUrlWithUrl:asset.URL];
    AVURLAsset *asset1 = [AVURLAsset URLAssetWithURL:myURL options:nil];

    self.playerItem = [AVPlayerItem playerItemWithAsset:asset1];
    [self loadPlayer];
}
- (void)loadPlayerWithItemUrl:(NSURL *)url{

    self.playerItem = [[AVPlayerItem alloc] initWithURL:url];
    [self loadPlayer];
}

/**加载 AVPlayer*/
- (void)loadPlayer{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];

    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    
    //监听播放进度
    [self addPlayProgressTimeObserver];
    //设置锁屏和控制中心音频信息
    [self addInformationOfLockScreen];
    
    [self cy_audioPlay];
}

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackFinished:(NSNotification *)notification{
    NSLog(@"音频播放完成.");
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

/**播放*/
-(void)cy_audioPlay{
    if (!self.isPlaying) {
        self.isPlaying = YES;
    }
    [self.player play];
}

/**播放进度*/
- (void)addPlayProgressTimeObserver{
    CY_WeakSelf;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1, 1) queue:nil usingBlock:^(CMTime time){
        AVPlayerItem *currentItem = weakSelf.playerItem;
        NSArray *loadedRanges = currentItem.seekableTimeRanges;
        if (loadedRanges.count > 0 && currentItem.duration.timescale != 0){
            CGFloat currentT = (CGFloat)CMTimeGetSeconds(time);
            if (!weakSelf.isDraged) {
                weakSelf.currentTime = currentT;
            }
            if (weakSelf.totalTime != 0) {//避免出现inf
                weakSelf.progress = CMTimeGetSeconds([currentItem currentTime]) / weakSelf.totalTime;
            }
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(df_player:progress:currentTime:totalTime:)]) {
//                [weakSelf.delegate cy_player:weakSelf
//                                    progress:weakSelf.progress
//                                 currentTime:currentT
//                                   totalTime:weakSelf.totalTime];
//            }
            if (weakSelf.isBackground) {
                [weakSelf updatePlayingCenterInfo];
            }
        }
    }];
}

/**锁屏、后台模式信息*/
- (void)addInformationOfLockScreen{
    
    MPNowPlayingInfoCenter *playInfoCenter = [MPNowPlayingInfoCenter defaultCenter];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[MPMediaItemPropertyTitle] = @"audioName";
    dic[MPMediaItemPropertyAlbumTitle] = @"audioAlbum";
    dic[MPMediaItemPropertyArtist] = @"audioSinger";
    playInfoCenter.nowPlayingInfo = dic;
    
}

// 成为响应者方法
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)updatePlayingCenterInfo{
    NSDictionary *info=[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:info];
    dic[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithDouble:CMTimeGetSeconds(self.playerItem.currentTime)];
    dic[MPMediaItemPropertyPlaybackDuration] = [NSNumber numberWithDouble:CMTimeGetSeconds(self.playerItem.duration)];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
}

#pragma mark - CYPlayerResourceLoaderDelegate
/**下载出错*/
- (void)loader:(DFPlayerResourceLoader *)loader requestError:(NSInteger)errorCode{
    if (errorCode == NSURLErrorTimedOut) {
        [self cy_playerStatusWithStatusCode:CYPlayerStatus_RequestTimeOut];
    }else if ([CYPlayerTool shareInstance].networkStatus == CYPlayerNetworkStatusNotReachable) {
        [self cy_playerStatusWithStatusCode:CYPlayerStatus_NetworkUnavailable];
    }
}
/**是否完成缓存*/
- (void)loader:(DFPlayerResourceLoader *)loader isCached:(BOOL)isCached{
    NSUInteger status = isCached?CYPlayerStatus_CacheSuccess:CYPlayerStatus_CacheFailure;
    [self cy_playerStatusWithStatusCode:status];
}

- (void)playAudioMethod:(UIButton *)sender {

    // http://aod.tx.xmcdn.com/group62/M02/1C/32/wKgMcVz3l2SgRr-UAAZcQiRx1Bc998.m4a
    // http://audio2.xmcdn.com/group59/M08/C5/5A/wKgLely1xr6AYCvAAA7MzLXkqg4157.m4a
    // http://aod.tx.xmcdn.com/group60/M09/C5/39/wKgLb1y1x32gIpSNABqml7r_rzk267.m4a
    // http://aod.tx.xmcdn.com/group58/M03/C5/1C/wKgLgly1x_fDhxmdAC8xDixImnw587.m4a
    NSURL *audioUrl;
    if(sender.tag == 100) {
        audioUrl = [NSURL URLWithString:@"http://aod.tx.xmcdn.com/group62/M02/1C/32/wKgMcVz3l2SgRr-UAAZcQiRx1Bc998.m4a"];
    }else if(sender.tag == 101) {
        audioUrl = [NSURL URLWithString:@"http://aod.tx.xmcdn.com/group60/M09/C5/39/wKgLb1y1x32gIpSNABqml7r_rzk267.m4a"];
    }else if (sender.tag == 102) {
        audioUrl = [NSURL URLWithString:@"http://aod.tx.xmcdn.com/group58/M03/C5/1C/wKgLgly1x_fDhxmdAC8xDixImnw587.m4a"];
    }
    
    self.myAudioUrl = audioUrl;
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    self.isOthetPlaying = [AVAudioSession sharedInstance].otherAudioPlaying;
    [self addPlayerObserver];
    [self audioPrePlayToLoadAudio:audioUrl];

}

- (UIButton *)playBtn {
    if (_playBtn == nil) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _playBtn.frame = CGRectMake(100, 100, 100, 40);
        _playBtn.tag = 100;
        [_playBtn setTitle:@"play" forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playAudioMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)playBtn2 {
    if (_playBtn2 == nil) {
        _playBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
        _playBtn2.frame = CGRectMake(100, 200, 100, 40);
        _playBtn2.tag = 101;
        [_playBtn2 setTitle:@"play2" forState:UIControlStateNormal];
        [_playBtn2 addTarget:self action:@selector(playAudioMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn2;
}

- (UIButton *)playBtn3 {
    if (_playBtn3 == nil) {
        _playBtn3 = [UIButton buttonWithType:UIButtonTypeSystem];
        _playBtn3.frame = CGRectMake(100, 300, 100, 40);
        _playBtn3.tag = 102;
        [_playBtn3 setTitle:@"play3" forState:UIControlStateNormal];
        [_playBtn3 addTarget:self action:@selector(playAudioMethod:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn3;
}

- (void)setCurrentTime:(NSInteger)currentTime{
    _currentTime = currentTime;
}
- (void)setTotalTime:(CGFloat)totalTime{
    _totalTime = totalTime;
}
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
}

#pragma mark - 统一状态代理
- (void)cy_playerStatusWithStatusCode:(NSUInteger)statusCode{
    NSLog(@"-- CYPlayer： 状态码:%lu",(unsigned long)statusCode);

    if (statusCode == 0) {
        [MBProgressHUD showMessage:@"没有网络连接"];
    }else if(statusCode == 1){
        //提示后播放
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"" message:@"继续播放将产生流量费用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *leftAct = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *rightAct = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertCon addAction:leftAct];
        [alertCon addAction:rightAct];
        [self presentViewController:alertCon animated:YES completion:nil];
        
    }else if(statusCode == 2){
        [MBProgressHUD showMessage:@"请求超时"];
    }else if(statusCode == 8){
//        [self tableViewReloadData];return;
    }
    
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
