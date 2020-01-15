//
//  UIView+Touche.h
//  Dome
//
//  Created by 陈波 on 2017/5/8.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@protocol UIViewToucheDelegate <NSObject>
// 拖动过程中 如果实现了代理 ，还需要移动或缩放请注释掉.m方法里的retain
- (void)toucheView:(UIView *)view didMovedFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;
// 拖动结束手指离开时
- (void)toucheView:(UIView *)view didEndPoint:(CGPoint)point;

@end

@interface UIView (Touche)

@property (weak, nonatomic) id<UIViewToucheDelegate> toucheDelegate;
@property (assign, nonatomic) BOOL isAllowTouche;   // 是否允许touche
@property (assign, nonatomic) BOOL isAllowToucheToTop;  // 是否允许touche置顶
@property (assign, nonatomic) BOOL isAllowZoom;     // 是否允许缩放
@property (assign, nonatomic) BOOL isAllowDrag;     // 是否允许移动

@end



@interface UIView (Image)

//将UIView转成UIImage
- (UIImage *)getImage;
- (UIImage *)getImageWithScale:(CGFloat)scale;

/// view 添加毛玻璃效果
- (void)addBlurEffect:(BOOL)isBackground;
- (void)addBlurEffect:(BOOL)isBackground alpha:(CGFloat)alpha;

@end


@interface UIView (CurrentController)

/// 获取当前View的控制器对象
- (UIViewController *)getCurrentViewController;

@end
