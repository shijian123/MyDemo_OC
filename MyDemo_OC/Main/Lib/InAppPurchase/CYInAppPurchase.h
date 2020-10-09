//
//  CYInAppPurchase.h
//  MyIn-AppPurchase
//
//  Created by zcy on 2020/6/5.
//  Copyright © 2020 CY. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define isServiceVerify 0//支付完成返回 校验方式，是否为服务器校验

typedef enum: NSUInteger {
  CYPaymentTransactionStateNoPaymentPermission = 0,//0：没有Payment权限
  CYPaymentTransactionStateAddPaymentFailed,//1：addPayment失败
  CYPaymentTransactionStatePurchasing,//2：正在购买
  CYPaymentTransactionStatePurchased,//3：购买完成(销毁交易)
  CYPaymentTransactionStateFailed,//4：购买失败(销毁交易)
  CYPaymentTransactionStateCancel,//5：用户取消
  CYPaymentTransactionStateRestored,//6：恢复购买(销毁交易)那种买一次就一直有效的内购,比如去广告的,用户删除了 app 再安装,是可以恢复购买的,之前买过的恢复成功之后就是这个 state,当成购买成功就行了
  CYPaymentTransactionStateDeferred,//7：最终状态未确定

} CYPaymentTransactionState;

#define _InAppPurchasing [CYInAppPurchasing sharedInstance]

@class SKProduct;
@class SKPaymentTransaction;

@protocol CYInAppPurchaseDelegate <NSObject>

@required

- (BOOL)isProductIdentifierAvailable:(NSString*)productIdentifier;

@optional

- (void)updatedTransactions:(CYPaymentTransactionState)state;

/// 购买成功
- (void)buySuccess:(SKPaymentTransaction*)transaction;

/// 购买失败
- (void)buyFailed:(NSError*)errorInfo;

@end


@interface CYInAppPurchase : NSObject
@property (nonatomic, weak) id<CYInAppPurchaseDelegate> delegate;

+ (instancetype)sharedInstance;

/// 调用这个方法传入商品id
- (void)identifyCanMakePayments:(NSArray*)requestArray;

@end

NS_ASSUME_NONNULL_END
