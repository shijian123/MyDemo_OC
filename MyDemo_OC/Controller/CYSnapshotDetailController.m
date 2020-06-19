//
//  CYSnapshotDetailController.m
//  MyDemo_OC
//
//  Created by zcy on 2020/6/16.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYSnapshotDetailController.h"
#import <TYSnapshotScroll.h>
#import <TYSnapshotManager.h>
#import "CYSnapshotPreviewController.h"
#import <WebKit/WebKit.h>

@interface CYSnapshotDetailController ()<UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) WKWebView *myWebView;
/// 需要截图的view
@property (nonatomic,strong) UIView *snapView;
@property (nonatomic, strong) MBProgressHUD *myHud;

@end

@implementation CYSnapshotDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"详情";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开始截图" style:UIBarButtonItemStylePlain target:self action:@selector(startSnapshot)];
    
    if (self.detailStyle == SnapshotDetail_webview) {
        [self.view addSubview:self.myWebView];
        self.myHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }else {
        [self.view addSubview:self.myTableView];
    }
    
    

}

- (void)startSnapshot {
    [TYSnapshotScroll screenSnapshot:self.snapView finishBlock:^(UIImage *snapshotImage) {
        CYSnapshotPreviewController *vc = [[CYSnapshotPreviewController alloc] initWithImage:snapshotImage];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELLID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELLID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row:%ld", (long)indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    [self.myHud hide:YES];
}

#pragma mark - setter&getter

- (WKWebView *)myWebView {
    if (_myWebView == nil) {
        _myWebView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
        _myWebView.navigationDelegate = self;
        [_myWebView loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10]];
        self.snapView = _myWebView;
//        [TYSnapshotManager defaultManager].maxScreenCount = 40;
//        [TYSnapshotManager defaultManager].delayTime = 0.3;
    }
    return _myWebView;
}

- (UITableView *)myTableView {
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        self.snapView = _myTableView;
    }
    return _myTableView;
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
