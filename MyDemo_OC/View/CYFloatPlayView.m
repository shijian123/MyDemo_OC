//
//  CYFloatPlayView.m
//  MyDemo_OC
//
//  Created by zcy on 2020/7/7.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYFloatPlayView.h"
#import "CYFloatDeleteView.h"

@interface CYFloatPlayView (){
    BOOL isHalfScreen;
}

@property (nonatomic, strong) UIImageView *playImgView;
@property (nonatomic, strong) UIButton *playImgBtn;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) CGRect originFrame;
@property (nonatomic) CGFloat origian_Y;
@property (nonatomic) CGFloat scrolling_Y;
@property (nonatomic) CGPoint topPoint;


@end

@implementation CYFloatPlayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - init method

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.stayEdgeDistance = 5;
        self.stayAnimateTime = 0.3;
        self.layer.cornerRadius = frame.size.height/2.0;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor colorWithHex:0xaaaaaa].CGColor;
        self.layer.borderWidth = 1.0;
        
        [self addSubview:self.titleLab];
        [self addSubview:self.subTitleLab];
        [self addSubview:self.playImgView];
        
        self.titleLab.text = @"这是标题";
        self.subTitleLab.text = @"这是副标题";
        self.playImgView.image = [UIImage imageNamed:@"give_me_money.png"];
        self.originFrame = frame;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickFloatViewMethod)];
        [self addGestureRecognizer:tap];
        [self initStayLocation];
        
//        [self addAnimation];
        
        CY_WeakSelf;
        self.scrollBeganFloatViewBlock = ^(CGPoint currentPoint) {
            // 设置初始位置
            weakSelf.topPoint = currentPoint;
        };
        self.scrollingFloatViewBlock = ^(CGPoint currentPoint) {
            if (weakSelf.topPoint.y > currentPoint.y) {// 往上滑动，进行赋值
                weakSelf.topPoint = currentPoint;
            }else {// 往下滑动
                if ((currentPoint.y - weakSelf.topPoint.y)> 200) {// 偏移量大于200,显示删除框
                    [[CYFloatDeleteView sharedInstance] showDeleteView];
                }else { // 隐藏删除框
                    [[CYFloatDeleteView sharedInstance] hiddenDeleteView];
                }
            }
        };
        
        self.scrollEndedFloatViewBlock = ^(CGPoint currentPoint) {
//            [[RMFloatDeleteView sharedInstance] hiddenDeleteView];

            if (currentPoint.y >= MainScreenHeight-100-64) {// 删除
                NSLog(@"**********删除**********");
                [weakSelf removeFloatView];
//                [[RMPlayer shareInstance] rm_audioDelete];
            }
        };
        
    }
    return self;
}

/**
 设置浮动图片的初始位置
 */
- (void)initStayLocation{
    CGRect frame = self.frame;
    CGFloat stayWidth = frame.size.width;
    CGFloat initX = MainScreenWidth - self.stayEdgeDistance - stayWidth;
    CGFloat initY;
    if (IPHONE_X) {
        initY = (MainScreenHeight - 64 - 44 - 34) * (2.0/3.0) + 64;
    }else{
        initY = (MainScreenHeight - 64 - 44) * (2.0/3.0) + 64;
    }
    frame.origin.x = initX;
    frame.origin.y = initY;
    self.frame = frame;
    isHalfScreen = YES;
    
}

#pragma mark - touches method

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.scrollBeganFloatViewBlock) {
        CGPoint point = [self convertPoint:self.origin fromView:self];
        self.scrollBeganFloatViewBlock(point);
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    // 先让悬浮图片的alpha为1
    self.alpha = 1;
    //获取手指当前的点
    UITouch *touch = [touches anyObject];
    CGPoint curPoint = [touch locationInView:self];
    CGPoint prePoint = [touch previousLocationInView:self];
    
    //x方向移动的距离
    CGFloat deltaX = curPoint.x - prePoint.x;
    CGFloat deltaY = curPoint.y - prePoint.y;
    CGRect frame = self.frame;
    frame.origin.x += deltaX;
    frame.origin.y += deltaY;
    self.frame = frame;
    
    self.alpha =1;
    touch = [touches anyObject];
    
    if (self.scrollingFloatViewBlock) {
        CGPoint point = [self convertPoint:self.origin fromView:self];
        self.scrollingFloatViewBlock(point);
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self moveStay];
    
    // 这里可以设置过几秒，alpha减小
    //    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [pThis animateHidden];
    });
        
    if (self.scrollEndedFloatViewBlock) {
        CGPoint point = [self convertPoint:self.origin fromView:self];
        self.scrollEndedFloatViewBlock(point);
    }
}


#pragma mark - move method

/**
 根据stayModel来移动悬浮图片
 */
- (void)moveStay{
    BOOL isLeft = [self judgeLocationIsLeft];
    switch (_stayMode) {
        case STAYMODE_LEFTANDRIGHT:
            [self moveToBorder:isLeft];
            break;
        case STAYMODE_LEFT:
            [self moveToBorder:YES];
            break;
        case STAYMODE_RIGHT:
            [self moveToBorder:NO];
            break;
        default:
            break;
    }
}

/**
 移动到屏幕边缘
 */
- (void)moveToBorder:(BOOL)isLeft{
    CGRect frame = self.frame;
    CGFloat destinationX;
    if (isLeft) {
        destinationX = self.stayEdgeDistance;
    }else{
        CGFloat stayWidth = frame.size.width;
        destinationX = MainScreenWidth - self.stayEdgeDistance - stayWidth;
    }
    frame.origin.x = destinationX;
    frame.origin.y = [self moveSafeLocationY];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:_stayAnimateTime animations:^{
        __strong typeof(self) pThis = weakSelf;
        pThis.frame = frame;
    }];
    isHalfScreen = NO;
}

/**
 当滚动的时候悬浮图片居中在屏幕边缘
 */
- (void)moveToHalfInScreenWhenScrolling{
    
    //    BOOL isLeft = [self judgeLocationIsLeft];
    //    [self moveStayToMiddleInScreenBorder:isLeft];
    isHalfScreen = YES;
}

/**
 悬浮图片居中在屏幕边缘
 */
- (void)moveStayToMiddleInScreenBorder:(BOOL)isLeft{
    CGRect frame = self.frame;
    CGFloat stayWidth = frame.size.width;
    CGFloat destinationX;
    if (isLeft == YES) {
        destinationX = - stayWidth/2;
    }else{
        destinationX = MainScreenWidth - stayWidth + stayWidth/2;
    }
    
    frame.origin.x = destinationX;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        __strong typeof(self) pThis = weakSelf;
        pThis.frame = frame;
    }];
    
}

/**
 设置悬浮图片不高于屏幕顶端，不低于屏幕底端
 */
- (CGFloat)moveSafeLocationY{
    CGRect frame = self.frame;
    CGFloat stayHeight = frame.size.height;
    //当前view的值
    CGFloat curY = self.frame.origin.y;
    CGFloat destinationY = frame.origin.y;
    //悬浮图片的最顶端Y值
    CGFloat stayMostTopY = 64 + _stayEdgeDistance;
    if (curY <= stayMostTopY) {
        destinationY = stayMostTopY;
    }
    //悬浮图片的底端Y值
    CGFloat stayMostBottomY = MainScreenHeight - 64 - _stayEdgeDistance - stayHeight;
    if (IPHONE_X) {
        stayMostBottomY -=34;
    }
    if (curY >= stayMostBottomY) {
        destinationY = stayMostBottomY;
    }
    return  destinationY;
}

#pragma mark - judgeLocationLeft method

/**
 判断当前view是否在父界面的左边
 */
- (BOOL)judgeLocationIsLeft{
    //手机屏幕中间位置x值
    CGFloat middleX = [UIScreen mainScreen].bounds.size.width / 2.0;
    CGFloat curX = self.frame.origin.x + self.bounds.size.width/2;
    if (curX <= middleX) {
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - custom method

- (void)clickFloatViewMethod {
    
    BOOL isLeft = [self judgeLocationIsLeft];
    [UIView animateWithDuration:0.5 animations:^{
        self.size = CGSizeMake(CGRectGetMaxX(self.playImgView.frame)+self.playImgView.x, CGRectGetMaxY(self.playImgView.frame)+self.playImgView.y);
        [self moveToBorder:isLeft];
    }completion:^(BOOL finished) {
        self.titleLab.hidden = YES;
        self.subTitleLab.hidden = YES;
    }];
}

- (void)clickPlayImgViewMethod:(UIButton *)sender {
    
    self.titleLab.hidden = NO;
    self.subTitleLab.hidden = NO;
    if (self.width == CGRectGetMaxX(self.playImgView.frame)+self.playImgView.x) {
        BOOL isLeft = [self judgeLocationIsLeft];
        [UIView animateWithDuration:0.5 animations:^{
            self.size = self.originFrame.size;
            [self moveToBorder:isLeft];
        }completion:^(BOOL finished) {
            
        }];
        return;
    }
    if (sender.tag == 100) {// 暂停
        [self pauseLayer:self.playImgView.layer];
        sender.tag = 101;
        [sender setImage:[UIImage imageNamed:@"icon_pause.png"] forState:UIControlStateNormal];
    }else {
        [self resumeLayer:self.playImgView.layer];
        sender.tag = 100;
        [sender setImage:[UIImage imageNamed:@"icon_play.png"] forState:UIControlStateNormal];

    }
}

- (void)addAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = @(4*M_PI);//倒序 -4
    animation.duration = 8;
    animation.repeatCount = HUGE_VALF;
    [self.playImgView.layer addAnimation:animation forKey:@"rotation"];
}

/**
 layer 暂停动画
 */
- (void)pauseLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

/**
 layer 继续动画
 */
- (void)resumeLayer:(CALayer*)layer {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

+ (instancetype)shareInstance {
    static CYFloatPlayView *_floatView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_floatView == nil) {
            _floatView = [[CYFloatPlayView alloc] initWithFrame:CGRectMake(100, 100, 200, 60)];
            _floatView.backgroundColor = [UIColor whiteColor];
            _floatView.stayMode = STAYMODE_LEFTANDRIGHT;
        }
    });
    return _floatView;
}

- (void)addFloatView {
    if (!self.showing) {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.showing = YES;
    }
}

- (void)removeFloatView {
    [self removeFromSuperview];
    self.showing = NO;
}

- (void)isShowFloatView:(BOOL)isShow {
    self.showing = isShow;
    if (isShow) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
//            [self pauseLayer:self.playImgView.layer];
//            [[RMPlayer shareInstance] rm_audioPlay];
            self.hidden = NO;
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
//            [self resumeLayer:self.playImgView.layer];
//            [[RMPlayer shareInstance] rm_audioPause];
            self.hidden = YES;
        }];
    }
}

#pragma mark - setter method

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.height-10+10, 5, 130, 20)];
        _titleLab.textColor = [UIColor colorWithHex:0x333333];
        _titleLab.font = [UIFont systemFontOfSize:14];
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

- (UILabel *)subTitleLab {
    if (_subTitleLab == nil) {
        _subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.height-10+10, CGRectGetMaxY(self.titleLab.frame)+5, 130, 20)];
        _subTitleLab.textColor = [UIColor colorWithHex:0x666666];
        _subTitleLab.font = [UIFont systemFontOfSize:13];
        _subTitleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _subTitleLab;
}

- (UIImageView *)playImgView {
    if (_playImgView == nil) {
        _playImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.height-10, self.height-10)];
        _playImgView.contentMode = UIViewContentModeScaleToFill;
        _playImgView.layer.cornerRadius = (self.height-10)/2.0;
        _playImgView.layer.masksToBounds = YES;
        _playImgView.layer.borderColor = [UIColor colorWithHex:0xaaaaaa].CGColor;
        _playImgView.layer.borderWidth = 1.0;
        _playImgView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPlayImgViewMethod)];
//        [_playImgView addGestureRecognizer:tap];
        [_playImgView addSubview:self.playImgBtn];
    }
    return _playImgView;
}

- (UIButton *)playImgBtn {
    if (_playImgBtn == nil) {
        _playImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playImgBtn.frame = self.playImgView.bounds;
        _playImgBtn.tag = 100;
        [_playImgBtn setImage:[UIImage imageNamed:@"icon_play.png"] forState:UIControlStateNormal];
        [_playImgBtn addTarget:self action:@selector(clickPlayImgViewMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_playImgView addSubview:_playImgBtn];
    }
    return _playImgBtn;
}

- (void)setCurrentAlpha:(CGFloat)stayAlpha{
    if (stayAlpha <= 0) {
        stayAlpha = 1;
    }
    self.alpha = stayAlpha;
}

- (void)setShowing:(BOOL)showing {
    _showing = showing;
}

- (void)startTestMethod {
    NSString *subTitle = @"这是标题";
    self.titleLab.text = @"小副标题";
    
    self.subTitleLab.text = subTitle;
    [self.playImgView sd_setImageWithURL:[NSURL URLWithString:@"http://img.aibizhi.adesk.com/5eaab356e7bce75e0214dce0"]];
    [self addAnimation];

    // 添加跑马灯
    CGSize size = [self.titleLab.text sizeWithFont:self.titleLab.font];
    if (size.width > self.titleLab.width) {
        self.titleLab.size = size;
        [self.titleLab setAnimationFromLocX:self.titleLab.x+20 toLocX:self.titleLab.x-(size.width-130)-20 duration:3.0];
    }
    
    // 添加跑马灯
    CGSize size1 = [self.subTitleLab.text sizeWithFont:self.subTitleLab.font];
    if (size1.width > self.subTitleLab.width) {
        self.subTitleLab.size =size1;
        [self.subTitleLab setAnimationFromLocX:self.subTitleLab.x+20 toLocX:self.subTitleLab.x-(size1.width-130)-20 duration:3.0];
    }
    
}

@end
