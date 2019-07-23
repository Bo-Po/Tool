//
//  CPTabbarController.h
//  IM
//
//  Created by jam on 2017/7/19.
//  Copyright © 2017年 VRV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPTabBar.h"

@interface CPTabbarController : UITabBarController

@property (assign, nonatomic) BOOL hidenTopLine;
@property (assign, nonatomic) BOOL showShadow;

- (void)setBigItem:(int)index;
- (void)setBigItem:(int)index offset:(CGFloat)offset;

@end
