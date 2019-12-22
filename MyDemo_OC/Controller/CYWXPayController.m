//
//  CYWXPayController.m
//  MyDemo_OC
//
//  Created by zcy on 2019/9/2.
//  Copyright © 2019 CY. All rights reserved.
//

#import "CYWXPayController.h"
#import "WXApiRequestHandler.h"
#import "WXApiManager.h"

@interface CYWXPayController ()<WXApiManagerDelegate>

@end

@implementation CYWXPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    [WXApiManager sharedManager].delegate = self;

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(100, 100, 100, 50);
    [btn setTitle:@"payBtn" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(bizPay) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

- (void)bizPay {//微信支付按钮
    NSString *res = [WXApiRequestHandler jumpToBizPay];
    if( ![@"" isEqual:res] ){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"支付失败" message:res delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
    }else {
        NSLog(@"****支付**");
    }
    
}

@end
