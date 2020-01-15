//
//  UIView+Layout.h
//  BPCustom
//
//  Created by ChenB on 16/11/18.
//  Copyright © 2016年 ChenB. All rights reserved.
//

#import <UIKit/UIKit.h>

#define selfView @"self_view"

@interface UIView (Layout)
/// 利用vfl语言autoLayout到父视图
- (instancetype)layoutFormSuperViewWithVfl:(NSString *)vfl;
/// 顶部到view底部
- (instancetype)layoutTopToView:(UIView *)view constant:(CGFloat)constant;
/// 底部到view顶部
- (instancetype)layoutBottomToView:(UIView *)view constant:(CGFloat)constant;
/// 左边到view右边
- (instancetype)layoutLeftToView:(UIView *)view constant:(CGFloat)constant;
/// 右边到view左边
- (instancetype)layoutRightToView:(UIView *)view constant:(CGFloat)constant;
/// 顶部对齐
- (instancetype)layoutTopEqualView:(UIView *)view constant:(CGFloat)constant;
/// 底部对齐
- (instancetype)layoutBottomEqualView:(UIView *)view constant:(CGFloat)constant;
/// 左边对齐
- (instancetype)layoutLelfEqualView:(UIView *)view constant:(CGFloat)constant;
/// 右边对齐
- (instancetype)layoutRightEqualView:(UIView *)view constant:(CGFloat)constant;
/// 水平方向间隔
- (instancetype)layoutHEqualView:(UIView *)view constant:(CGFloat)constant;
/// 垂直方向间隔
- (instancetype)layoutVEqualView:(UIView *)view constant:(CGFloat)constant;
/// 水平方向居中对齐
- (instancetype)layoutHCenterEqualView:(UIView *)view constant:(CGFloat)constant;
/// 垂直方向居中对齐
- (instancetype)layoutVCenterEqualView:(UIView *)view constant:(CGFloat)constant;
/// 等宽
- (instancetype)layoutWidthEqualView:(UIView *)view;
/// 设置宽度
- (instancetype)layoutWidthEqualConstant:(CGFloat)constant;
/// 等高
- (instancetype)layoutHeightEqualView:(UIView *)view;
/// 设置高度
- (instancetype)layoutHeightEqualConstant:(CGFloat)constant;
/// 宽高比
- (instancetype)layoutWidthHeightRatio:(double)ratio;
@end


typedef enum : NSUInteger {
    UIViewShadowStyleDefault = 0,
    UIViewShadowStyleTop,
    UIViewShadowStyleLeft,
    UIViewShadowStyleRight,
    UIViewShadowStyleBottom,
} UIViewShadowStyle;
@interface UIView (Shadow)

@property (nonatomic, assign) UIViewShadowStyle shadowStyle; // 阴影样式
/// 添加阴影效果
- (void)addShadowColor:(UIColor *)theColor radius:(CGFloat)radius;

@end
