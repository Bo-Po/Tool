//
//  UIView+Frame.m
//  TianjinTrip
//
//  Created by Mac on 2017/10/23.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

@dynamic cp_top;
@dynamic cp_bottom;
@dynamic cp_left;
@dynamic cp_right;

@dynamic cp_width;
@dynamic cp_height;

@dynamic cp_size;

@dynamic cp_x;
@dynamic cp_y;

- (CGFloat)cp_top {
    return self.frame.origin.y;
}

- (void)setCp_top:(CGFloat)cp_top {
    CGRect frame = self.frame;
    frame.origin.y = cp_top;
    self.frame = frame;
}

- (CGFloat)cp_left {
    return self.frame.origin.x;
}

- (void)setCp_left:(CGFloat)cp_left {
    CGRect frame = self.frame;
    frame.origin.x = cp_left;
    self.frame = frame;
}

- (CGFloat)cp_bottom {
    return self.frame.size.height + self.frame.origin.y;
}

- (void)setCp_bottom:(CGFloat)cp_bottom {
    CGRect frame = self.frame;
    frame.origin.y = cp_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)cp_right {
    return self.frame.size.width + self.frame.origin.x;
}

- (void)setCp_right:(CGFloat)cp_right {
    CGRect frame = self.frame;
    frame.origin.x = cp_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)cp_x {
    return self.frame.origin.x;
}

- (void)setCp_x:(CGFloat)cp_x {
    CGRect frame = self.frame;
    frame.origin.x = cp_x;
    self.frame = frame;
}

- (CGFloat)cp_y {
    return self.frame.origin.y;
}

- (void)setCp_y:(CGFloat)cp_y {
    CGRect frame = self.frame;
    frame.origin.y = cp_y;
    self.frame = frame;
}

- (CGPoint)cp_origin {
    return self.frame.origin;
}

- (void)setCp_origin:(CGPoint)cp_origin {
    CGRect frame = self.frame;
    frame.origin = cp_origin;
    self.frame = frame;
}

- (CGFloat)cp_centerX {
    return self.center.x;
}

- (void)setCp_centerX:(CGFloat)cp_centerX {
    CGPoint center = self.center;
    center.x = cp_centerX;
    self.center = center;
}

- (CGFloat)cp_centerY {
    return self.center.y;
}

- (void)setCp_centerY:(CGFloat)cp_centerY {
    CGPoint center = self.center;
    center.y = cp_centerY;
    self.center = center;
}

- (CGFloat)cp_width {
    return self.frame.size.width;
}

- (void)setCp_width:(CGFloat)cp_width {
    CGRect frame = self.frame;
    frame.size.width = cp_width;
    self.frame = frame;
}

- (CGFloat)cp_height {
    return self.frame.size.height;
}

- (void)setCp_height:(CGFloat)cp_height {
    CGRect frame = self.frame;
    frame.size.height = cp_height;
    self.frame = frame;
}

- (CGSize)cp_size {
    return self.frame.size;
}

- (void)setCp_size:(CGSize)cp_size {
    CGRect frame = self.frame;
    frame.size = cp_size;
    self.frame = frame;
}

- (void)setCp_borderColor:(UIColor *)cp_borderColor {
    self.layer.borderColor = cp_borderColor.CGColor;
}
- (UIColor *)cp_borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}
- (void)setCp_borderWidth:(CGFloat)cp_borderWidth {
    self.layer.borderWidth = cp_borderWidth;
}
- (CGFloat)cp_borderWidth {
    return self.layer.borderWidth;
}
- (void)setCp_cornerRadius:(CGFloat)cp_cornerRadius {
    self.layer.cornerRadius = cp_cornerRadius;
}
- (CGFloat)cp_cornerRadius {
    return self.layer.cornerRadius;
}
- (void)setCp_shadowColor:(UIColor *)cp_shadowColor {
    self.layer.shadowColor = cp_shadowColor.CGColor;
}
- (UIColor *)cp_shadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}
- (void)setCp_shadowOffset:(CGSize)cp_shadowOffset {
    self.layer.shadowOffset = cp_shadowOffset;
}
- (CGSize)cp_shadowOffset {
    return self.layer.shadowOffset;
}
- (void)setCp_shadowRadius:(CGFloat)cp_shadowRadius {
    self.layer.shadowRadius = cp_shadowRadius;
}
- (CGFloat)cp_shadowRadius {
    return self.layer.shadowRadius;
}
- (void)setCp_shadowOpacity:(CGFloat)cp_shadowOpacity {
    self.layer.shadowOpacity = cp_shadowOpacity;
}
- (CGFloat)cp_shadowOpacity {
    return self.layer.shadowOpacity;
}

@end
