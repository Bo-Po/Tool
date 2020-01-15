//
//  CPInsetsTextField.m
//  XZOnLive
//
//  Created by 州龚 on 2019/10/16.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import "CPInsetsTextField.h"

@implementation CPInsetsTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    if (self.placeholderColor) {
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.placeholder attributes:
                                          @{NSForegroundColorAttributeName:self.placeholderColor,
                                            NSFontAttributeName:self.font
                                            }];
        self.attributedPlaceholder = attrString;
    }
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    if (_placeholderColor == placeholderColor) {
        return;
    }
    _placeholderColor = placeholderColor;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.placeholder attributes:
  @{NSForegroundColorAttributeName:_placeholderColor,
    NSFontAttributeName:self.font
    }];
    self.attributedPlaceholder = attrString;
}
//    //控制placeHolder的位置
//- (CGRect)placeholderRectForBounds:(CGRect)bounds {
//    UIEdgeInsets insets = _textInsets;
//    CGRect rect = [super placeholderRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)];
//
////    rect.origin.x    -= insets.left;
////    rect.origin.y    -= insets.top;
////    rect.size.width  += (insets.left + insets.right);
////    rect.size.height += (insets.top + insets.bottom);
//    return rect;
//}

    //控制显示文本的位置
-(CGRect)textRectForBounds:(CGRect)bounds {
    UIEdgeInsets insets = _textInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)];
    
//    rect.origin.x    -= insets.left;
//    rect.origin.y    -= insets.top;
//    rect.size.width  += (insets.left + insets.right);
//    rect.size.height += (insets.top + insets.bottom);
    return rect;
}

    //控制编辑文本的位置
-(CGRect)editingRectForBounds:(CGRect)bounds {
    UIEdgeInsets insets = _textInsets;
    CGRect rect = [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)];
    
//    rect.origin.x    -= insets.left;
//    rect.origin.y    -= insets.top;
//    rect.size.width  += (insets.left + insets.right);
//    rect.size.height += (insets.top + insets.bottom);
    return rect;
}

@end
