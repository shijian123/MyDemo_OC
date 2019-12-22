//
//  CYImageWebController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/8/29.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYImageWebController.h"
#import <WebKit/WebKit.h>
#import <os/log.h>

@interface CYImageWebController ()<WKUIDelegate, WKNavigationDelegate>
@property(nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressV;

@end

@implementation CYImageWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    
    self.view.backgroundColor = DefaultBackgroundColor;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressV];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
//    [self.webView removeObserver:self forKeyPath:@"title"];
    
}

#pragma mark - custom method
/**
 监控webView的值
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]){
        self.progressV.progress = [change[NSKeyValueChangeNewKey] floatValue];
        //        NSLog(@"progressV:%f", self.progressV.progress);
        if (self.progressV.progress >= 1.0) {
            self.progressV.hidden = YES;
            self.webView.frame = self.view.bounds;
        }
//    }else if ([keyPath isEqualToString:@"title"]){
//        if (self.title.length <= 0) {
//            self.title = self.webView.title;
//        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/**
 根据urlStr分解出分享所需要的内容进行分享
 */
- (void)configUMSocialShareWithURLString:(NSString *)urlStr{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSArray *urlArr = [urlStr componentsSeparatedByString:@"?"];
    [dic setObject:urlArr[0] forKey:@"baseUrl"];
    
    NSArray *titleArr = [urlArr[1] componentsSeparatedByString:@"&"];
    for (NSString *keys in titleArr) {
        NSArray *titleArr = [keys componentsSeparatedByString:@"="];
        [dic setObject:titleArr[1] forKey:titleArr[0]];
    }
}

/**
 根据传递的request配置剪切板
 */
- (void)cofigClipboardWithURLString:(NSString *)urlStr{
    NSArray *clipboardArr = [urlStr componentsSeparatedByString:@"clipboard="];
    if (clipboardArr.count>1) {
        //邀请界面
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = clipboardArr[1];
        [MBProgressHUD showText:@"复制成功"];
    }else {
        [MBProgressHUD showError:@"复制失败"];
    }
}

#pragma mark - delegate
#pragma mark WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSString *urlStr = navigationResponse.response.URL.absoluteString;
    if ([urlStr containsString:@"/mine"]){// 提现成功页面
        //        [self configUMSocialShareWithURLString:urlStr];
        
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

#pragma mark - setters && getters

- (WKWebView *)webView {
    if (_webView == nil) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
//        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.loadUrl]];
//        [_webView loadRequest:request];
        
        NSString *imgSrc = @"<img src=\"http:\/\/api.vkang120.cn\/images\/project\/000007.jpg\" width=\"100%\">";
        NSString *html = [NSString stringWithFormat:@"<html><meta charset=\"UTF-8\"><header></header><body>%@</body></html>", imgSrc];
        [_webView loadHTMLString:html baseURL:nil];
        
        os_log(OS_LOG_DEFAULT, "Some message");

    }
    return _webView;
}

- (UIProgressView *)progressV {
    if (_progressV == nil) {
        _progressV = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, MainScreenWidth, 1)];
        _progressV.trackTintColor = DefaultBackgroundColor;
        _progressV.progressTintColor = DefaultRedColor;
        _progressV.progress = 0.0;
    }
    return _progressV;
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
