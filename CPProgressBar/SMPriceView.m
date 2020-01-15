//
//  SMPriceView.m
//  O
//
//  Created by 州龚 on 2019/12/3.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import "SMPriceView.h"


@interface SMPriceView () {
    NSMutableArray <UILabel *>*_textLabels;
    UIColor *_defaultColor;
    UIFont *_font;
}

@property (nonatomic, strong) CPNodeProgressBar *progressbar;

@end

@implementation SMPriceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _textLabels = @[].mutableCopy;
        [self setupConstraint];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textLabels = @[].mutableCopy;
        [self setupConstraint];
    }
    return self;
}
- (instancetype)setColor:(UIColor *)color font:(UIFont *)font {
    _defaultColor = color;
    _font = font;
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self resetUIDisplay];
}
- (void)setupConstraint {
    [self addSubview:self.progressbar];
    [self.progressbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(5);
        make.right.equalTo(self).mas_offset(-5);
        make.centerY.equalTo(self).mas_offset(-15);
        make.height.mas_equalTo(30.);
    }];
}
- (void)resetUIDisplay {
    [_textLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.texts enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *lab = [self->_textLabels objectAtIndex:idx];
        if ([obj isKindOfClass:NSString.class]) {
            lab.text = obj;
            if (self->_defaultColor) {
                lab.textColor = self->_defaultColor;
            }
            if (self->_font) {
                lab.font = self->_font;
            }
        } else if ([obj isKindOfClass:NSAttributedString.class]) {
            lab.attributedText = obj;
        }
        lab.textAlignment = NSTextAlignmentCenter;
        lab.numberOfLines = 2;
        [self addSubview:lab];
        CGFloat itemX = (self.cp_width-20)/(self.texts.count-1)*idx+5;
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.progressbar.mas_bottom).mas_offset(5.);
            make.centerX.equalTo(self.progressbar.mas_left).mas_offset(itemX);
            make.width.mas_equalTo(60.);
        }];
    }];
}

- (void)setDefaultColor:(UIColor *)defaultColor tintColor:(UIColor *)tintColor {
    [self.progressbar setDefaultColor:defaultColor tintColor:tintColor progress:self.progressbar.progress];
}
- (void)setControlBorderColor:(UIColor *)controlBorderColor {
        self.progressbar.controlBorderColor = controlBorderColor;
}
- (void)setDidValueChangeControl:(CPProgressControl)didValueChangeControl {
    if (didValueChangeControl == _didValueChangeControl) {
        return;
    }
    _didValueChangeControl = didValueChangeControl;
    _progressbar.touchUpControl = _didValueChangeControl;
}
- (void)setTexts:(NSArray *)texts {
    if (texts == _texts) {
        return;
    }
    _texts = texts;
    while (_textLabels.count<texts.count) {
        [_textLabels addObject:[[UILabel alloc] init]];
    }
    self.progressbar.nodeNumber = _texts.count;
    [self resetUIDisplay];
}
- (CPNodeProgressBar *)progressbar {
    if (!_progressbar) {
        _progressbar = [[CPNodeProgressBar alloc] init];
        _progressbar.backgroundColor = UIColor.clearColor;
        _progressbar.useControl = YES;
        _progressbar.nodeNumber = 4;
        _progressbar.touchUpControl = self.didValueChangeControl;
    }
    return _progressbar;
}
@end
