//
//  CYSelectItemController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/8/26.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYSelectItemController.h"
#import "VKSelectRankView.h"
#import "VKSelectFilterView.h"

@interface CYSelectItemController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *sectionView;
@property (nonatomic, strong) VKSelectRankView *rankView;
@property (nonatomic, strong) VKSelectFilterView *filterView;

@end

@implementation CYSelectItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.myTableView.tableHeaderView = self.headerView;
    });
}

- (void)clickHeaderMethod:(UIButton *)sender {
    if (sender.tag == 102) {

        if (self.sectionView.y == 80) {
            self.rankView.titleView_Y.constant = 80;
        }else {
            self.rankView.titleView_Y.constant = 0;
        }
        [self.rankView showRankView];
        
    }else if (sender.tag == 103) {
        [self.filterView showFilterView];
    }
}

#pragma mark UITabelviewDelegate, UITableViewDatsourse

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELLID"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row:%ld", (long)indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}

- (UITableView *)myTableView {
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        [self.view addSubview:_myTableView];
    }
    return _myTableView;
}

- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 80)];
        _headerView.backgroundColor = [UIColor orangeColor];
    }
    return _headerView;
}

- (UIView *)sectionView {
    if (_sectionView == nil) {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 60)];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.backgroundColor = [UIColor yellowColor];
        leftBtn.tag = 102;
        leftBtn.frame = CGRectMake(0, 0, MainScreenWidth/2.0, 60);
        [leftBtn setTitle:@"排序1" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(clickHeaderMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_sectionView addSubview:leftBtn];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.backgroundColor = [UIColor purpleColor];
        rightBtn.tag = 103;
        rightBtn.frame = CGRectMake(MainScreenWidth/2.0, 0, MainScreenWidth/2.0, 60);
        [rightBtn setTitle:@"筛选" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(clickHeaderMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_sectionView addSubview:rightBtn];
        
    }
    return _sectionView;
}

- (VKSelectRankView *)rankView {
    if (_rankView == nil) {
        _rankView = [[NSBundle mainBundle] loadNibNamed:@"VKSelectRankView" owner:self options:nil].firstObject;
        _rankView.frame = self.view.bounds;
        _rankView.hidden = YES;
        _rankView.titleArr = @[@"排序1",@"排序2",@"排序3"];
        [self.view addSubview:_rankView];
    }
    return _rankView;
}

- (VKSelectFilterView *)filterView {
    if (_filterView == nil) {
        _filterView = [[NSBundle mainBundle] loadNibNamed:@"VKSelectFilterView" owner:self options:nil].firstObject;
        _filterView.frame = CGRectMake(MainScreenWidth, 0, MainScreenWidth, self.view.height);
        NSArray *arr1 = @[[@{@"title":@"分类", @"itemArr":@[@"都市精英", @"打扫大房间", @"会计实务"], @"selectItem":@""} mutableCopy],
                          [@{@"title":@"年龄", @"itemArr":@[@"中青年", @"中老年"], @"selectItem":@""} mutableCopy],
                          [@{@"title":@"性别", @"itemArr":@[@"男性", @"女性"], @"selectItem":@""} mutableCopy],
                          [@{@"title":@"大括号", @"itemArr":@[@"都来看看我", @"我卡金黄色的"], @"selectItem":@""} mutableCopy],
                          [@{@"title":@"啊大富科技啊", @"itemArr":@[@"0-500", @"500-800", @"800以上"], @"selectItem":@""} mutableCopy]];
        _filterView.itemArr = arr1;
        [self.view addSubview:_filterView];
    }
    return _filterView;
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
