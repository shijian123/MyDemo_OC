//
//  CYInAppPurchase.m
//  MyIn-AppPurchase
//
//  Created by zcy on 2020/6/5.
//  Copyright © 2020 CY. All rights reserved.
//

#import "CYInAppPurchase.h"
#import <StoreKit/StoreKit.h>
#import <Security/Security.h>

@interface CYInAppPurchase ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property (nonatomic, strong) SKProductsRequest *request;

@end

@implementation CYInAppPurchase

+ (instancetype)sharedInstance {
    static CYInAppPurchase *instance = NULL;
     static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [CYInAppPurchase new];
    });
    return instance;
}

- (instancetype)init {
    if(self = [super init]) {
      [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)dealloc {
    [self releaseRequest];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)releaseRequest {
    if(_request) {
      [_request cancel];
      _request.delegate=nil;
      _request=nil;
    }
}

#pragma mark - custom method

- (void)identifyCanMakePayments:(NSArray*)requestArray {
    if (requestArray.count == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(updatedTransactions:)]) {
            [self.delegate updatedTransactions:CYPaymentTransactionStateAddPaymentFailed];
        }
        return;
    }

    if ([SKPaymentQueue canMakePayments]) {
        [self releaseRequest];
        self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:requestArray]];
        _request.delegate=self;
        [_request start];
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(updatedTransactions:)]) {
            [self.delegate updatedTransactions:CYPaymentTransactionStateNoPaymentPermission];
        }
    }

}


/// 转换交易错误信息
/// @param transaction 交易
- (NSString *)transactionErrorString:(SKPaymentTransaction *)transaction {
    NSString *detail = @"";
    if (transaction.error != nil) {
        switch (transaction.error.code) {
            case SKErrorUnknown:
                detail = @"未知的错误，您可能正在使用越狱手机";
                break;
            case SKErrorClientInvalid:
                detail = @"当前苹果账户无法购买商品(如有疑问，可以询问苹果客服)";
                break;
            case SKErrorPaymentCancelled:
                detail = @"订单已取消";
                break;
            case SKErrorPaymentInvalid:
                detail = @"订单无效(如有疑问，可以询问苹果客服)";
                break;
            case SKErrorPaymentNotAllowed:
                detail = @"当前苹果设备无法购买商品(如有疑问，可以询问苹果客服)";
                break;
            case SKErrorStoreProductNotAvailable:
                detail = @"当前商品不可用";
                break;
            default:
                detail = @"未知错误";
                break;
        }
    }
    return detail;
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response {

    NSLog(@"-------收到产品反馈信息------产品ID:%@ 产品数量:%ld",response.invalidProductIdentifiers,response.products.count);
    NSArray * myProducts = response.products;
    for(SKProduct *product in myProducts){
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@", product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@", product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
    }

    if(myProducts && myProducts.count>0) {
        
        SKProduct *product = [myProducts objectAtIndex:0];
        //KeyChain 将用户id绑定到Transaction上
//        NSString *uid = @"userID";
//        NSString *pid = product.productIdentifier;
//        NSInteger ts = [[NSDate date] timeIntervalSince1970];
//        NSDictionary * metadata = @{ @"IAP_KEY_UID": uid, @"IAP_Key_TS": @(ts)};
//        NSData * data = [NSKeyedArchiver archivedDataWithRootObject:metadata];
//        [KeychainWrapper updatePassword:data forUser:pid];
        
        if ([self isProductIdentifierAvailable:product.productIdentifier]) {
            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
            payment.quantity = 1;
            payment.applicationUsername = @"userID";
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            return;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(updatedTransactions:)]) {
        [self.delegate updatedTransactions:CYPaymentTransactionStateAddPaymentFailed];
    }
}

/// 请求失败
- (void)request:(SKRequest*)request didFailWithError:(NSError*)error{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buyFailed:)]) {
        [self.delegate buyFailed:error];
    }
    NSLog(@"---购买失败");
}

#pragma mark - SKPaymentTransactionObserver

/// 监听购买结果
- (void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray *)transactions {
    
    for(SKPaymentTransaction *transaction in transactions){
        CYPaymentTransactionState state;
        switch(transaction.transactionState){
          case SKPaymentTransactionStatePurchasing: { // 商品添加进列表
                state = CYPaymentTransactionStatePurchasing;
            }
            break;

          case SKPaymentTransactionStatePurchased: {
                state = CYPaymentTransactionStatePurchased;
                // 订阅特殊处理
                if (transaction.originalTransaction) {// 如果是自动续费的订单originalTransaction会有内容
                    NSLog(@"originalTransaction:%@", transaction.originalTransaction);
                }else { // 普通购买，以及 第一次购买 自动订阅
                  //交易完成
                  if(isServiceVerify) {// 是否为服务器校验
                    [self completeTransaction:transaction];
                  }else {// 本地作校验
                    [self verifyPurchase:transaction];
                  }
                }
            }
            break;
          case SKPaymentTransactionStateFailed: {
                //交易失败
                if(transaction.error.code != SKErrorPaymentCancelled) {
                    state = CYPaymentTransactionStateFailed;
                    NSString *errorStr = [self transactionErrorString:transaction];
                    NSLog(@"交易发生错误：%@", errorStr);
                }else {
                  state = CYPaymentTransactionStateCancel;
                    NSLog(@"交易被取消");
                }
                [self finshTransaction:transaction];
            }
            break;
            
          case SKPaymentTransactionStateRestored: {
                state = CYPaymentTransactionStateRestored;
                NSLog(@"已经购买过");
                //已经购买过该商品
                [self finshTransaction:transaction];
            }
            break;

          case SKPaymentTransactionStateDeferred: {
                state = CYPaymentTransactionStateDeferred;
            }
            break;

          default:
            break;
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(updatedTransactions:)]) {
            [self.delegate updatedTransactions:state];
        }
      }

}

// Sent when transactions are removed from the queue (via finishTransaction:).

- (void)paymentQueue:(SKPaymentQueue*)queue removedTransactions:(NSArray *)transactions {

    NSLog(@"---removedTransactions");

}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.

- (void)paymentQueue:(SKPaymentQueue*)queue restoreCompletedTransactionsFailedWithError:(NSError*)error {

    NSLog(@"restoreCompletedTransactionsFailedWithError");

}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue*)queue {

    NSLog(@"paymentQueueRestoreCompletedTransactionsFinished");

}

// Sent when the download state has changed.

- (void)paymentQueue:(SKPaymentQueue*)queue updatedDownloads:(NSArray *)downloads {

    NSLog(@"updatedDownloads");

}

#pragma mark - Private

#pragma mark 验证购买

/**
 验证购买，在每一次购买完成之后，需要对购买的交易进行验证
 所谓验证，是将交易的凭证进行"加密"，POST请求传递给苹果的服务器，苹果服务器对"加密"数据进行验证之后，
 会返回一个json数据，供开发者判断凭据是否有效
 有些"内购助手"同样会拦截验证凭据，返回一个伪造的验证结果
 所以在开发时，对凭据的检验要格外小心
 */
- (void)verifyPurchase:(SKPaymentTransaction*)transaction {// 本地验证
    // 用户ID，
    NSLog(@"verifyPurchase_userName:%@", transaction.payment.applicationUsername);
    
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    // 正式验证api地址
    NSString *receiptStr = @"https://buy.itunes.apple.com/verifyReceipt";
    if ([receiptURL.absoluteString containsString:@"sandbox"]) {//是否为沙盒环境，苹果审核为沙盒环境 沙箱验证api地址
        receiptStr = @"https://sandbox.itunes.apple.com/verifyReceipt";
    }
    
    NSURL *url = [NSURL URLWithString:receiptStr];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];

    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:payloadData];
    [request setHTTPMethod:@"POST"];
    // 此请求返回的是一个json结果 将数据反序列化为数据字典
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"验证中...");
        if (data) {
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if(jsonResponse) {
              if([[jsonResponse objectForKey:@"status"] intValue] == 0) {
                //通常需要校验：bid，product_id，purchase_date，status
                  NSLog(@"验证成功");
                  if (self.delegate && [self.delegate respondsToSelector:@selector(buySuccess:)]) {
                      [self.delegate buySuccess:transaction];
                  }
              }else {
                //验证失败，检查你的机器是否越狱
                  NSLog(@"验证失败");
              }
            }
        }
        NSLog(@"服务器已验证");
        [self finshTransaction:transaction];
    }];
    
    //必须启动任务，否则不会走block中的回调
    [dataTask resume];
    
}

/**
 将base64编码的交易凭证，发送给后台，由后台服务器发送给苹果进行验证 https://buy.itunes.apple.com/verifyReceipt
 */
- (void)completeTransaction:(SKPaymentTransaction*)transaction {// 服务器验证
    //服务器校验
    NSLog(@"后台服务器校验并成功");
    [self finshTransaction:transaction];
}

- (void)finshTransaction:(SKPaymentTransaction*)transaction {
    //结束交易
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    NSLog(@"结束交易");
}

- (BOOL)isProductIdentifierAvailable:(NSString*)productIdentifier {
    return YES;
}

@end

/**
 什么是掉单？
 用户选定商品支付完成后，服务器不能正确及时的获取支付状态，导致这笔已支付的订单未能发货。
 为什么会产生掉单？
 1. 手机网络情况复杂多变。
 2. 苹果服务器在境外连通性不确定。
 以上两个客观原因，我们无法改变，会导致如下情况：
 1. 用户支付完成之后，苹果服务器将支付票据返回给客户端，客户端发送票据到后台服务器。(可能会断网，未能提交到后台服务器)
 2. 后台服务器拿到支付票据，请求苹果服务器票据验证。(后台服务器连接苹果服务器超时，未能验证票据)。

 优化方案
 掉单的原因目前已经找到了，那么需要从客户端和服务器两个方面做优化，彻底解决掉iOS支付掉单问题。
  
 客户端需要做什么优化？
 客户端在拿到苹果支付票据后，一定要先将支付票据和用户账号做映射，标记为未验证，保存到本地数据库中，然后把票据提交到后台服务器，在确保得到后台服务器的反馈，在将本地数据库中该条记录删除，确保后台服务器收到该票据。
  
 服务器端做什么优化？
 服务器接收到客户端的票据以及验证信息时，先将票据存储到数据库中，然后请求苹果服务器验证票据，如果因为连接苹果服务器超时或者其他网络情况，标记该票据为验证证状态，后续交给定时任务处理，确保能够正确验证票据结果。
 
 */


/**
 
 审核注意事项
 
 IAP审核时, 需要提供沙盒测试账号和一个APP的测试账号, 在审核过程时, 我们整个流程都已经切换为正式环境, 但审核人员仍然使用测试凭证去进行验证, 我们服务器需要在审核阶段, 对于此uid的凭证仍然去测试验证接口去验证, 否则会被拒绝通过。
 
 */
