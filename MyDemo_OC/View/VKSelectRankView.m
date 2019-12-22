//
//  VKSelectRankView.m
//  MyDemo_OC
//
//  Created by zcy on 2019/8/26.
//  Copyright © 2019 CY. All rights reserved.
//

#import "VKSelectRankView.h"

@interface VKSelectRankView ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation VKSelectRankView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showRankView {
    self.hidden = NO;
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}

- (IBAction)hiddenRankView:(id)sender {
    self.alpha = 1.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.clickSelectRankBlock) {
        self.clickSelectRankBlock(self.titleArr[indexPath.row]);
    }
    [self hiddenRankView:nil];
}

- (void)setTitleArr:(NSArray *)titleArr {
    _titleArr = titleArr;
    [self.myTableView reloadData];
    
}

@end
