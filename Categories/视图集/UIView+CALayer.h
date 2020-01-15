//
//  UIView+CALayer.h
//  shangmen
//
//  Created by 州龚 on 2019/11/20.
//  Copyright © 2019 rzx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CPGradientDirectionHorizontal = 0,
    CPGradientDirectionVertical,
    CPGradientDirectionOblique
} CPGradientDirection;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CALayer)

@property (nonatomic, copy) CAGradientLayer *gradientLayer; // 渐变色图层
@property (nonatomic, strong) CAGradientLayer *textGradientLayer; // 渐变字体图层
@property (nonatomic, assign) CPGradientDirection textGradientDirection; // 文字渐变方向
/// 显示下线条
@property (assign, nonatomic ,getter=isCp_showLine) BOOL    cp_showLine;
@property (strong, nonatomic) CALayer    *cp_lineLayer;

// 设置图片数组
@property (nonatomic, copy, nullable) NSArray <UIImage *>*images;
@property (nonatomic, copy) NSArray *imageUrls;

    //将layer转成UIImage
+ (UIImage *)imageFormLayer:(CALayer *)layer;
+ (UIImage *)imageFormLayer:(CALayer *)layer scale:(CGFloat)scale;

@end

NS_ASSUME_NONNULL_END
