//
//  CPProgressBar.h
//  OCTest
//
//  Created by 陈波 on 2019/8/3.
//  Copyright © 2019 陈波. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPProgressBar : UIView

// 设置进度 (范围0～1)
@property (nonatomic, assign) CGFloat progress;
// 是否动画中
@property (nonatomic, readonly, assign) BOOL isAnim;

/// 设置 颜色与进度
- (instancetype)setDefaultColor:(UIColor *)defaultColor tintColor:(UIColor *)tintColor progress:(CGFloat)progress;
/// 设置 进度
- (void)setProgress:(CGFloat)progress animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
