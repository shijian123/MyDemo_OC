//
//  CYRequestWebController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/6.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYRequestWebController.h"
#import <WebKit/WebKit.h>
#import "CYWebView.h"

@interface CYRequestWebController ()<WKUIDelegate, WKNavigationDelegate, UIWebViewDelegate>
//@property (nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) CYWebView *webView;
@property (nonatomic, strong) UIProgressView *progressV;
@property (nonatomic, copy) NSString *paramsStr;

@end

@implementation CYRequestWebController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    #warning 测试
    self.postUrl = @"https://depo.xwbank.com/bha-neo-app/lanmaotech/gateway";
    self.postBody = @"reqData=%7B%22amount%22%3A2%2C%22expired%22%3A%2220200119102200%22%2C%22platformUserNo%22%3A%22LMP2018060620866909%22%2C%22redirectUrl%22%3A%22https%3A%2F%2Fwap.daokoudai.com%2F%2FlmService%2FwithdrawReturn%22%2C%22requestNo%22%3A%22W2020011968405051%22%2C%22withdrawForm%22%3A%22IMMEDIATE%22%2C%22withdrawType%22%3A%22NORMAL_URGENT%22%2C%22timestamp%22%3A%2220200119095200%22%7D&sign=lUgCFQWheD6iHgIzXPGzEBSXfazMz%2Bba9Dn4kNisd5LmjfBEU6U8b6AxgKBXv247%2FEqfYkBe%2BTcjEIvoYi%2FPADtdwi3Nqo%2FCpx3CA6s3sgax0ZGyKibr1Uc2g4QzEs2XCiR6sRV%2B9xAS%2FK81BMU8uNsIPgqL9lKyRaxFLAD5yvG678yPm0aHCDNx2fF3EU8FDjKdzu1yu%2F2YOqPAp1xed6sZ68RaNnW7mkX0R2rrGLrfH41eVPS8cBv3zPZMHV9r%2BzbWt%2B%2Blsn2Ph11WouiRJuuPnPvVLSUWgZpzljKUlosd1sDlDhGL8Vezsu9%2BmogJ2DZ%2Fs7Lse3zd4MJQ3SCQUQ%3D%3D&platformNo=6000007602&userDevice=MOBILE&serviceName=WITHDRAW&keySerial=1";
    
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressV];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    
}

#pragma mark - custom method
/**
 监控webView的值
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]){
        self.progressV.progress = [change[NSKeyValueChangeNewKey] floatValue];
        if (self.progressV.progress >= 1.0) {
            self.progressV.hidden = YES;
            self.webView.frame = self.view.bounds;
        }
    }else if ([keyPath isEqualToString:@"title"]){
        if (self.title.length <= 0) {
            self.title = self.webView.title;
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - delegate
#pragma mark WKNavigationDelegate


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    NSData *httpBody = navigationAction.request.HTTPBody;
    if ([urlStr containsString:@"/mine"]){// 提现成功页面
    
    }
    decisionHandler(WKNavigationActionPolicyAllow);

}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSString *urlStr = navigationResponse.response.URL.absoluteString;
    if ([urlStr containsString:@"/mine"]){// 提现成功页面
//        [self configUMSocialShareWithURLString:urlStr];
        
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"ERROR:%@", error);
}


#pragma mrak UIWebViewDelegate

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSString *url = request.URL.absoluteString;
//    NSString *urlPrefix;
//    return YES;
//}


#pragma mark - setters && getters

- (CYWebView *)webView {
    if (_webView == nil) {
        _webView = [[CYWebView alloc] initWithFrame:self.view.bounds];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:self.postUrl]];
        [request setHTTPMethod: @"POST"];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody: [self.postBody dataUsingEncoding: NSUTF8StringEncoding]];
//        [request setHTTPBody: [NSJSONSerialization dataWithJSONObject:self.postBody options:NSJSONWritingPrettyPrinted error:nil]];
        [_webView loadRequest:request];
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

//- (UIWebView *)webView{
//    if (_webView == nil) {
//        _webView = [[UIWebView alloc]initWithFrame:self
//                    .view.bounds];
//        _webView.backgroundColor = [UIColor purpleColor];
//        _webView.delegate = self;
//        _webView.scalesPageToFit = YES;
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:self.postUrl]];
//        [request setHTTPMethod: @"POST"];
//        [request setHTTPBody: [self.postBody dataUsingEncoding: NSUTF8StringEncoding]];
//        [_webView loadRequest: request];
//
//    }
//    return _webView;
//}


@end
