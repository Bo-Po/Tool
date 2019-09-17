//
//  CPNoticeLabel.m
//  OCTest
//
//  Created by 陈波 on 2019/8/12.
//  Copyright © 2019 陈波. All rights reserved.
//

#import "CPNoticeLabel.h"


@interface CPNoticeLabel ()

// 设置标题
@property (nonatomic) UILabel *titleLabel;
// 设置标题
@property (nonatomic) UILabel *afterLabel;
// 定时器
@property (nonatomic) NSTimer *timer;

@property (nonatomic) UITapGestureRecognizer *tap;

@end

@implementation CPNoticeLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc {
    NSLog(@"11111111");
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame titles:nil];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(nullable NSArray<NSString *> *)titles {
    if (self = [super initWithFrame:frame]) {
        [self initSetup];
        self.titles = titles;
        [self addSubview:self.titleLabel];
        [self addSubview:self.afterLabel];
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    self.titleLabel.frame = self.bounds;
    __block CGFloat w = self.bounds.size.width;
    __block CGFloat h = self.bounds.size.height;
    self.afterLabel.frame = CGRectMake(0, h, w, h);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (! newSuperview && self.timer) {
        // 销毁定时器
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)initSetup {
    self.delay = 5.;
    self.index = 0;
    self.duration = 0.;
}

- (void)initDisplaySetup {
    self.titleLabel.text = [self.titles objectAtIndex:self.index];
}

- (void)animationExecute {
    __block CGFloat w = self.bounds.size.width;
    __block CGFloat h = self.bounds.size.height;
    __block NSInteger idx = self.index+1;
    if (idx >= self.titles.count) {
        idx = 0;
    }
    self.afterLabel.text = [self.titles objectAtIndex:idx];
    _isAnimation = YES;
    __weak typeof(self) ws = self;
    [UIView animateWithDuration:self.duration animations:^{
        ws.titleLabel.frame = CGRectMake(0, -h, w, h);
        ws.afterLabel.frame = ws.bounds;
    } completion:^(BOOL finished) {
        if (finished) {
            ws.titleLabel.frame = ws.bounds;
            ws.afterLabel.frame = CGRectMake(0, h, w, h);
            ws.index = idx;
            [ws setValue:[NSNumber numberWithBool:NO] forKey:@"_isAnimation" ];
        }
    }];
}

- (void)tapNotice:(UITapGestureRecognizer *)tap {
    if (!self.isAnimation && self.tapBlock) {
        self.tapBlock(self.titleLabel.text, self.index);
    }
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    if (_titles == titles) {
        return;
    }
    _titles = titles;
    [self initDisplaySetup];
}
- (void)setDelay:(CGFloat)delay {
    if (_delay == delay) {
        return;
    }
    _delay = delay;
    if (self.timer) {
        [self.timer invalidate];
        _timer = nil;
    }
    [self.timer fire];
}
- (void)setIndex:(CGFloat)index {
    if (_index == index) {
        return;
    }
    _index = index;
    if (self.titles.count>0) {
        self.titleLabel.text = [self.titles objectAtIndex:self.index];
    }
}
- (void)setTapBlock:(CPClickButton)tapBlock {
    _tapBlock = tapBlock;
    [self.titleLabel addGestureRecognizer:self.tap];
}
- (void)setTextColor:(UIColor *)textColor {
    if (_textColor == textColor) {
        return;
    }
    _textColor = textColor;
    self.titleLabel.textColor = _textColor;
    self.afterLabel.textColor = _textColor;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.];
        _titleLabel.backgroundColor = UIColor.clearColor;
    }
    return _titleLabel;
}
- (UILabel *)afterLabel {
    if (!_afterLabel) {
        _afterLabel = [[UILabel alloc] init];
        _afterLabel.font = [UIFont systemFontOfSize:15.];
        _afterLabel.backgroundColor = UIColor.clearColor;
    }
    return _afterLabel;
}
- (NSTimer *)timer {
    if (!_timer) {
        __weak typeof(self) ws = self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:_delay repeats:YES block:^(NSTimer * _Nonnull timer) {
            [ws animationExecute];
        }];
    }
    return _timer;
}
- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNotice:)];
    }
    return _tap;
}

@end
