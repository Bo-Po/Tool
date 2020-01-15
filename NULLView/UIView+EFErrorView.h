//
//  UIView+EFErrorView.h
//  Kada
//
//  Created by Alfred on 7/3/17.
//  Copyright (c) 2014 EF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFErrorView.h"

/**
 *
 * @version   [1.0]
 * @update    [2014-09-02 16:21:54]
 * @author    [Antony]
 * @brief     [show errorView with tap Block]
 *
 */


@interface UIView (EFErrorView)

/**
 *  Attaches the given block for error view failed to load
 *
 *  @param block
 */
- (void)setErrorViewRefreshWithBlock:(void (^)(void))block;

/**
 *  show error view
 */
- (void)showErrorView;
/**
 *  show error view title  image
 */
- (void)showErrorViewWithErrorImage:(NSString *)imageName Title:(NSString *)title;
- (void)showErrorViewWithErrorImage:(NSString *)imageName Title:(NSString *)title isAdaption:(BOOL)isAdaption;
/**
 *  hide error view
 */
- (void)hideErrorView;

- (void)bottomErroView;

/**
 errorView

 @return errorView
 */
- (EFErrorView *)gm_errorView;
@end
