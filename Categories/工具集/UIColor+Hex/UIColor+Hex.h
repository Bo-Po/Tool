//
//  UIColor+UIColor_Hex.h
//  WI-FITool
//
//  Created by NTTData on 15/10/12.
//  Copyright (c) 2015年 NTTData. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
