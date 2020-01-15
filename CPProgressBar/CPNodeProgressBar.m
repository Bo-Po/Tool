//
//  CPNodeProgressBar.m
//  O
//
//  Created by 州龚 on 2019/12/2.
//  Copyright © 2019 clearlove. All rights reserved.
//

#define progressNodeStart 5         // 进度条开始的位置（相对父视图）
#define progress_Width 5         // 显示的进度条的粗细
#define nodeSiza 3.5          // 节点大小（半径）
#define controlNodeSize 6         // 控制柄大小（半径）
#define controlNodeOffset 4         // 控制柄外环粗细

#import "CPNodeProgressBar.h"

@interface CPNodeProgressBar () {
    CAShapeLayer *_bottomLayer;      // 底层
    CAShapeLayer *_topLayer;         // 顶层
    CAShapeLayer *_control;          // 控制柄
    CGColorRef _defaultColor;
    CGColorRef _tintColor;
    
        // 动画
    CADisplayLink *_display;
    CGFloat _oldProgress;            // 老的进度值（动画用）
    
    BOOL _isResponseTouch;           // 是否响应触摸
}
@property (nonatomic, strong) CAShapeLayer *bottomLayer;
@property (nonatomic, strong) CAShapeLayer *topLayer;
@property (nonatomic, strong) CAShapeLayer *control;

    // 动画
@property (nonatomic, strong) CADisplayLink *display;

@end

@implementation CPNodeProgressBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self.layer addSublayer:self.bottomLayer];
        [self.layer addSublayer:self.topLayer];
        [self.layer addSublayer:self.control];
        [self setDefaultColor:UIColor.grayColor tintColor:UIColor.blueColor progress:0.0];
    }
    return self;
}
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
    _defaultColor = defaultColor.CGColor;
    _tintColor = tintColor.CGColor;
    self.progress = progress;
    return self;
}
- (void)layoutSubviews {
//    [super layoutSubviews];
    self.bottomLayer.bounds = self.bounds;
    self.bottomLayer.position = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    self.topLayer.bounds = self.bounds;
    self.topLayer.position = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    self.control.bounds = self.bounds;
    self.control.position = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    [self drawProgress];
}

- (void)drawProgress {
    CGFloat w = self.bounds.size.width;
    CGFloat y = self.bounds.size.height/2.0;
    CGFloat progressDisplayW = (w - progressNodeStart*2); // 进度条显示的区域宽度
    CGFloat prg = progressDisplayW*self.progress; // 进度条的实际到达当前进度的显示长度
    CGFloat itemW = progressDisplayW/(self.nodeNumber-1);
    CGFloat nodeX = progressDisplayW/self.nodeNumber;
    UIBezierPath *bottomLine = [[UIBezierPath alloc] init];
    [bottomLine moveToPoint:CGPointMake(progressNodeStart, y)];
    [bottomLine addLineToPoint:CGPointMake(w - progressNodeStart, y)];
    for (int i=0; i<self.nodeNumber; i++) {
        [bottomLine moveToPoint:CGPointMake(progressNodeStart + itemW*i + nodeSiza, y)];
        [bottomLine addArcWithCenter:CGPointMake(progressNodeStart + itemW*i, y) radius:nodeSiza startAngle:0 endAngle:2*M_PI clockwise:YES];
    }
    
    self.bottomLayer.path = bottomLine.CGPath;
    self.bottomLayer.lineWidth = progress_Width;
    self.bottomLayer.strokeColor = _defaultColor;
    self.bottomLayer.fillColor = _defaultColor;
    
    UIBezierPath *topLine = [[UIBezierPath alloc] init];
    CGFloat displayW = 0.;
    for (int i=0; i<self.nodeNumber; i++) {
        if (nodeX*i <= prg) {
            [topLine moveToPoint:CGPointMake(progressNodeStart + itemW*i + nodeSiza, y)];
            [topLine addArcWithCenter:CGPointMake(progressNodeStart + itemW*i, y) radius:nodeSiza startAngle:0 endAngle:2*M_PI clockwise:YES];
            displayW = progressNodeStart + itemW*i;
        } else {
            break;
        }
    }
    [topLine moveToPoint:CGPointMake(progressNodeStart, y)];
    [topLine addLineToPoint:CGPointMake(displayW, y)];
    self.topLayer.path = topLine.CGPath;
    self.topLayer.lineWidth = progress_Width;
    self.topLayer.strokeColor = _tintColor;
    self.topLayer.fillColor = _tintColor;
    
    UIBezierPath *control = [[UIBezierPath alloc] init];
    [control moveToPoint:CGPointMake(displayW-controlNodeSize+controlNodeOffset/2., y)];
    [control addArcWithCenter:CGPointMake(displayW, y) radius:controlNodeSize startAngle:-M_PI endAngle:M_PI clockwise:YES];
    self.control.path = control.CGPath;
    self.control.lineWidth = controlNodeOffset;
    self.control.strokeColor = self.controlBorderColor.CGColor?:UIColor.whiteColor.CGColor;
    self.control.fillColor = _tintColor;
}
// 一根或者多根手指开始触摸view，系统会自动调用view的下面方
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.isAnim) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (self.useControl) {
        CGFloat w = self.bounds.size.width;
        CGFloat progressDisplayW = (w - progressNodeStart*2); // 进度条显示的区域宽度
        if (point.x < progressNodeStart) {
            self.progress = 0.;
        } else if (point.x > (w - progressNodeStart)) {
            self.progress = 1.;
        } else {
            self.progress = (point.x-progressNodeStart)/progressDisplayW;
        }
    }
}
//一根或者多根手指在view上移动，系统会自动调用view的下面方法（随着手指的移动，会持续调用该方法)
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
        //当前的point
    CGPoint currentP = [touch locationInView:self];
    if (self.useControl) {
        CGFloat w = self.bounds.size.width;
        CGFloat progressDisplayW = (w - progressNodeStart*2); // 进度条显示的区域宽度
        if (currentP.x < progressNodeStart) {
            self.progress = 0.;
        } else if (currentP.x > (w - progressNodeStart)) {
            self.progress = 1.;
        } else {
            self.progress = (currentP.x-progressNodeStart)/progressDisplayW;
        }
    }
}
//一根或者多根手指离开view，系统会自动调用view的下面方法
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (self.useControl) {
        CGFloat w = self.bounds.size.width;
        CGFloat progressDisplayW = (w - progressNodeStart*2); // 进度条显示的区域宽度
        if (point.x < progressNodeStart) {
            self.progress = 0.;
        } else if (point.x > (w - progressNodeStart)) {
            self.progress = 1.;
        } else {
            self.progress = (point.x-progressNodeStart)/progressDisplayW;
        }
        NSInteger displayProgress = 1000/(self.nodeNumber-1);
        NSInteger temporary = (NSInteger)(self.progress*1000);
        NSInteger shangzhi = temporary/displayProgress;
        if (self.touchUpControl) {
            self.touchUpControl(shangzhi);
        }
    }
}

- (void)setProgress:(CGFloat)progress {
    if (_progress == progress) {
        return;
    }
    _progress = progress;
    NSInteger displayProgress = 1000/(self.nodeNumber-1);
    NSInteger temporary = (NSInteger)(progress*1000);
    NSInteger shangzhi = temporary/displayProgress;
    NSInteger yuzhi = temporary%displayProgress;
    if (yuzhi < displayProgress/2.) {
        _progress = displayProgress*shangzhi;
    } else if (yuzhi > displayProgress/2.) {
        _progress = displayProgress*(shangzhi+1);
    } else {
        _progress = displayProgress*shangzhi;
    }
    _progress = _progress/1000.;
    [self drawProgress];
}
- (void)setControlBorderColor:(UIColor *)controlBorderColor {
    if (controlBorderColor == _controlBorderColor) {
        return;
    }
    _controlBorderColor = controlBorderColor;
    [self drawProgress];
}
- (void)setNodeNumber:(int)nodeNumber {
    if (_nodeNumber == nodeNumber) {
        return;
    }
    _nodeNumber = nodeNumber;
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
