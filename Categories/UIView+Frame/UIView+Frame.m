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

@end


static NSString *kViewLineShowLine = @"view_show_line";
static NSString *kViewLineLineLayer = @"view_line_layer";

@implementation UIView (Line)

@dynamic cp_showLine;
@dynamic cp_lineLayer;

- (void)setCp_showLine:(BOOL)cp_showLine {
    objc_setAssociatedObject(self, &kViewLineShowLine, @(cp_showLine), OBJC_ASSOCIATION_ASSIGN);
    if (!self.cp_lineLayer) {
        self.cp_lineLayer = [[CALayer alloc] init];
        [self layoutIfNeeded];
        [self setNeedsLayout];
        self.cp_lineLayer.frame = CGRectMake(0, self.cp_height-.25, self.cp_width, .5);
        self.cp_lineLayer.backgroundColor = kColor_Line.CGColor;
        [self.layer addSublayer:self.cp_lineLayer];
    }
    self.cp_lineLayer.hidden = !cp_showLine;
}

- (BOOL)isCp_showLine {
    return [objc_getAssociatedObject(self, &kViewLineShowLine) boolValue];
}

- (void)setCp_lineLayer:(CALayer *)cp_lineLayer {
    objc_setAssociatedObject(self, &kViewLineLineLayer, cp_lineLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CALayer *)cp_lineLayer {
    return objc_getAssociatedObject(self, &kViewLineLineLayer);
}

@end
