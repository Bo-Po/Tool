//
//  UIViewController+WMPageController.h
//  XZOnLive
//
//  Created by 州龚 on 2019/10/8.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCustomNavBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (WMPageController)

@property(nonatomic, assign) BOOL progressIsShowing;
// 自定义导航
@property (nonatomic, strong) BaseCustomNavBarView *customNav;

//设置导航栏title
- (void)setNavTitle:(NSString *)navTitle;
- (void)setNavbarTintColor:(UIColor *)navbarTintColor;
//是否隐藏导航栏
- (void)setHiddenNavBarHidden:(BOOL)hiddenNavBarHidden;

//TODO: toast提示框
- (void)showToastWithMessage:(NSString *)message;
//TODO: 显示菊花
- (void)showProgress;
//TODO: 隐藏菊花
- (void)hideProgress;

@end

NS_ASSUME_NONNULL_END
