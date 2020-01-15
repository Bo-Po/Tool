//
//  EFErrorView.h
//  haizeimi
//
//  Created by xiaoliZhang on 14-11-10.
//  Copyright (c) 2014年 antonyzhao. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *LOAD_EMPTY = @"load_empty";
static NSString *LOAD_FAILED = @"load_failed";

static NSString *LOAD_EMPTY_TITLE = @"暂无记录";
static NSString *LOAD_FAILED_TITLE = @"网络不给力";

@interface EFErrorView : UIView

@property (nonatomic, strong) void (^(clickBlock))(void);

- (void)setErrorTitle:(NSString *)title errorImage:(UIImage *)image isAdaption:(BOOL)isAdaption;

@end

