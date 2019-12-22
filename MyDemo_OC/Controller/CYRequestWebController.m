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

@interface CYRequestWebController ()<WKUIDelegate, WKNavigationDelegate>
//@property (nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) CYWebView *webView;
@property (nonatomic, strong) UIProgressView *progressV;
@property (nonatomic, copy) NSString *paramsStr;

@end

@implementation CYRequestWebController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.postUrl = @"test1";
    self.postBody = @"test2";
    
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
        //        NSLog(@"progressV:%f", self.progressV.progress);
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

#pragma mark - setters && getters

- (CYWebView *)webView {
    if (_webView == nil) {
#warning 测试
        //        self.postUrl = @"https://fintechlm.bosc.cn:8001/bha-neo-app/lanmaotech/gateway";
        //        self.postBody = @"reqData=%7B%22amount%22%3A1%2C%22expired%22%3A%2220190905154435%22%2C%22platformUserNo%22%3A%22LMP2018060620866909%22%2C%22redirectUrl%22%3A%22https%3A%2F%2Fwap.daokoudai.com%2F%2FlmService%2FwithdrawReturn%22%2C%22requestNo%22%3A%22W2019090555479538%22%2C%22withdrawForm%22%3A%22IMMEDIATE%22%2C%22withdrawType%22%3A%22NORMAL_URGENT%22%2C%22timestamp%22%3A%2220190905151435%22%7D&sign=DPMjSZ1RY6wXfJ7V7Re1Tlo7FEbnGNxfJEw%2FnOJ1%2FQGDtvkj1IEcPPHq6%2BaPF%2BWVIaSWxfzQaomDlAlkb8xYeTvfrCsH20NiHpY7qQPj5O67hopjGDmEiDmx%2B1kUCbzK%2BiagciyGrHJ72hBjwexLA1a5k8A3HpjFU5vPIv58Y7HQsNCu5zUGGbGwiEZ%2FcDAv2CR5jB%2BoDFmUv6btvChzMJnGk5GLhztAX1nm1FIrnDQ78DietUpUP1imLj4emXPQz1%2BYHsZ1DDzgWrRzFIBuOZf4qb%2FPiZGwr%2BAbjYmh3bez4tND92scMvV6fhmimpPoWgPGPZtCmmB2SZtAJU%2FhJQ%3D%3D&platformNo=9100004001&userDevice=MOBILE&serviceName=WITHDRAW&keySerial=1";
        
        _webView = [[CYWebView alloc] initWithFrame:self.view.bounds];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:self.postUrl]];
        [request setHTTPMethod: @"POST"];
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
//        _webView.backgroundColor = [UIColor whiteColor];
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


///**
// *  懒猫申请提现
// */
//- (void)requestServerLazyCatWithdrawConfirmWithAmount:(NSString *)amount type:(NSString *)type{
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"token"] = @"1791ace03e7b430083a994ea8f2e3c82";
//    param[@"amount"] = @1;
//    param[@"type"] = @0;
//    //    param[@"returnUrl"] 看需要决定，可以不送
//    [JKHttpRequestTool get:@"https://www.daokoudai.com/api/3.0/appStore/lmWithdrawConfirm?apiName=daokoudai&appKey=88888888&channel=appstore&from=IC&imei=0e0b3b3087754798b719c8873105c377&params=%7B%0A%20%20%22token%22%20%3A%20%221791ace03e7b430083a994ea8f2e3c82%22%2C%0A%20%20%22amount%22%20%3A%20%221%22%2C%0A%20%20%22type%22%20%3A%20%220%22%0A%7D&version=2.9.0" params:[NSDictionary dictionary] success:^(id json) {
//
//        self.postBody = json[@"params"];
//        self.postUrl = json[@"returnUrl"];
//        [self.view addSubview:self.webView];
//        [self.view addSubview:self.progressV];
//    }failure:^(NSError *error) {
//
//    }];
//}
//



@end
