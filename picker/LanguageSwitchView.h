//
//  LanguageSwitchView.h
//  TranslateDemoIOS
//
//  Created by NTTData on 16/3/25.
//  Copyright © 2016年 NTTData. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LanguageSwitchViewDelegate;

typedef NS_ENUM(NSInteger, LanguageSwitchViewStyle) {
    LanguageSwitchViewStyleDefault = 0,
    LanguageSwitchViewStyleSwitch,
    LanguageSwitchViewStyleChoose = LanguageSwitchViewStyleDefault
};

/*!
 @class      LanguageSwitchView
 @superclass    UIView
 @abstract      选择器视图
 @discussion    多列选择视图
 */
@interface LanguageSwitchView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, nonnull) NSArray *data;
@property (nonatomic, assign) LanguageSwitchViewStyle style;
@property (nullable, nonatomic,weak) id<LanguageSwitchViewDelegate> delegate;
@property (nullable, nonatomic) NSArray *selectData;
@property (assign, nonatomic) BOOL isBackgroundClick;
@property (assign, nonatomic) BOOL isShowToolBar;
@property (strong, nonatomic, nullable) NSString *title;
@property (strong, nonatomic, nonnull) UIPickerView *picker;

@property (strong, nonatomic, nullable) NSDate *minTime;


- (nonnull instancetype)initWithFrame:(CGRect)frame data:(nullable NSArray *)data pickerStyle:(LanguageSwitchViewStyle)style;

@end

@protocol LanguageSwitchViewDelegate <NSObject>

@optional
/*!
 @method        LanguageSwitchView:changeValue:
 @abstract      languageSwitchView 的value改变后回执
 @discussion    languageSwitchView 的value改变后回执
 @param         languageSwitchView 选择器实例
 @param         selectData 改变后的value
 */
- (void)LanguageSwitchView:(nonnull LanguageSwitchView *)languageSwitchView changeValue:(nonnull NSArray *)selectData;
/*!
 @method        cancelLanguageSwitchView:
 @abstract      点击取消的回执
 @discussion    点击取消的回执
 @param         languageSwitchView 选择器实例
 */
- (void)cancelLanguageSwitchView:(nonnull LanguageSwitchView *)languageSwitchView;
/*!
 @method        LanguageSwitchView:doneSwith:
 @abstract      点击确定的回执
 @discussion    点击取消的回执
 @param         languageSwitchView 选择器实例
 @param         selectData 完成时所选的value
 */
- (void)LanguageSwitchView:(nonnull LanguageSwitchView *)languageSwitchView doneSwith:(nonnull NSArray *)selectData;

@end
