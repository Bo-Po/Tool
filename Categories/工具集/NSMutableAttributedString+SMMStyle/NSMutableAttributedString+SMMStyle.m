//
//  NSMutableAttributedString+SMMStyle.m
//  ziyingshopping
//
//  Created by 州龚 on 2019/12/6.
//  Copyright © 2019 rzx. All rights reserved.
//

#import "NSMutableAttributedString+SMMStyle.h"

@implementation NSMutableAttributedString (SMMStyle)

    /// 添加行间距
- (instancetype)attributedStringSpacingRow:(CGFloat)spacing {
    [self attributedStringSpacingRow:spacing alignment:nil];
    return self;
}
- (instancetype)attributedStringSpacingRow:(CGFloat)spacing alignment:(NSString * _Nullable)alignment {
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = spacing;
    if (alignment) {
        paragraph.alignment = [alignment integerValue];
    }
    [self addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, self.length)];
    return self;
}
    /// 添加删除线
- (instancetype)attributedStringAddDeleteLine:(NSString * _Nullable)deleteString color:(UIColor * _Nullable)color {
    NSRange rangel;
    if (deleteString) {
        rangel = [[self string] rangeOfString:deleteString];
    } else {
        rangel = NSMakeRange(0, self.length);
    }
    [self addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:rangel];
    if (color) {
        [self addAttribute:NSStrikethroughColorAttributeName value:color range:rangel];
    }
    return self;
}
    /// 添加下划线
- (instancetype)attributedStringAddBottomLine:(NSString * _Nullable)string color:(UIColor * _Nullable)color {
        //设置下划线...
    /*
     NSUnderlineStyleNone                                    = 0x00, 无下划线
     NSUnderlineStyleSingle                                  = 0x01, 单行下划线
     NSUnderlineStyleThick NS_ENUM_AVAILABLE(10_0, 7_0)      = 0x02, 粗的下划线
     NSUnderlineStyleDouble NS_ENUM_AVAILABLE(10_0, 7_0)     = 0x09, 双下划线
     */
    NSRange rangel;
    if (string) {
        rangel = [[self string] rangeOfString:string];
    } else {
        rangel = NSMakeRange(0, self.length);
    }
    [self addAttribute:NSUnderlineStyleAttributeName
                      value:@(NSUnderlineStyleSingle)
                      range:rangel];
        //设置下划线颜色...
    [self addAttribute:NSUnderlineColorAttributeName value:color range:rangel];
    return self;
}
@end
