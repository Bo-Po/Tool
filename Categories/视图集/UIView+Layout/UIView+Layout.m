//
//  UIView+Layout.m
//  BPCustom
//
//  Created by ChenB on 16/11/18.
//  Copyright © 2016年 ChenB. All rights reserved.
//

#import "UIView+Layout.h"

@implementation UIView (Layout)
// @"H:[blueView(100)]-10-|"; 水平方向
// @"V:|-[blueView]-|"; 垂直方向
- (instancetype)layoutFormSuperViewWithVfl:(NSString *)vfl {
    NSLayoutFormatOptions options = 0;
    if ([[vfl substringToIndex:1] isEqualToString:@"H"]) {
        options = NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop;
    }
     self.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *hCons = [NSLayoutConstraint constraintsWithVisualFormat:vfl options:options metrics:nil views:@{selfView:self}];
    [self.superview addConstraints:hCons];
    return self;
}

- (instancetype)layoutTopToView:(UIView *)view constant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:constant];
    [self.superview addConstraint:layout];
    return self;
}

- (instancetype)layoutBottomToView:(UIView *)view constant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:constant * -1];
    [self.superview addConstraint:layout];
    return self;
}

- (instancetype)layoutLeftToView:(UIView *)view constant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:constant];
    [self.superview addConstraint:layout];
    return self;
}

- (instancetype)layoutRightToView:(UIView *)view constant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:constant * -1];
    [self.superview addConstraint:layout];
    return self;
}

- (instancetype)layoutTopEqualView:(UIView *)view constant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:constant];
    [self.superview addConstraint:layout];
    return self;
}

- (instancetype)layoutBottomEqualView:(UIView *)view constant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:constant];
    [self.superview addConstraint:layout];
    return self;
}

- (instancetype)layoutLelfEqualView:(UIView *)view constant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:constant];
    [self.superview addConstraint:layout];
    return self;
}

- (instancetype)layoutRightEqualView:(UIView *)view constant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeRight multiplier:1.0 constant:constant];
    [self.superview addConstraint:layout];
    return self;
}
// 水平方向间隔
- (instancetype)layoutHEqualView:(UIView *)view constant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:constant];
    [self.superview addConstraint:layout];
    return self;
}
// 垂直方向间隔
- (instancetype)layoutVEqualView:(UIView *)view constant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:constant];
    [self.superview addConstraint:layout];
    return self;
}
/// 水平方向居中对齐
- (instancetype)layoutHCenterEqualView:(UIView *)view constant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:constant];
    [self.superview addConstraint:layout];
    return self;
}
/// 垂直方向居中对齐
- (instancetype)layoutVCenterEqualView:(UIView *)view constant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:constant];
    [self.superview addConstraint:layout];
    return self;
}
// 等宽
- (instancetype)layoutWidthEqualView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    [self.superview addConstraint:layout];
    return self;
}
// 设置宽度
- (instancetype)layoutWidthEqualConstant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant];
    [self.superview addConstraint:layout];
    return self;
}
// 等高
- (instancetype)layoutHeightEqualView:(UIView *)view {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (view != self.superview) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    [self.superview addConstraint:layout];
    return self;
}
// 设置高度
- (instancetype)layoutHeightEqualConstant:(CGFloat)constant {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:constant];
    [self.superview addConstraint:layout];
    return self;
}
// 宽高比
- (instancetype)layoutWidthHeightRatio:(double)ratio {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:ratio constant:0];
    [self addConstraint:layout];
    return self;
}

@end
#import <objc/runtime.h>


@implementation UIView (Shadow)
- (void)setShadowStyle:(UIViewShadowStyle)shadowStyle {
    objc_setAssociatedObject(self, @selector(shadowStyle), @(shadowStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIViewShadowStyle)shadowStyle {
    return [objc_getAssociatedObject(self, @selector(shadowStyle)) integerValue];
}
    /// 添加单边阴影效果
- (void)addShadowColor:(UIColor *)theColor radius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    self.layer.shadowColor = theColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.07;
    self.layer.shadowRadius = 8;
    if (self.shadowStyle == UIViewShadowStyleTop) {
            // 单边阴影 顶边
        float shadowPathWidth = self.layer.shadowRadius;
        CGRect shadowRect = CGRectMake(0, 0-shadowPathWidth/2.0, self.bounds.size.width, shadowPathWidth);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
        self.layer.shadowPath = path.CGPath;
    } else if (self.shadowStyle == UIViewShadowStyleLeft) {
            // 单边阴影 顶边
        float shadowPathWidth = self.layer.shadowRadius;
        CGRect shadowRect = CGRectMake(0-shadowPathWidth/2.0, 0, shadowPathWidth, self.bounds.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
        self.layer.shadowPath = path.CGPath;
    } else if (self.shadowStyle == UIViewShadowStyleBottom) {
            // 单边阴影 顶边
        float shadowPathWidth = self.layer.shadowRadius;
        CGRect shadowRect = CGRectMake(0, self.bounds.size.height+shadowPathWidth/2.0, self.bounds.size.width, shadowPathWidth);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
        self.layer.shadowPath = path.CGPath;
    } else if (self.shadowStyle == UIViewShadowStyleRight) {
            // 单边阴影 顶边
        float shadowPathWidth = self.layer.shadowRadius;
        CGRect shadowRect = CGRectMake(self.bounds.size.width+shadowPathWidth/2.0, 0, shadowPathWidth, self.bounds.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowRect];
        self.layer.shadowPath = path.CGPath;
    }
}

@end
