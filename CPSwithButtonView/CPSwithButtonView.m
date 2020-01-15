//
//  SHSSwithButtonView.m
//  ykhApp
//
//  Created by ntt on 15/3/3.
//  Copyright (c) 2015年 shs. All rights reserved.
//

#import "CPSwithButtonView.h"

@interface CPSwithButtonView () {
    UIFont *_font_default;
    UIFont *_font_selected;
    UIColor *_color_line;
    NSArray *_titles;
    UIEdgeInsets _lineOffset;
    CGFloat _line_height;
    CGSize _line_size;
    CAGradientLayer *_line_gradient;
}

@property (nonatomic, strong) UIScrollView *cp_scroll;

@end

@implementation CPSwithButtonView
CGFloat lineWidth, spacing;

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _color_default = UIColor.whiteColor;
        _color_selected = UIColor.whiteColor;
        self.type = CPSwithButtonTypeDefault;
        _lineOffset = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _color_default = UIColor.whiteColor;
        _color_selected = UIColor.whiteColor;
        self.type = CPSwithButtonTypeDefault;
        _lineOffset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)setButtonTitles:(NSArray <NSString *>*)titles {
    if (self) {
        NSArray *btns;
        if (self.type == CPSwithButtonTypeScroll) {
            btns = [self.cp_scroll subviews];
        } else {
            btns = [self subviews];
        }
        for (UIView *view in btns) {
            [view removeFromSuperview];
        }
    }
    if (titles.count == 0) {
        return;
    }
    
    // 数组的初始化
    _buttons = [[NSMutableArray alloc] initWithCapacity:0];
    // 设定按钮左右边距
    if (titles.count < 4) {
        spacing = 10.0;
        lineWidth = 10.0;
    } else {
        spacing = 10.0;
        lineWidth = 10.0;
    }
    if (self.paddingH != 0.) {
        spacing = self.paddingH;
    }
    // 计算按钮最大宽度
    CGFloat btnWidth = (self.cp_width - spacing * 2) / titles.count;
    CGFloat totalX = spacing;
    CGFloat fristWidth = 0.;
    // 添加按钮
    for (int i=0; i<titles.count ; i++) {
        if (self.type == CPSwithButtonTypeScroll) {
            CGSize size = [titles[i] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:_font_selected?:_font_default, NSFontAttributeName, nil]];
            //            CGSize size = [num[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil].size;
            btnWidth = size.width + spacing * 2;
        }
        // 初始化按钮
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(totalX, 10, btnWidth, 20)];
        if (i == self.selectedAtIndex) {
            [btn setTitleColor:_color_selected forState:UIControlStateNormal];
            if (!self.permitirVariasTap) {
                btn.userInteractionEnabled = !YES;
            }
            btn.titleLabel.font = _font_selected;
        } else {
            [btn setTitleColor:_color_default forState:UIControlStateNormal];
            btn.userInteractionEnabled = YES;
            btn.titleLabel.font = _font_default;
        }
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self  action:@selector(tapButton:) forControlEvents:1<<6];
        btn.tag = BUTTON_TAG + i;
        // 把按钮添加到数组里，以便调用方设置
        [self.buttons addObject:btn];
        if (self.type == CPSwithButtonTypeAlignmentBothEnds) {
            if (i == 0) {
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            } else if (i == titles.count-1) {
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            }
        }
        // 把按钮显示到画面上
        if (self.type == CPSwithButtonTypeScroll) {
            [self addSubview:self.cp_scroll];
            [self.cp_scroll addSubview:btn];
        } else {
            [self addSubview:btn];
        }
        totalX += btnWidth;
        if (i == 0) {
            fristWidth = btnWidth;
        }
    }
    btnWidth = fristWidth;
    
    // 添加下侧滑动线
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(spacing + lineWidth+_lineOffset.left, self.cp_height-(_line_height?:3)+_lineOffset.top, btnWidth - lineWidth * 2-(_lineOffset.left+_lineOffset.right), _line_height?:3)];
        _lineView.gradientLayer = _line_gradient;
    }
    if (!CGSizeEqualToSize(_line_size, CGSizeZero)) {
        UIButton *btn = [self.buttons firstObject];
        _lineView.bounds = CGRectMake(0, 0, _line_size.width, _line_size.height);
        _lineView.center = CGPointMake(btn.cp_centerX, self.cp_height-(_line_height?:3)/2.+_lineOffset.top);
    }
    // 设置背景颜色为蓝色（2CA1F9）
    _lineView.backgroundColor = _color_line?:_color_selected;
    if (self.type == CPSwithButtonTypeScroll) {
        self.cp_scroll.contentSize = CGSizeMake(totalX + spacing, 0);
        [self.cp_scroll addSubview:_lineView];
    } else {
        [self addSubview:_lineView];
    }
    [_lineView.superview sendSubviewToBack:_lineView];
    
}
- (void)setButtonImages:(NSArray <NSDictionary <NSString *, id>*>*)images transverse:(int) transverse {
    if (images.count != self.buttons.count) {
        return;
    }
    [images enumerateObjectsUsingBlock:^(NSDictionary<NSString *,id> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.count != 0) {
            id imgn = [obj objectForKey:kCPSButtonNormalImage];
            id imgs = [obj objectForKey:kCPSButtonSelectedImage];
            UIButton *button = [self.buttons objectAtIndex:idx];
            if (imgn) {
                if ([imgn isKindOfClass:UIImage.class]) {
                    [button setImage:imgn forState:UIControlStateNormal];
                } else if ([imgn isKindOfClass:NSString.class]) {
                    [button setImage:kImageName(imgn) forState:UIControlStateNormal];
                }
            }
            if (imgs) {
                if ([imgs isKindOfClass:UIImage.class]) {
                    [button setImage:imgs forState:UIControlStateSelected];
                } else if ([imgs isKindOfClass:NSString.class]) {
                    [button setImage:kImageName(imgs) forState:UIControlStateSelected];
                }
            }
            if (transverse == 0) {
                [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:6];
            } else if (transverse == 2) {
                [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:6];
            }
        }
    }];
}
// 创建时，高度建议大于40
- (void)createSwithButton:(NSArray *)num font:(UIFont *)font defaultColor:(UIColor *)defaultColor selectedColor:(UIColor *)selectedColor {
    if (selectedColor) {
        _color_selected = selectedColor;
    }
    if (defaultColor) {
        _color_default = defaultColor;
    }
    if (font) {
        _font_default = font;
        if (!_font_selected) {
            _font_selected = font;
        }
    }
    if (num) {
        _titles = num;
        [self setButtonTitles:num];
    }
}
- (void)setSelectedFont:(UIFont *)selectedFont {
    _font_selected = selectedFont;
}
- (void)setLineColor:(UIColor *)color {
    _color_line = color;
    _lineView.backgroundColor = _color_line?:_color_selected;
}
- (void)setLineGradientColor:(CAGradientLayer *)gradientColor {
    _line_gradient = gradientColor;
    if (_lineView) {
        _line_gradient.frame = _lineView.bounds;
        _lineView.gradientLayer = _line_gradient;
    }
}
- (void)setLineOffset:(UIEdgeInsets)edge {
    _lineOffset = edge;
    _lineView.cp_x += +_lineOffset.left;
    _lineView.cp_y += +_lineOffset.top;
    _lineView.cp_width -= (_lineOffset.left+_lineOffset.right);
}
- (void)setLineHeight:(CGFloat)height {
    _line_height = height;
}
- (void)setLineSize:(CGSize)size {
    _line_size = size;
    _line_height = size.height;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.cp_scroll) {
        self.cp_scroll.frame = self.bounds;
    }
    
    // 计算按钮最大宽度
    CGFloat btnWidth = (self.cp_width - spacing * 2) / _buttons.count;
    CGFloat totalX = spacing;
    for (int i=0; i<_buttons.count ; i++) {
        UIButton *btn = [_buttons objectAtIndex:i];
        if (self.type == CPSwithButtonTypeScroll) {
            CGSize size = btn.frame.size;
            btnWidth = size.width;
        }
        btn.frame = CGRectMake(totalX, 10, btnWidth, 20);
        totalX += btnWidth;
    }
    UIButton *btn = [_buttons objectAtIndex:self.selectedAtIndex];
    if (!CGSizeEqualToSize(_line_size, CGSizeZero)) {
        _lineView.cp_width = _line_size.width;
    } else {
        _lineView.cp_width = btn.cp_width - lineWidth * 2;
    }
    _lineView.center = CGPointMake(btn.center.x, _lineView.center.y);
}

- (void)setSelectedAtIndex:(NSInteger)selectedAtIndex {
    if (_selectedAtIndex == selectedAtIndex) {
        return;
    }
    _selectedAtIndex = selectedAtIndex;
    for (UIButton *btn in self.buttons) {
        if (btn.tag - BUTTON_TAG == _selectedAtIndex) {
            [btn setTitleColor:_color_selected forState:UIControlStateNormal];
            if (!self.permitirVariasTap) {
                btn.userInteractionEnabled = !YES;
            }
            btn.titleLabel.font = _font_selected;
            _lineView.center = CGPointMake(btn.center.x, _lineView.center.y);
        }else{
            [btn setTitleColor:_color_default forState:UIControlStateNormal];
            btn.userInteractionEnabled = YES;
            btn.titleLabel.font = _font_default;
        }
    }
}

- (void)tapButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    for (UIButton *btn in self.buttons) {
        if (btn == sender) {
            [btn setTitleColor:_color_selected forState:UIControlStateNormal];
            if (!self.permitirVariasTap) {
                btn.userInteractionEnabled = !YES;
            }
            btn.titleLabel.font = _font_selected;
        }else{
            [btn setTitleColor:_color_default forState:UIControlStateNormal];
            btn.userInteractionEnabled = YES;
            btn.titleLabel.font = _font_default;
        }
    }
    [sender setNeedsLayout];
    [sender layoutIfNeeded];
    BOOL isHas = NO;
    for (NSNumber *num in self.excludes) {
        if ([num integerValue] == sender.tag - BUTTON_TAG) {
            isHas = YES;
            break;
        }
    }
    if (!isHas) {
        Code_Weakify(self)
        [UIView animateWithDuration:.15 delay:0. options:(UIViewAnimationOptionCurveEaseOut) animations:^{
            Code_Strongify(self)
            if (!self.lineIsFixedWidth) {
                self->_lineView.cp_width = sender.cp_width - lineWidth * 2;
                self->_lineView.gradientLayer.frame = self->_lineView.bounds;
            }
            self->_lineView.center = CGPointMake(sender.center.x, self->_lineView.center.y);
        } completion:^(BOOL finished) {
        }];
    }
    _selectedAtIndex = sender.tag - BUTTON_TAG;
    
    if ([self.delegate respondsToSelector:@selector(didTappedButton:)]) {
        [self.delegate didTappedButton:sender.tag - BUTTON_TAG];
    }
    if (self.didTappedButton) {
        self.didTappedButton(self, sender.tag - BUTTON_TAG);
    }
}

- (UIScrollView *)cp_scroll {
    if (!_cp_scroll) {
        _cp_scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        _cp_scroll.contentOffset = CGPointMake(0, 0);
        _cp_scroll.contentSize = CGSizeMake(0, 0);
        _cp_scroll.bounces = NO;
        _cp_scroll.showsHorizontalScrollIndicator = NO;
    }
    return _cp_scroll;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextMoveToPoint(ctx, rect.origin.x, rect.size.height -0.5);
//    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height -0.5);
//    CGContextSetLineWidth(ctx, 0.5);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
//    CGContextStrokePath(ctx);
//}

@end
