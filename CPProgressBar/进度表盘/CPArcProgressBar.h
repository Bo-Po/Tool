//
//  CPArcProgressBar.h
//  O
//
//  Created by 州龚 on 2019/9/19.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPArcProgressBar : UIView

@property (nonatomic, assign) CGFloat percent;  // 进度

@property (nonatomic, assign) CGFloat circelDiameter; //圆直径
@property (nonatomic, assign) CGFloat lineWidth; // 弧线宽度
@property (nonatomic, assign) CGFloat stareAngle; // 开始角度
@property (nonatomic, assign) CGFloat endAngle; // 结束角度

// 刻度的相关的控制
@property (nonatomic, assign) BOOL showDial; // if ture 则显示刻度盘
@property (nonatomic) UIColor *dialHighlightedColor; // showDial is ture 则刻度盘点亮时的颜色



@property (nonatomic, assign) CGFloat minValue; // 最大值
@property (nonatomic, assign) CGFloat maxValue; // 最小值

@property (nonatomic, copy) NSString *title;
@property (nonatomic) UIColor *titleColor;

@end

NS_ASSUME_NONNULL_END
