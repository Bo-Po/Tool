//
//  UIViewController+CPExtend.h
//  swift-OC
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019年 bo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IsUseRefresh)(_Nonnull id);
NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (CPExtend)

/// 是否使用返回刷新（可带值）
@property (nonatomic, copy) IsUseRefresh isBackRefresh;
/// 是否需要刷新
@property (nonatomic, assign) BOOL isNeedRefresh;


/*------------alert消息框------------*/
typedef void(^AlertClickAction)(UIAlertAction *, NSUInteger);

- (void)showToastTitle:(NSString *)title delay:(CGFloat)delay;
- (void)showToastMessage:(NSString *)message delay:(CGFloat)delay;
- (void)showToastTitle:(NSString *)title message:(NSString *)message delay:(CGFloat)delay;
- (void)showTipsTitle:(NSString *)title determine:(NSString *)determine result:(nullable AlertClickAction)result;
- (void)showTipsMessage:(NSString *)message determine:(NSString *)determine result:(nullable AlertClickAction)result;
- (void)showTipsTitle:(NSString *)title message:(NSString *)message determine:(NSString *)determine result:(nullable AlertClickAction)result;
- (void)showCancelTitle:(NSString *)title determine:(NSString *)determine result:(nullable AlertClickAction)result;
- (void)showCancelMessage:(NSString *)message determine:(NSString *)determine result:(nullable AlertClickAction)result;
- (void)showCancelTitle:(NSString *)title message:(NSString *)message determine:(NSString *)determine result:(nullable AlertClickAction)result;
- (void)showTitle:(nullable NSString *)title message:(nullable NSString *)message delay:(CGFloat)delay result:(nullable AlertClickAction)result buttonTitles:(nullable NSString *)buttonTitles, ...;

@end



NS_ASSUME_NONNULL_END
