//
//  CYScrollBGImgController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/25.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYScrollBGImgController.h"

@interface CYScrollBGImgController ()<UIScrollViewDelegate> {
    CGFloat currentOffsetY;
}

@property (weak, nonatomic) IBOutlet UIImageView *bgImageV_white;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV_black;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moonCenterX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moonTop;

@end

@implementation CYScrollBGImgController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentOffsetY = 0.0;
}

#pragma mark - delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 300) {
        
        CGFloat num = 0;
        if (scrollView.contentOffset.y > currentOffsetY) {// 向上滑动
            num = scrollView.contentOffset.y - currentOffsetY;
            if (self.moonTop.constant <= 30 ) {// moon在最高点
//                NSLog(@"***********moon在最高点*********");
                self.moonTop.constant = 30;
                self.moonCenterX.constant = 0;
            }else {// 初始位置是-50 80，升起则为0, 30
                self.moonCenterX.constant = self.moonCenterX.constant + num*0.1;
                self.moonTop.constant = self.moonTop.constant - num*0.1;
            }
            
            if (self.moonTop.constant < 40) {
            }else {
            }
            
        }else {// 向下滑动
            num = currentOffsetY - scrollView.contentOffset.y;
            
            if (self.moonTop.constant >= 80 ) {// moon在最低点
//                NSLog(@"***********moon在最低点*********");
                self.moonTop.constant = 80;
                self.moonCenterX.constant = -50;
            }else {
                self.moonCenterX.constant = self.moonCenterX.constant - num*0.1;
                self.moonTop.constant = self.moonTop.constant + num*0.1;
            }
            
        }
    if (self.moonTop.constant <= 40) {
        self.bgImageV_black.alpha = 1.0;
    }else if(self.moonTop.constant >= 80){
        self.bgImageV_black.alpha = 0.0;
    }else {
        self.bgImageV_black.alpha = 1 - (self.moonTop.constant-40.0)/40.0;
    }
        currentOffsetY = scrollView.contentOffset.y;
//    }
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
