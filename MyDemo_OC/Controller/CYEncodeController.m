//
//  CYEncodeController.m
//  MyDemo_OC
//
//  Created by zcy on 2020/7/27.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYEncodeController.h"

@interface CYEncodeController ()

@end

@implementation CYEncodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 300, 300, 200)];
    lab1.numberOfLines = 0;
    NSString *tempStr = @"北京汇源在10/100 ~ 20/100之间，成交量最大，有23.33%的债权成交。查看详情";
    NSMutableAttributedString *myAttStr = [[NSMutableAttributedString alloc] initWithString:tempStr];

    NSArray *arr = [self rangeOfSubString:@"100" inString:tempStr];
    for (NSValue *value in arr) {
        [myAttStr addAttributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle|NSUnderlinePatternSolid),NSBaselineOffsetAttributeName: @(NSUnderlineStyleSingle), NSForegroundColorAttributeName: DefaultRedColor} range:[value rangeValue]];
    }
    
    NSRange range1 = [tempStr rangeOfString:@"10/100"];
    NSRange range2 = [tempStr rangeOfString:@"20/100"];
    NSRange range3 = [tempStr rangeOfString:@"23.33%"];
    [myAttStr addAttributes:@{NSForegroundColorAttributeName: DefaultRedColor} range:range1];
    [myAttStr addAttributes:@{NSForegroundColorAttributeName: DefaultRedColor} range:range2];
    [myAttStr addAttributes:@{NSForegroundColorAttributeName: DefaultRedColor} range:range3];

     //设置可点击文字的范围
     NSRange clickRange = [tempStr rangeOfString:@"查看详情"];
     //设置可点击文本的颜色
    [myAttStr addAttributes:@{NSForegroundColorAttributeName: DefaultPurpleColor} range:clickRange];

    lab1.attributedText = myAttStr;
    [self.view addSubview:lab1];
    
}

/// 获取字符串中多个相同字符串的所有range
- (NSArray*)rangeOfSubString:(NSString*)subStr inString:(NSString*)string {
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSString*string1 = [string stringByAppendingString:subStr];
    NSString *temp;
    for(int i =0; i < string.length; i ++) {
        temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
        if ([temp isEqualToString:subStr]) {
            NSRange range = {i,subStr.length};
            [rangeArray addObject: [NSValue valueWithRange:range]];
            i = i+(int)subStr.length;
        }
//        NSLog(@"i:%d", i);
    }
    return rangeArray;
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
