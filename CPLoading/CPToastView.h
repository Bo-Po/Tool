//
//  CPToastView.h
//  O
//
//  Created by 州龚 on 2019/9/17.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    CPToastCenter = 0,
    CPToastTop,
    CPToastBottom,
} CPToastPosition;

@interface CPToastView : UIView


+ (void)showMessage:(NSString *)msg;
+ (void)showMessage:(NSString *)msg position:(CPToastPosition)position;
+ (void)showMessage:(NSString *)msg exist:(CGFloat)duration;
+ (void)showMessage:(NSString *)msg exist:(CGFloat)duration position:(CPToastPosition)position;

@end

NS_ASSUME_NONNULL_END
