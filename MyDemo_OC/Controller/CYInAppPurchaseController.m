//
//  CYInAppPurchaseController.m
//  MyDemo_OC
//
//  Created by zcy on 2020/10/9.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYInAppPurchaseController.h"
#import "CYInAppPurchase.h"

@interface CYInAppPurchaseController ()<UITableViewDelegate, UITableViewDataSource, CYInAppPurchaseDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation CYInAppPurchaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view addSubview:self.myTableView];
    });
}

#pragma mark - delegate
#pragma mark UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELLID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", self.dataArr[indexPath.row]);
    
    // 暂时写死商品
    NSString *productIdentifier = @"com.ryan.soulHunter01";
    [CYInAppPurchase sharedInstance].delegate = self;
    [[CYInAppPurchase sharedInstance] identifyCanMakePayments:@[productIdentifier]];
    
}

#pragma mark CYInAppPurchaseDelegate

- (BOOL)isProductIdentifierAvailable:(nonnull NSString *)productIdentifier {
    return YES;
}

-(void)updatedTransactions:(CYPaymentTransactionState)state {
    NSLog(@"------updatedState:%lu", (unsigned long)state);
}

- (void)buySuccess:(SKPaymentTransaction *)transaction {
    NSLog(@"buySuccess");
//    [MBProgressHUD showText:@"购买成功"];
}

- (void)buyFailed:(NSError *)errorInfo {
    NSLog(@"buyFailed");
//    [MBProgressHUD showText:@"购买失败"];
}


#pragma mark - setters && getters

- (NSArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = @[@"1.0", @"2.0", @"3.0",];
    }
    return _dataArr;
}

- (UITableView *)myTableView {
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        
    }
    return _myTableView;
}

@end


