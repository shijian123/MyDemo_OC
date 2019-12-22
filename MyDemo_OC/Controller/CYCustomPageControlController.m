//
//  CYCustomPageControlController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/7/5.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYCustomPageControlController.h"
#import "CYPageControl.h"

@interface CYCustomPageControlController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollV;
@property (nonatomic, strong) CYPageControl *pageControl;
@end

@implementation CYCustomPageControlController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for(int a=0; a<6;a++){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(MainScreenWidth*a, 0, MainScreenWidth, MainScreenHeight)];
        view.backgroundColor = [UIColor yellowColor];
        if(a == 1 || a == 3 || a == 4){
            view.backgroundColor = [UIColor purpleColor];
        }
        [self.mainScrollV addSubview:view];
        
    }
    self.mainScrollV.contentSize = CGSizeMake(MainScreenWidth*6, MainScreenHeight);
    self.pageControl.pageCount = 4;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentNum = scrollView.contentOffset.x/MainScreenWidth;
    self.pageControl.currentPage = currentNum;
    
}

- (UIScrollView *)mainScrollV {
    if (_mainScrollV == nil) {
        _mainScrollV = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _mainScrollV.delegate = self;
        _mainScrollV.pagingEnabled = YES;
        [self.view addSubview:_mainScrollV];
    }
    return _mainScrollV;
}

- (CYPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[CYPageControl alloc] initWithFrame:CGRectMake(100, 300, 200, 30)];
        _pageControl.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_pageControl];
    }
    return _pageControl;
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
