//
//  UIViewController+WMPageController.m
//  XZOnLive
//
//  Created by 州龚 on 2019/10/8.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import "UIViewController+WMPageController.h"

#import "ToastView.h"

@implementation UIViewController (WMPageController)

    //设置导航栏title
- (void)setNavTitle:(NSString *)navTitle {
    self.customNav.navTitleLabel.text = navTitle;
}
- (void)setNavbarTintColor:(UIColor *)navbarTintColor {
    [self.customNav.backItem setTitleColor:navbarTintColor forState:(UIControlStateNormal)];
    self.customNav.navTitleLabel.textColor = navbarTintColor;
}

    //是否隐藏导航栏
- (void)setHiddenNavBarHidden:(BOOL)hiddenNavBarHidden {
    if (hiddenNavBarHidden) {
        self.customNav.hidden = YES;
        self.customNav.backItem.hidden = YES;
    } else {
        self.customNav.hidden = NO;
        self.customNav.backItem.hidden = NO;
    }
}

- (void)setPopGestureRecognizer:(BOOL)popGestureRecognizer {
    if (popGestureRecognizer) {
            //禁止滑动切换视图
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    } else {
            //禁止滑动切换视图
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (void)doBack {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

    //TODO: toast提示
- (void)showToastWithMessage:(NSString *)message {
    ToastView *toastView = [[ToastView alloc] initWithToastMessage:message delegate:nil];
    [toastView showAlertViewOn:self.navigationController.view];
        //    [CPToastView showMessage:message];
}

    //TODO: 显示菊花
- (void)showProgress {
    if (self.progressIsShowing) return;
    [self showProgress:[UIApplication sharedApplication].keyWindow isFullScreen:YES];
}

- (void)showProgress:(UIView *)view isFullScreen:(BOOL)isFullScreen {
    self.progressIsShowing = YES;
        //    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
        //    hud.label.text = @"加载中";
        //    hud.detailsLabel.text = @"请耐心等待";
    if (view) {
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
}

    //TODO: 隐藏菊花
- (void)hideProgress {
    self.progressIsShowing = NO;
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}

#pragma mark - init some views
- (void)setProgressIsShowing:(BOOL)progressIsShowing {
    objc_setAssociatedObject(self, @selector(progressIsShowing), @(progressIsShowing), OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)progressIsShowing {
    return ((NSNumber *)objc_getAssociatedObject(self, @selector(progressIsShowing))).boolValue;
}
- (void)setCustomNav:(BaseCustomNavBarView *)customNav {
    objc_setAssociatedObject(self, @selector(customNav), customNav, OBJC_ASSOCIATION_RETAIN);
}
- (BaseCustomNavBarView *)customNav {
    BaseCustomNavBarView *customN = objc_getAssociatedObject(self, @selector(customNav));
    if (!customN) {
        customN = [[BaseCustomNavBarView alloc] initWithFrame:CGRectMake(0, 0, Size_ScreenWidth, isPhoneX?88:64)];
        customN.backgroundColor = [UIColor whiteColor];
        self.customNav = customN;
        [customN.backItem addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    }
    return customN;
}

@end
