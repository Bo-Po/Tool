//
//  SMPriceView.h
//  O
//
//  Created by 州龚 on 2019/12/3.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPNodeProgressBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface SMPriceView : UIView

@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, copy) NSArray *texts;

@property (nonatomic, copy) CPProgressControl didValueChangeControl;

/// 设置 颜色与字号
- (instancetype)setColor:(UIColor *)color font:(UIFont *)font;
/// 设置 bar的颜色
- (void)setDefaultColor:(UIColor *)defaultColor tintColor:(UIColor *)tintColor;
    /// 设置 节点外圈颜色
- (void)setControlBorderColor:(UIColor *)controlBorderColor;

@end

NS_ASSUME_NONNULL_END
