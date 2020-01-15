//
//  UIView+Frame.h
//  TianjinTrip
//
//  Created by Mac on 2017/10/23.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (assign, nonatomic) CGFloat    cp_top;
@property (assign, nonatomic) CGFloat    cp_bottom;
@property (assign, nonatomic) CGFloat    cp_left;
@property (assign, nonatomic) CGFloat    cp_right;

@property (assign, nonatomic) CGFloat    cp_x;
@property (assign, nonatomic) CGFloat    cp_y;
@property (assign, nonatomic) CGPoint    cp_origin;

@property (assign, nonatomic) CGFloat    cp_centerX;
@property (assign, nonatomic) CGFloat    cp_centerY;

@property (assign, nonatomic) CGFloat    cp_width;
@property (assign, nonatomic) CGFloat    cp_height;
@property (assign, nonatomic) CGSize     cp_size;

/// 边框
@property (assign, nonatomic) IBInspectable CGFloat    cp_borderWidth;
@property (strong, nonatomic) IBInspectable UIColor    *cp_borderColor;
/// 阴影
@property (assign, nonatomic) IBInspectable CGFloat    cp_cornerRadius;
@property (strong, nonatomic) IBInspectable UIColor    *cp_shadowColor;
@property (assign, nonatomic) IBInspectable CGFloat     cp_shadowRadius;
@property (nonatomic)              IBInspectable  CGSize     cp_shadowOffset;
@property (assign, nonatomic) IBInspectable CGFloat     cp_shadowOpacity;

@end
