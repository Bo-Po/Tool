//
//  CPNodeProgressBar.h
//  O
//
//  Created by 州龚 on 2019/12/2.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPNodeProgressBar : UIView

    // 设置进度 (范围0～1)
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) int nodeNumber;
    // 是否动画中
@property (nonatomic, readonly, assign) BOOL isAnim;

    // 是否可拖动控制进度 默认为NO
@property (nonatomic, readwrite, assign) BOOL useControl;
@property (nonatomic, strong) UIColor *controlBorderColor;
    //可拖动控制进度 结束回调
@property (nonatomic, copy) CPProgressControl touchDownControl;
@property (nonatomic, copy) CPProgressControl touchUpControl;


    /// 设置 颜色与进度
- (instancetype)setDefaultColor:(UIColor *)defaultColor tintColor:(UIColor *)tintColor progress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
