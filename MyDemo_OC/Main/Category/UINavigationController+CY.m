//
//  UINavigationController+CY.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/16.
//  Copyright © 2019 CY. All rights reserved.
//

#import "UINavigationController+CY.h"

@implementation UINavigationController (CY)

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated animationType:(NSString *)type{
    
    CATransition *animation = [CATransition animation];
    animation.duration = .3;
    
    if (![type isEqualToString:@"left"]) {
        
        animation.type = type;
        animation.subtype = kCATransitionFromRight;
        animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
        
    }else{
        
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromLeft;
        
    }
    
    [self.view.layer addAnimation:animation forKey:@"animation"];
    [self pushViewController:viewController animated:YES];
}

- (void)popViewControllerAnimated:(BOOL)animated animationType:(NSString *)type{
    
    CATransition *animation = [CATransition animation];
    animation.duration = .4;
    
    if (![type isEqualToString:@"left"]) {
        
        animation.type = type;
        animation.subtype = kCATransitionFromLeft;
        animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    }else{
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromRight;
    }
    
    [self.view.layer addAnimation:animation forKey:@"animation"];
    [self popViewControllerAnimated:animated];
};

@end
