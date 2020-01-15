//
//  CPToastView.m
//  O
//
//  Created by 州龚 on 2019/9/17.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import "CPToastView.h"

#ifndef PrefixHeader_pch
#import "CPSpotLoadView.h"
#import "CPInsetsLabel.h"

#define App_Delegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define App_Window (App_Delegate.window)

#define isPhoneX ({\
BOOL isX = NO;\
if (@available(iOS 11.0, *)) {\
if (!UIEdgeInsetsEqualToEdgeInsets([UIApplication sharedApplication].delegate.window.safeAreaInsets, UIEdgeInsetsZero)) {\
isX = YES;\
}\
}\
isX;\
})

#define Size_ScreenWidth ([[UIScreen mainScreen]bounds].size.width)
#define Size_ScreenHeight ([[UIScreen mainScreen]bounds].size.height)

#endif

@implementation CPToastView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */
+ (void)showMessage:(NSString *)msg {
    [self showMessage:msg exist:2. position:CPToastCenter];
}
+ (void)showMessage:(NSString *)msg position:(CPToastPosition)position {
    [self showMessage:msg exist:2. position:position];
}
+ (void)showMessage:(NSString *)msg exist:(CGFloat)duration {
    [self showMessage:msg exist:duration position:CPToastCenter];
}
+ (void)showMessage:(NSString *)msg exist:(CGFloat)duration position:(CPToastPosition)position {
    if (!msg) { return; }
    App_Window;
    NSLog(@" subview = %@ ", App_Window.subviews);
    __block CPInsetsLabel *lab = [[CPInsetsLabel alloc] init];
    lab.textInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15.];
    lab.text = msg;
    lab.textColor = UIColor.whiteColor;
    lab.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 5.;
    CGSize size = [lab sizeThatFits:CGSizeMake(Size_ScreenWidth - 150, 10000)];
    lab.bounds = CGRectMake(0, 0, size.width, size.height);
    CGFloat y = 0;
    if (position == CPToastCenter) {
        y = Size_ScreenHeight/2.;
    } else if (position == CPToastTop) {
        y = 80+size.height/2.;
        if (isPhoneX) {
            y += 24;
        }
    } else if (position == CPToastBottom) {
        y = Size_ScreenHeight-(30+size.height/2.);
        if (isPhoneX) {
            y -= 34;
        }
    }
    lab.center = CGPointMake(Size_ScreenWidth/2., y);
    [App_Window addSubview:lab];
    NSLog(@"1 subview = %@ ", App_Window.subviews);
    
    if (duration != 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [lab removeFromSuperview];
        });
    }
}

@end
