//
//  CPInsetsLabel.h
//  Guoan_centralized_office
//
//  Created by mac on 2018/10/12.
//  Copyright © 2018年 GM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    CPVerticalAlignmentTop,
    CPVerticalAlignmentMiddle,
    CPVerticalAlignmentBottom,
} CPVerticalAlignment;

@interface CPInsetsLabel : UILabel

/// 控制字体与控件边界的间距
@property (nonatomic) UIEdgeInsets textInsets;
@property (nonatomic, assign) IBInspectable CPVerticalAlignment textVerticalAlignment;

@end
