//
//  CPInternalPurchase.h
//  O
//
//  Created by CP on 2019/9/17.
//  Copyright © 2019 clearlove. All rights reserved.
//  内购集成

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef enum {
    CPAPPurchSuccess = 0,       // 购买成功
    CPAPPurchFailed = 1,        // 购买失败
    CPAPPurchCancle = 2,        // 取消购买
    CPAPPurchVerFailed = 3,     // 订单校验失败
    CPAPPurchVerSuccess = 4,    // 订单校验成功
    CPAPPurchNotArrow = 5,      // 不允许内购
    CPAPPurchNotProduct = 6,      // 没有商品
} CPAPPurchType;


typedef void(^CPProductHandle)(CPAPPurchType type, NSData * _Nullable data);
// retrue YES;  继续客户端验证购买凭证，否则发送服务器验证购买凭证
typedef BOOL(^CPProductSuccess)(NSData * _Nullable data);

NS_ASSUME_NONNULL_BEGIN

@interface CPInternalPurchase : NSObject <SKPaymentTransactionObserver,SKProductsRequestDelegate>

+ (instancetype)shareInstance;

// 存储内购商品ID
@property (nonatomic, copy) NSArray *productIds;
/**
 * 开始内购
 * purchID 内购商品id
 * success retrue YES;  继续客户端验证购买凭证，否则发送服务器验证购买凭证
 * handle 流程结束的回调
 */
- (void)startPurchWithID:(NSString *)purchID success:(CPProductSuccess)success completeHandle:(CPProductHandle)handle;

@end

NS_ASSUME_NONNULL_END
