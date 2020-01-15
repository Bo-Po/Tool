//
//  CPSpotLoadView.h
//  O
//
//  Created by 州龚 on 2019/9/17.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPSpotLoadView : UIView

// 圆点数
@property (nonatomic, assign) NSInteger number;
// 颜色数组
@property (nonatomic, copy) NSArray *colors;
// 圆点半径
@property (nonatomic, assign) CGFloat radius;
// 圆点间隔
@property (nonatomic, assign) CGFloat magin;

// 直接放置到 window 上（注意不要被覆盖）
+ (void)showLoadView;
+ (void)hideLoad;
@end


@interface UIView (CPSpotLoadView)
 // 防止窗口被自动销毁
@property (nonatomic) UIWindow *window;
// 每个视图只会有一个，不可主动赋值
@property (nonatomic, strong, readonly) CPSpotLoadView *loadingView;

//显示动画
- (void)showLoading;
//隐藏动画
- (void)hideLoad;
- (void)showLoadingWithMessage:(NSString *)msg;


@end

NS_ASSUME_NONNULL_END
