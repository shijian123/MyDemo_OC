//
//  CYPageControl.m
//  MyDemo_OC
//
//  Created by zcy on 2019/7/5.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYPageControl.h"

@interface CYPageControl ()
@property (nonatomic, strong) UIView *currentView;
@end

@implementation CYPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - setters && getters

- (void)setPageCount:(NSInteger)pageCount {
    _pageCount = pageCount;
    
    CGFloat spaceW = 10;
    CGFloat max_x = 10;
    CGFloat view_w = 6;
    for(int a = 0;a<pageCount; a++){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(max_x, 10, view_w, view_w)];
        max_x += view_w + spaceW;
        view.tag = 100+a;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = view.frame.size.height/2.0;
        [self addSubview:view];
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, max_x, self.frame.size.height);
    
    UIView *view = [self viewWithTag:100];
    self.currentView.center = view.center;
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    
    [UIView animateWithDuration:0.3 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseOut animations:^{
        UIView *view = [self viewWithTag:100+currentPage];
        self.currentView.center = view.center;
    } completion:^(BOOL finished) {
    }];
}

- (UIView *)currentView {
    if(_currentView == nil){
        _currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 6)];
        _currentView.backgroundColor = [UIColor whiteColor];
        _currentView.layer.cornerRadius = 3;
        _currentView.layer.masksToBounds = YES;
        [self addSubview:_currentView];
    }
    return _currentView;
}

@end
