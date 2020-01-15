//
//  CPInsetsLabel.m
//  Guoan_centralized_office
//
//  Created by mac on 2018/10/12.
//  Copyright © 2018年 GM. All rights reserved.
//

#import "CPInsetsLabel.h"

@implementation CPInsetsLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

- (instancetype)init {
    if (self = [super init]) {
        _textInsets = UIEdgeInsetsZero;
        _textVerticalAlignment = CPVerticalAlignmentMiddle;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textInsets = UIEdgeInsetsZero;
        _textVerticalAlignment = CPVerticalAlignmentMiddle;
    }
    return self;
}

- (void)setTextVerticalAlignment:(CPVerticalAlignment)textVerticalAlignment {
    _textVerticalAlignment = textVerticalAlignment;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    UIEdgeInsets insets = _textInsets;
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, insets)
                    limitedToNumberOfLines:numberOfLines];
    
    switch (self.textVerticalAlignment) {
            
        case CPVerticalAlignmentTop:
            
            rect.origin.y = bounds.origin.y;
            
            break;
            
        case CPVerticalAlignmentBottom:
            
            rect.origin.y = bounds.origin.y + bounds.size.height - rect.size.height;
            
            break;
            
        case CPVerticalAlignmentMiddle:
            
                // Fall through.
            
        default:
            
            rect.origin.y = bounds.origin.y + (bounds.size.height - rect.size.height) / 2.0;
            
    }
    
    rect.origin.x    -= insets.left;
    rect.origin.y    -= insets.top;
    rect.size.width  += (insets.left + insets.right);
    rect.size.height += (insets.top + insets.bottom);
    
    return rect;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _textInsets)];
}

@end
