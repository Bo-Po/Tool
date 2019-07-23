//
//  CPTabbarController.m
//  IM
//
//  Created by jam on 2017/7/19.
//  Copyright © 2017年 VRV. All rights reserved.
//

#import "CPTabbarController.h"
#import "CPTabBar.h"

#ifndef SCR_W
#define SCR_W [UIScreen mainScreen].bounds.size.width
#endif
#ifndef SCR_H
#define SCR_H [UIScreen mainScreen].bounds.size.height
#endif

@interface CPTabbarController ()<UITabBarControllerDelegate,CPTabBarDelegate> {
    int _index;
    CGFloat _offset;
    UIImage *_barShadowImage;
    UIImage *_barBackgroundImage;
}


@end

@implementation CPTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];

    CPTabBar *tabbar = [[CPTabBar alloc] init];
    tabbar.myDelegate = self;
    [tabbar setBigItem:_index];
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
    [[CPTabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [CPTabBar appearance].translucent = NO;
    
}

- (void)setBigItem:(int)index {
    _index = index;
    [(CPTabBar *)self.tabBar setBigItem:index];
}
- (void)setBigItem:(int)index offset:(CGFloat)offset {
    _index = index;
    _offset = offset;
    [(CPTabBar *)self.tabBar setBigItem:index offset:offset];
}

- (void)setHidenTopLine:(BOOL)hidenTopLine {
    if (_hidenTopLine == hidenTopLine) {
        return;
    }
    _hidenTopLine = hidenTopLine;
    if (_hidenTopLine) {
        _barShadowImage = self.tabBar.shadowImage;
        _barBackgroundImage = self.tabBar.backgroundImage;
        self.tabBar.shadowImage = [UIImage new];
        self.tabBar.backgroundImage = [UIImage new];
    } else {
        self.tabBar.shadowImage = _barShadowImage;
        self.tabBar.backgroundImage = _barBackgroundImage;
    }
}
- (void)setShowShadow:(BOOL)showShadow {
    if (_showShadow == showShadow) {
        return;
    }
    _showShadow = showShadow;
    ((CPTabBar *)self.tabBar).showShadow = _showShadow;
}

#pragma mark -- UITabbarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
