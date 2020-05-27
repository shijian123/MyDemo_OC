//
//  CYLifeCycleView.m
//  MyDemo_OC
//
//  Created by zcy on 2020/5/27.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYLifeCycleView.h"

@implementation CYLifeCycleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        NSLog(@"View_initWithCoder");
        [self makeShadowMethod];
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    NSLog(@"View_initWithFrame");

    [self makeShadowMethod];
    return self;
}

//- (instancetype)init {
//    if (self = [super init]) {
//        NSLog(@"View_init");
//    }
//    return self;
//}

/**
 如果重写了 drawRect: 方法，那么会调用重载的 drawRect: 方法，在 drawRect: 方法中手动绘制得到 bitmap 数据，从而自定义视图的绘制。
 
 注意正常情况下 Display 阶段只会得到图元 primitives 信息，而位图 bitmap 是在 GPU 中根据图元信息绘制得到的。但是如果重写了 drawRect: 方法，这个方法会直接调用 Core Graphics 绘制方法得到 bitmap 数据，同时系统会额外申请一块内存，用于暂存绘制好的 bitmap。

 由于重写了 drawRect: 方法，导致绘制过程从 GPU 转移到了 CPU，这就导致了一定的效率损失,这个过程会额外使用 CPU 和内存，因此需要高效绘制，否则容易造成 CPU 卡顿或者内存爆炸。
 
 
 调用情况：
 1、如果在UIView初始化时没有设置rect大小，将直接导致drawRect不被自动调用。drawRect调用是在Controller->loadView,Controller->viewDidLoad?两方法之后掉用的.所以不用担心在 控制器中,这些View的drawRect就开始画了，这样可以在控制器中设置一些值给View(如果这些View?draw的时候需要用到某些变量 值).
 2、该方法在调用sizeToFit后被调用，所以可以先调用sizeToFit计算出size。然后系统自动调用drawRect:方法。
 3、通过设置contentMode属性值为UIViewContentModeRedraw。那么将在每次设置或更改frame的时候自动调用drawRect:。
 4、直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect:，但是有个前提条件是rect不能为0
 
 */
/// 添加此函数会导致makeShadowMethod失效
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    NSLog(@"View_drawRect");
////    [self makeShadowMethod];
//}

//- (void)setFrame:(CGRect)frame {
//    [super setFrame:frame];
//    NSLog(@"View_setFrame");
//}

/**
 layoutSubviews方便数据计算，drawRect方便视图重绘。
 layoutSubviews在以下情况下会被调用：
 1、init初始化不会触发layoutSubviews。
 2、addSubview会触发layoutSubviews。
 3、设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化。
 4、滚动一个UIScrollView会触发layoutSubviews。
 5、旋转Screen会触发父UIView上的layoutSubviews事件。
 6、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件。 7、直接调用setLayoutSubviews。
 */
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    NSLog(@"View_layoutSubviews");
//}

- (void)makeShadowMethod {
    self.layer.cornerRadius = 20;
    self.layer.masksToBounds = YES;
    self.layer.shadowColor = [UIColor colorWithHex:0xF86965].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.4;
    self.clipsToBounds = NO;
}

@end
