//
//  CALayer+Frame.m
//  ziyingshopping
//
//  Created by 州龚 on 2020/1/9.
//  Copyright © 2020 rzx. All rights reserved.
//

#import "CALayer+Frame.h"

@implementation CALayer (Frame)

@dynamic cp_top;
@dynamic cp_bottom;
@dynamic cp_left;
@dynamic cp_right;

@dynamic cp_x;
@dynamic cp_y;
@dynamic cp_origin;

@dynamic cp_width;
@dynamic cp_height;
@dynamic cp_size;

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
