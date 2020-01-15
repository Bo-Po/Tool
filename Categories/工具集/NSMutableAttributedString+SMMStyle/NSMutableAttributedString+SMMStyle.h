//
//  NSMutableAttributedString+SMMStyle.h
//  ziyingshopping
//
//  Created by 州龚 on 2019/12/6.
//  Copyright © 2019 rzx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (SMMStyle)

    /// 添加行间距
- (instancetype)attributedStringSpacingRow:(CGFloat)spacing;
- (instancetype)attributedStringSpacingRow:(CGFloat)spacing alignment:(NSString * _Nullable)alignment;
/// 添加删除线
- (instancetype)attributedStringAddDeleteLine:(NSString * _Nullable)deleteString color:(UIColor * _Nullable)color;
    /// 添加下划线
- (instancetype)attributedStringAddBottomLine:(NSString * _Nullable)string color:(UIColor * _Nullable)color;

@end

NS_ASSUME_NONNULL_END
