//
//  CYExcelController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/7/30.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYExcelController.h"
#import <YWExcel/YWExcelView.h>
@interface CYExcelController ()<YWExcelViewDelegate, YWExcelViewDataSource>
@property (nonatomic, strong) YWExcelView *myExcelView;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSArray *headTexts;
@end

@implementation CYExcelController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"打造iOS的excel表";

    [self.view addSubview:self.myExcelView];
    
}

#pragma mark - delegate

//多少行
- (NSInteger)excelView:(YWExcelView *)excelView numberOfRowsInSection:(NSInteger)section{
    return self.list.count;
}
//多少列
- (NSInteger)itemOfRow:(YWExcelView *)excelView{
    return self.headTexts.count;
}
- (void)excelView:(YWExcelView *)excelView label:(UILabel *)label textAtIndexPath:(YWIndexPath *)indexPath{
    if (indexPath.row < _list.count) {
        NSDictionary *dict = _list[indexPath.row];
        if (indexPath.item == 0) {
            label.text = dict[@"grade"];
        }else{
            NSArray *values = dict[@"score"];
            label.text = values[indexPath.item - 1];
        }
    }
}

#pragma mark -- getter&setter

- (NSMutableArray *)list {
    if (_list == nil) {
        _list = @[].mutableCopy;
        
        [_list addObject:@{@"grade":@"年级",@"score":@[@"10",@"20",@"30",@"40",@"50",@"60",@"70"]}];
        [_list addObject:@{@"grade":@"年级",@"score":@[@"101",@"201",@"301",@"401",@"501",@"601",@"701"]}];
        [_list addObject:@{@"grade":@"年级",@"score":@[@"102",@"202",@"302",@"402",@"502",@"602",@"702"]}];
        [_list addObject:@{@"grade":@"年级",@"score":@[@"103",@"203",@"303",@"403",@"503",@"603",@"703"]}];
        [_list addObject:@{@"grade":@"年级",@"score":@[@"104",@"204",@"304",@"404",@"504",@"604",@"704"]}];
        
        [_list addObject:@{@"grade":@"学校",@"score":@[@"学校10",@"学校20",@"学校30",@"学校40",@"学校50",@"学校60",@"学校70"]}];
        [_list addObject:@{@"grade":@"学校",@"score":@[@"学校10",@"学校20",@"学校30",@"学校40",@"学校50",@"学校60",@"学校70"]}];
        [_list addObject:@{@"grade":@"学校",@"score":@[@"学校10",@"学校20",@"学校30",@"学校40",@"学校50",@"学校60",@"学校70"]}];
    }
    return _list;
}

- (NSArray *)headTexts {
    if (_headTexts == nil) {
        _headTexts = @[@"类目",@"语文",@"数学",@"物理",@"化学",@"生物",@"英语",@"政治"];
    }
    return _headTexts;
}

- (YWExcelView *)myExcelView {
    if (_myExcelView == nil) {
        
        /*
         YWExcelViewStyleDefalut = 0,//整体表格滑动，上下、左右均可滑动（除第一列不能左右滑动以及头部View不能上下滑动外）
         YWExcelViewStylePlain,//整体表格滑动，上下、左右均可滑动（除第一行不能上下滑动以及头部View不能上下滑动外）
         YWExcelViewStyleheadPlain,//整体表格(包括头部View)滑动，上下、左右均可滑动（除第一列不能左右滑动外）
         YWExcelViewStyleheadScrollView,//整体表格(包括头部View)滑动，上下、左右均可滑动
         */
        
        YWExcelViewMode *mode = [YWExcelViewMode new];
        mode.style = YWExcelViewStyleDefalut;
        mode.headTexts = self.headTexts;
        mode.defalutHeight = 40;
        
        _myExcelView = [[YWExcelView alloc] initWithFrame:CGRectMake(20, 74, CGRectGetWidth(self.view.frame) - 40, 250) mode:mode];
        _myExcelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _myExcelView.showBorder = YES;
        _myExcelView.delegate = self;
        _myExcelView.dataSource = self;
    }
    return _myExcelView;
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
