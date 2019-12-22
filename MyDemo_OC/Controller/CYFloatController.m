//
//  CYFloatController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/8/27.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYFloatController.h"
#import "CYFloatPlayView.h"
#import "CYFloatDeleteView.h"

@interface CYFloatController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) CYFloatPlayView *floatView;
@property (nonatomic) CGPoint topPoint;

@end

@implementation CYFloatController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.floatView];

}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.floatView moveToHalfInScreenWhenScrolling];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.floatView setCurrentAlpha:0.5];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.floatView setCurrentAlpha:1];
}

#pragma mark UITabelviewDelegate, UITableViewDatsourse

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELLID"];
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}


#pragma mark - setters && getters

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (CYFloatPlayView *)floatView {
    if (_floatView == nil) {
        _floatView = [[CYFloatPlayView alloc] initWithFrame:CGRectMake(100, 100, 200, 60)];
        _floatView.backgroundColor = [UIColor whiteColor];
        _floatView.stayMode = STAYMODE_LEFTANDRIGHT;
        
        CY_WeakSelf;
        _floatView.scrollBeganFloatViewBlock = ^(CGPoint currentPoint) {
            // 设置初始位置
            weakSelf.topPoint = currentPoint;
        };
        _floatView.scrollingFloatViewBlock = ^(CGPoint currentPoint) {
            if (weakSelf.topPoint.y > currentPoint.y) {// 往上滑动，进行赋值
                weakSelf.topPoint = currentPoint;
            }else {// 往下滑动
                if ((currentPoint.y - weakSelf.topPoint.y)> 200) {// 偏移量大于200,显示删除框
                    [[CYFloatDeleteView sharedInstance] showDeleteView];
                }else { // 隐藏删除框
                    [[CYFloatDeleteView sharedInstance] hiddenDeleteView];
                }
            }
        };
        
        _floatView.scrollEndedFloatViewBlock = ^(CGPoint currentPoint) {
            if (currentPoint.y >= MainScreenHeight-100-64) {// 删除
                NSLog(@"**********删除**********");
                [[CYFloatDeleteView sharedInstance] hiddenDeleteView];
                weakSelf.floatView.alpha = 0;
            }
        };
        
    }
    return _floatView;
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
