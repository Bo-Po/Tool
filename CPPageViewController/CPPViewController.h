//
//  CPViewController.h
//  OCTest
//
//  Created by 陈波 on 2019/7/24.
//  Copyright © 2019 陈波. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPPViewController : UIViewController

@property (nonatomic, assign) CGFloat pageSpacing;
@property (nonatomic, assign) UIPageViewControllerTransitionStyle pageStyle;
@property (nonatomic, assign) UIPageViewControllerNavigationOrientation navigationOrientation;


@property (nonatomic, copy) NSArray<UIViewController *> *viewControllers;

@end

NS_ASSUME_NONNULL_END
