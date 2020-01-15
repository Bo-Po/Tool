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
    
    // 动画
    CADisplayLink *_display;
    CGFloat _oldProgress;            // 老的进度值（动画用）
    
    BOOL _isResponseTouch;           // 是否响应触摸
    
    BOOL _anim_control;            // 动画控制
}
@property (nonatomic, strong) CAShapeLayer *bottomLayer;
@property (nonatomic, strong) CAShapeLayer *topLayer;
@property (nonatomic, strong) CAShapeLayer *control;

// 动画
@property (nonatomic, strong) CADisplayLink *display;

@end

@implementation CPProgressBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    if (_display) {
        [_display invalidate];
        _display = nil;
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.cp_progressWidth = progressWidth;
        self.cp_controlSiza = controlSiza;
        self.cp_controlOffset = controlOffset;
        [self.layer addSublayer:self.bottomLayer];
        [self.layer addSublayer:self.topLayer];
        [self.layer addSublayer:self.control];
        [self setDefaultColor:UIColor.grayColor tintColor:UIColor.blueColor progress:0.0];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.cp_progressWidth = progressWidth;
        self.cp_controlSiza = controlSiza;
        self.cp_controlOffset = controlOffset;
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
- (void)setProgress:(CGFloat)progress animation:(BOOL)animation {
//    if (_progress == progress) {
//        return;
//    }
    _oldProgress = _progress;
    _progress = progress;
    if (animation) {
        _anim_control = _oldProgress > _progress;
        _isAnim = YES;
        self.display.paused = NO;
    } else {
        _oldProgress = _progress;
        [self drawProgress];
    }
}

- (void)layoutSubviews {
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
    CGFloat prg = (w - progressStart*2)*_oldProgress; // 进度条的实际到达当前进度的显示长度
    UIBezierPath *bottomLine = [[UIBezierPath alloc] init];
    [bottomLine moveToPoint:CGPointMake(progressStart, y)];
    [bottomLine addLineToPoint:CGPointMake(w - progressStart, y)];
    self.bottomLayer.path = bottomLine.CGPath;
    self.bottomLayer.lineWidth = self.cp_progressWidth;
    self.bottomLayer.strokeColor = _defaultColor;
    
    UIBezierPath *topLine = [[UIBezierPath alloc] init];
    [topLine moveToPoint:CGPointMake(progressStart, y)];
    [topLine addLineToPoint:CGPointMake(prg+progressStart, y)];
    self.topLayer.path = topLine.CGPath;
    self.topLayer.lineWidth = self.cp_progressWidth;
    self.topLayer.strokeColor = _tintColor;
    
    UIBezierPath *control = [[UIBezierPath alloc] init];
    [control moveToPoint:CGPointMake(prg+progressStart-(self.cp_controlSiza/2.)+self.cp_controlOffset/2., y)];
    [control addArcWithCenter:CGPointMake(prg+progressStart, y) radius:(self.cp_controlSiza/2.) startAngle:0 endAngle:2*M_PI clockwise:YES];
    self.control.path = control.CGPath;
    self.control.lineWidth = self.cp_controlOffset;
    self.control.strokeColor = UIColor.whiteColor.CGColor;
    self.control.fillColor = _tintColor;
}

- (void)updateProgress {
    if (_anim_control) {
        _oldProgress = _oldProgress-0.01;
        [self drawProgress];
        if (_oldProgress<=_progress) {
            self.display.paused = YES;
            _isAnim = NO;
        }
    } else {
        _oldProgress = _oldProgress+0.01;
        [self drawProgress];
        if (_oldProgress>=_progress) {
            self.display.paused = YES;
            _isAnim = NO;
        }
    }
}
//一根或者多根手指开始触摸view，系统会自动调用view的下面方
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.isAnim) {
        return;
    }
    UITouch *touch = [touches anyObject];
    //初始point
    CGPoint point = [touch locationInView:self];
    
    if (self.useControl) {
        CGFloat w = self.bounds.size.width;
        CGFloat y = self.bounds.size.height/2.0;
        CGFloat prg = (w - progressStart*2)*_oldProgress; // 进度条的实际到达当前进度的显示长度
        _isResponseTouch = CGRectContainsPoint(CGRectMake(prg+progressStart-15., y-15., 30, 30), point);
    }
}
//一根或者多根手指在view上移动，系统会自动调用view的下面方法（随着手指的移动，会持续调用该方法)
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_isResponseTouch) {
        CGFloat w = self.bounds.size.width;
        CGFloat lengthReal = w - progressStart*2; // 进度条的实际显示长度
        
        UITouch *touch = [touches anyObject];
        //当前的point
        CGPoint currentP = [touch locationInView:self];
        //以前的point
        CGPoint preP = [touch previousLocationInView:self];
        CGFloat offsetX = currentP.x - preP.x;
        // 计算百分比
        CGFloat offsetPerg = offsetX/lengthReal;
        // 计算当前百分比
        _oldProgress += offsetPerg;
        if (_oldProgress < 0) {
            _oldProgress = 0;
        } else if (_oldProgress > 1) {
            _oldProgress = 1;
        }
        [self drawProgress];
    }
}
//一根或者多根手指离开view，系统会自动调用view的下面方法
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.progress = _oldProgress;
    if (self.endDidControl) {
        self.endDidControl(self.progress);
    }
}

- (void)setProgress:(CGFloat)progress {
//    if (_progress == progress) {
//        return;
//    }
    [self setProgress:progress animation:NO];
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
- (CADisplayLink *)display {
    if (!_display) {
        _display = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
        _display.paused = YES;
        [_display addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _display;
}

@end
