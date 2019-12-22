//
//  CYVoiceView.m
//  MyDemo_OC
//
//  Created by zcy on 2019/6/26.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYVoiceView.h"
#import "CYRecordView.h"

@interface CYVoiceView ()
@property (nonatomic,weak) UIScrollView *contentScrollView; // 承载内容的视图
@property (nonatomic,weak) CYRecordView *recordView;        // 录音视图

@end

@implementation CYVoiceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - setters && getters

- (UIScrollView *)contentScrollView {
    if (_contentScrollView == nil) {
        UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        scrollV.pagingEnabled = YES;
        scrollV.contentSize = CGSizeMake(self.width * 3, 0);
        scrollV.contentOffset = CGPointMake(self.width, 0);
        scrollV.showsHorizontalScrollIndicator = NO;
        scrollV.delegate = self;
        [self addSubview:scrollV];
        _contentScrollView = scrollV;
    }
    return _contentScrollView;
}

- (CYRecordView *)recordView {
    if (_recordView == nil) {
        CYRecordView *recordView = [[CYRecordView alloc] initWithFrame:CGRectMake(self.width * 2, 0, self.width, self.contentScrollView.height)];
        [self.contentScrollView addSubview:recordView];
        _recordView = recordView;
    }
    return _recordView;
}

@end
