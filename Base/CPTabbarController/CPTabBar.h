//
//  CPTabBar.h
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef SCR_W
#define SCR_W [UIScreen mainScreen].bounds.size.width
#endif
#ifndef SCR_H
#define SCR_H [UIScreen mainScreen].bounds.size.height
#endif
#ifndef isIphoneX
#define isIphoneX ({\
BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
if (!UIEdgeInsetsEqualToEdgeInsets([UIApplication sharedApplication].delegate.window.safeAreaInsets, UIEdgeInsetsZero)) {\
isPhoneX = YES;\
}\
}\
isPhoneX;\
})
#endif

@class CPTabBar;

@protocol CPTabBarDelegate <NSObject>
@optional
- (void)tabBarPlusBtnClick:(CPTabBar *)tabBar;
@end

typedef enum : NSUInteger {
    CPBarStyleDefault = 0,
    CPBarStyleSystem,
} CPBarStyle;

@interface CPTabBar : UITabBar

/** tabbar的代理 */
@property (nonatomic, weak) id<CPTabBarDelegate> myDelegate;
@property (nonatomic, assign) BOOL showShadow;
@property (nonatomic, assign) CPBarStyle style;


- (void)setBigItem:(int)index;
- (void)setBigItem:(int)index offset:(CGFloat)offset;

@end


