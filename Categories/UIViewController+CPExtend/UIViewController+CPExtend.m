//
//  UIViewController+CPExtend.m
//  swift-OC
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019年 bo. All rights reserved.
//

#import "UIViewController+CPExtend.h"
#import <objc/runtime.h>

@implementation UIViewController (CPExtend)

- (void)setIsBackRefresh:(IsUseRefresh)isBackRefresh {
    objc_setAssociatedObject(self, @selector(isBackRefresh), isBackRefresh, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (IsUseRefresh)isBackRefresh {
    return objc_getAssociatedObject(self, @selector(isBackRefresh));
}

- (void)setIsNeedRefresh:(BOOL)isNeedRefresh {
    objc_setAssociatedObject(self, @selector(isNeedRefresh), @(isNeedRefresh), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isNeedRefresh {
    return [objc_getAssociatedObject(self, @selector(isNeedRefresh)) boolValue];
}
- (void)showToastTitle:(NSString *)title delay:(CGFloat)delay {
    [self showTitle:title message:nil delay:delay result:nil buttonTitles:nil];
}
- (void)showToastMessage:(NSString *)message delay:(CGFloat)delay {
    [self showTitle:nil message:message delay:delay result:nil buttonTitles:nil];
}
- (void)showToastTitle:(NSString *)title message:(NSString *)message delay:(CGFloat)delay {
    [self showTitle:title message:message delay:delay result:nil buttonTitles:nil];
}
- (void)showTipsTitle:(NSString *)title determine:(NSString *)determine result:(nullable AlertClickAction)result {
    [self showTitle:title message:nil delay:0. result:nil buttonTitles:determine, nil];
}
- (void)showTipsMessage:(NSString *)message determine:(NSString *)determine result:(nullable AlertClickAction)result {
    [self showTitle:nil message:message delay:0. result:result buttonTitles:determine, nil];
}
- (void)showTipsTitle:(NSString *)title message:(NSString *)message determine:(NSString *)determine result:(nullable AlertClickAction)result {
    [self showTitle:title message:message delay:0. result:result buttonTitles:determine, nil];
}
- (void)showCancelTitle:(NSString *)title determine:(NSString *)determine result:(nullable AlertClickAction)result {
    [self showTitle:title message:nil delay:0. result:result buttonTitles:determine, @"取消", nil];
}
- (void)showCancelMessage:(NSString *)message determine:(NSString *)determine result:(nullable AlertClickAction)result {
    [self showTitle:nil message:message delay:0. result:result buttonTitles:determine, @"取消", nil];
}
- (void)showCancelTitle:(NSString *)title message:(NSString *)message determine:(NSString *)determine result:(nullable AlertClickAction)result {
    [self showTitle:title message:message delay:0. result:result buttonTitles:determine, @"取消", nil];
}
- (void)showTitle:(nullable NSString *)title message:(nullable NSString *)message delay:(CGFloat)delay result:(nullable AlertClickAction)result buttonTitles:(nullable NSString *)buttonTitles, ... {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    NSString *arg = nil;
    va_list argList;  //定义一个 va_list 指针来访问参数表
    NSString *cancel = nil;
    NSMutableArray *otherButtonTitleArray = [[NSMutableArray alloc] init];
    if (buttonTitles) {
        if ([buttonTitles isEqualToString:@"取消"]) {
            cancel = buttonTitles;
        } else {
            [otherButtonTitleArray addObject:buttonTitles];
            va_start(argList, buttonTitles);
            while ((arg = va_arg(argList, NSString *))) { //调用 va_arg 依次取出 参数，它会自带指向下一个参数
                if ([arg isEqualToString:@"取消"]) {
                    NSAssert(cancel == nil, @"取消按钮最多只一个");
                    cancel = arg;
                } else {
                    [otherButtonTitleArray addObject:arg];
                }
            }
            va_end(argList); // 收尾，记得关闭
        }
    }
    
    if (cancel) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            if (result) {
                result(action, 0);
            }
        }];
        [alert addAction:cancelAction];
    }
    for (NSString *buttonTitle in otherButtonTitleArray) {
        __block NSUInteger index = [otherButtonTitleArray indexOfObject:buttonTitle];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:buttonTitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if (result) {
                result(action, index+1);
            }
        }];
        [alert addAction:otherAction];
    }
    [self presentViewController:alert animated:YES completion:nil];
    
    if (delay != 0.) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

@end
