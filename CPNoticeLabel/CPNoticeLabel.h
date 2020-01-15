//
//  CPNoticeLabel.h
//  OCTest
//
//  Created by 陈波 on 2019/8/12.
//  Copyright © 2019 陈波. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPNoticeLabel : UIView

// 设置标题
@property (nonatomic, copy) NSArray<NSString *> *titles;
// 设置显示的标题的索引
@property (nonatomic, assign) CGFloat index;
// 设置滚动时间间隔
@property (nonatomic, assign) CGFloat delay;
// 设置滚动持续时间
@property (nonatomic, assign) CGFloat duration;
// 设置点击回调
@property (nonatomic, copy) CPClickButton tapBlock;
// 是否滚动中
@property (nonatomic, assign, readonly) BOOL isAnimation;

// 设置字体相关
@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIFont *textFont;

- (instancetype)initWithFrame:(CGRect)frame titles:(nullable NSArray<NSString *> *)titles;

@end

NS_ASSUME_NONNULL_END
