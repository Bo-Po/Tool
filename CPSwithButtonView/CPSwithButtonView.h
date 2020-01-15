//
//  SHSSwithButtonView.h
//  ykhApp
//
//  Created by ntt on 15/3/3.
//  Copyright (c) 2015年 shs. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef BUTTON_TAG
#define BUTTON_TAG   10000

#define kCPSButtonNormalImage @"kCPSButtonNormalImage"
#define kCPSButtonSelectedImage @"kCPSButtonSelectedImage"

#endif

/*!
 @protocol      CPSwithButtonDelegate
 @superclass    NSObject
 @abstract      tab控件代理
 @discussion    实现了点击tab事件的方法代理
 */
@protocol CPSwithButtonDelegate <NSObject>

@required
/*!
 @method        didTappedButton:
 @abstract      点击事件
 @discussion    实现点击tab的事件，响应自己的实现
 @param         tag 点击tab的Index
 */
- (void)didTappedButton:(NSInteger)tag;

@end

typedef enum : NSUInteger {
    CPSwithButtonTypeDefault = 0,
    CPSwithButtonTypeFixed = CPSwithButtonTypeDefault,
    CPSwithButtonTypeScroll,
    CPSwithButtonTypeAlignmentBothEnds,
} CPSwithButtonType;

/*!
 @class         CPSwithButtonView
 @superclass    UIView
 @abstract      tab控件
 @discussion    用于一个页面有多个tab的选择
 */
@interface CPSwithButtonView : UIView
{
    /*! @var    _lineView 下侧滑动线 */
    UIView *_lineView;
    /*! @var    _color_default 默认颜色 */
    UIColor *_color_default;
    /*! @var    _color_selected 选中的颜色 */
    UIColor *_color_selected;
}

@property (nonatomic, copy) CPClickButton didTappedButton;
@property (nonatomic, assign) CPSwithButtonType type;
@property (nonatomic, assign) BOOL lineIsFixedWidth;
@property (nonatomic, assign) BOOL permitirVariasTap;
@property (nonatomic, assign) CGFloat paddingH;
@property (nonatomic, copy) NSArray <NSNumber *>*excludes;

/*!
 @method        createSwithButton:
 @abstract      创建tab
 @discussion    用于创建tab
 @param         num tab总数
 @param         font tab标题字体
 */
- (void)createSwithButton:(NSArray *)num font:(UIFont *)font defaultColor:(UIColor *)defaultColor selectedColor:(UIColor *)selectedColor;
- (void)setButtonTitles:(NSArray <NSString *>*)titles;
- (void)setButtonImages:(NSArray <NSDictionary <NSString *, id>*>*)images transverse:(int) transverse;
// 单独设置选中文字字体
- (void)setSelectedFont:(UIFont *)selectedFont;
// 设置下划线颜色
- (void)setLineColor:(UIColor *)color;
- (void)setLineGradientColor:(CAGradientLayer *)gradientColor;
- (void)setLineOffset:(UIEdgeInsets)edge;
- (void)setLineHeight:(CGFloat)height;
- (void)setLineSize:(CGSize)size;

/*! @property    delegate 控件代理 */
@property (nonatomic,weak) IBOutlet id<CPSwithButtonDelegate> delegate;
/*! @property    buttons 标题按钮 */
@property (nonatomic,readonly) NSMutableArray *buttons;
/*! @property    selectedAtIndex 选中的索引 */
@property (nonatomic,assign) NSInteger selectedAtIndex;

@end
