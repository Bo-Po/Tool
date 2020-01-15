//
//  UIView+EFErrorView.m
//  Kada
//
//  Created by Alfred on 7/3/17.
//  Copyright (c) 2014 EF. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+EFErrorView.h"

static char kEFActionHandlerErrorViewKey;

@implementation UIView (EFErrorView)

- (EFErrorView *)gm_errorView {
    return objc_getAssociatedObject(self, &kEFActionHandlerErrorViewKey);
}

- (void)setErrorViewRefreshWithBlock:(void (^)(void))block
{
    EFErrorView *errorView = objc_getAssociatedObject(self, &kEFActionHandlerErrorViewKey);
    if (!errorView) {
        errorView = [[EFErrorView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        errorView.center = self.center;
        errorView.cp_x = 0;
        errorView.cp_y = 0;
        errorView.hidden = YES;
        errorView.clickBlock = block;
        errorView.backgroundColor = [UIColor clearColor];
        [self addSubview:errorView];
        objc_setAssociatedObject(self, &kEFActionHandlerErrorViewKey, errorView, OBJC_ASSOCIATION_RETAIN);
    }
}
- (void)layoutSubviews {
    EFErrorView *errorView = objc_getAssociatedObject(self, &kEFActionHandlerErrorViewKey);
    if (errorView) {
        errorView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }
}

- (BOOL)isShowingError
{
    EFErrorView *errorView = objc_getAssociatedObject(self, &kEFActionHandlerErrorViewKey);
    if (errorView) {
        return !errorView.hidden;
    }
    return NO;
}

- (void)showErrorViewWithErrorImage:(NSString *)imageName Title:(NSString *)title{
    [self showErrorViewWithErrorImage:imageName Title:title isAdaption:YES];
}

- (void)showErrorViewWithErrorImage:(NSString *)imageName Title:(NSString *)title isAdaption:(BOOL)isAdaption {
    EFErrorView *errorView = objc_getAssociatedObject(self, &kEFActionHandlerErrorViewKey);
    [self bringSubviewToFront:errorView];
    errorView.hidden = NO;
    [errorView setErrorTitle:title errorImage:[UIImage imageNamed:imageName] isAdaption:isAdaption];
}

- (void)showErrorView
{
    EFErrorView *errorView = objc_getAssociatedObject(self, &kEFActionHandlerErrorViewKey);
    [self bringSubviewToFront:errorView];
    errorView.hidden = NO;
}

-(void)bottomErroView{
    EFErrorView *errorView = objc_getAssociatedObject(self, &kEFActionHandlerErrorViewKey);
    [self insertSubview:errorView atIndex:0];

}

- (void)hideErrorView
{
    EFErrorView *errorView = objc_getAssociatedObject(self, &kEFActionHandlerErrorViewKey);
    [self sendSubviewToBack:errorView];
    errorView.hidden = YES;
}

@end
