//
//  CYMyCalendarController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/8/27.
//  Copyright © 2019 CY. All rights reserved.
//  简书介绍：https://www.jianshu.com/p/b2e330b60104

#import "CYMyCalendarController.h"
#import <FSCalendar.h>

@interface CYMyCalendarController ()<FSCalendarDelegate, FSCalendarDataSource>
//@property (nonatomic, strong) FSCalendar *myCalendar;
@property (weak, nonatomic) IBOutlet FSCalendar *myCalendar;

@end

@implementation CYMyCalendarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"日历";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setUpMyCalendar];
    });
}

#pragma mark - custom method


- (void)setUpMyCalendar {
    self.myCalendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesDefaultCase | FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    // 隐藏左右两边的月份显示
    self.myCalendar.appearance.headerMinimumDissolvedAlpha = 0.0;
}

#pragma mark UITabelviewDelegate, UITableViewDatsourse

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    if ([date isPreviousTime]) {
        [MBProgressHUD showText:@"之前的时间不能点击"];
        return NO;
    }

    NSLog(@"selectDate:%@ monthPosition:%lu", date, (unsigned long)monthPosition);
    return YES;
}



#pragma mark - setters && getters


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
