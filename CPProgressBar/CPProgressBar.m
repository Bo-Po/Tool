//
//  CPProgressBar.m
//  OCTest
//
//  Created by 陈波 on 2019/8/3.
//  Copyright © 2019 陈波. All rights reserved.
//

#define progressStart 5         // 进度条开始的位置（相对父视图）
#define progressWidth 5         // 显示的进度条的粗细
#define controlSiza 10          // 控制柄大小
#define controlOffset 2         // 控制柄外环粗细

#import "CPProgressBar.h"

@interface CPProgressBar () {
    CAShapeLayer *_bottomLayer;      // 底层
    CAShapeLayer *_topLayer;         // 顶层
    CAShapeLayer *_control;          // 控制柄
    CGColorRef _defaultColor;
    CGColorRef _tintColor;
}
@property (nonatomic, strong) CAShapeLayer *bottomLayer;
@property (nonatomic, strong) CAShapeLayer *topLayer;
@property (nonatomic, strong) CAShapeLayer *control;

@end

@implementation CPProgressBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.layer addSublayer:self.bottomLayer];
        [self.layer addSublayer:self.topLayer];
        [self.layer addSublayer:self.control];
        [self setDefaultColor:UIColor.grayColor tintColor:UIColor.blueColor progress:0.0];
    }
    return self;
}
- (instancetype)setDefaultColor:(UIColor *)defaultColor tintColor:(UIColor *)tintColor progress:(CGFloat)progress {
    self.progress = progress;
    _defaultColor = defaultColor.CGColor;
    _tintColor = tintColor.CGColor;
    return self;
}

- (void)layoutSubviews {
    self.bottomLayer.bounds = self.bounds;
    self.bottomLayer.position = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    self.topLayer.bounds = self.bounds;
    self.topLayer.position = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    self.control.bounds = self.bounds;
    self.control.position = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
}

- (void)drawProgress {
    CGFloat w = self.bounds.size.width;
    CGFloat y = self.bounds.size.height/2.0;
    CGFloat prg = (w - progressStart*2)*self.progress; // 进度条的实际到达当前进度的显示长度
    UIBezierPath *bottomLine = [[UIBezierPath alloc] init];
    [bottomLine moveToPoint:CGPointMake(progressStart, y)];
    [bottomLine addLineToPoint:CGPointMake(w - progressStart, y)];
    self.bottomLayer.path = bottomLine.CGPath;
    self.bottomLayer.lineWidth = progressWidth;
    self.bottomLayer.strokeColor = _defaultColor;
    
    UIBezierPath *topLine = [[UIBezierPath alloc] init];
    [topLine moveToPoint:CGPointMake(progressStart, y)];
    [topLine addLineToPoint:CGPointMake(prg+progressStart, y)];
    self.topLayer.path = topLine.CGPath;
    self.topLayer.lineWidth = progressWidth;
    self.topLayer.strokeColor = _tintColor;
    
    UIBezierPath *control = [[UIBezierPath alloc] init];
    [control moveToPoint:CGPointMake(prg+progressStart-(controlSiza/2.)+controlOffset/2., y)];
    [control addArcWithCenter:CGPointMake(prg+progressStart, y) radius:(controlSiza/2.) startAngle:0 endAngle:2*M_PI clockwise:YES];
    self.control.path = control.CGPath;
    self.control.lineWidth = controlOffset;
    self.control.strokeColor = UIColor.whiteColor.CGColor;
    self.control.fillColor = _tintColor;
}

- (void)setProgress:(CGFloat)progress {
    if (_progress == progress) {
        return;
    }
    _progress = progress;
    [self drawProgress];
}
- (CAShapeLayer *)bottomLayer {
    if (!_bottomLayer) {
        _bottomLayer = [[CAShapeLayer alloc] init];
        _bottomLayer.bounds = self.bounds;
        _bottomLayer.position = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    }
    return _bottomLayer;
}
- (CAShapeLayer *)topLayer {
    if (!_topLayer) {
        _topLayer = [[CAShapeLayer alloc] init];
    }
    return _topLayer;
}
- (CAShapeLayer *)control {
    if (!_control) {
        _control = [[CAShapeLayer alloc] init];
    }
    return _control;
}


@end
