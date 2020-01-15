//
//  CPArcProgressBar.m
//  O
//
//  Created by 州龚 on 2019/9/19.
//  Copyright © 2019 clearlove. All rights reserved.
//

#import "CPArcProgressBar.h"

#ifndef PrefixHeader_pch
#import "AppDelegate.h"

#define Size_ScreenWidth ([[UIScreen mainScreen]bounds].size.width)
#define Size_ScreenHeight ([[UIScreen mainScreen]bounds].size.height)

#endif

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式

static const CGFloat kMarkerDiameter = 8.f; // 光标直径
static const CGFloat kAnimationTime = 1.5f;

@interface CPArcProgressBar () {
    
}

@property (nonatomic, strong) CAShapeLayer *bottomLayer; // 外弧
@property (nonatomic, strong) CAGradientLayer *gradientLayer; // 渐变进度条
@property (nonatomic, strong) UIImageView *markerImageView; // 光标


@property (nonatomic, strong) CAShapeLayer *dialLayer; // 内弧 虚实线


@property (nonatomic, strong) UILabel *titleLabel; // 中间显示的字

@end

@implementation CPArcProgressBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.showDial) {
            //1.获取上下文
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
            //1.1 设置线条的宽度
        CGContextSetLineWidth(ctx, 10);
            //1.2 设置线条的起始点样式
        CGContextSetLineCap(ctx,kCGLineCapButt);
            //1.3  虚实切换 ，实线2虚线8
        CGFloat length[] = {2,8};
        CGContextSetLineDash(ctx, 0, length, 2);
            //1.4 设置颜色
        [[UIColor lightGrayColor] set];
        CGFloat pointW = self.bounds.size.width;
        CGFloat pointH = self.bounds.size.height;
            //2.设置路径
        CGContextAddArc(ctx, pointW/2. , pointH/2., (self.circelDiameter - self.lineWidth) / 2-15, degreesToRadians(self.stareAngle), degreesToRadians(self.endAngle), 0);
            //3.绘制
        CGContextStrokePath(ctx);
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat pointX_Y = MIN(self.bounds.size.width, self.bounds.size.height);
        self.circelDiameter = pointX_Y - 20;
        self.lineWidth = 1.0f;
        self.stareAngle = -225.f;
        self.endAngle = 45.f;
        [self initSubView];
        [self initSubLayer];
    }
    return self;
}
- (void)layoutSubviews {
    self.dialLayer.frame = self.bounds;
    self.gradientLayer.frame = self.bounds;
    CGFloat pointW = self.bounds.size.width;
    CGFloat pointH = self.bounds.size.height;
    self.titleLabel.center = CGPointMake(pointW/2., pointH/2);
}

- (void)initSubView {
    
}
- (void)initSubLayer {
    CGFloat sw = self.bounds.size.width;
    CGFloat sh = self.bounds.size.height;
        // 圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(sw / 2, sh / 2)
                                                        radius:(self.circelDiameter - self.lineWidth) / 2
                                                    startAngle:degreesToRadians(self.stareAngle)
                                                      endAngle:degreesToRadians(self.endAngle)
                                                     clockwise:YES];
    
        // 底色
    self.bottomLayer = [CAShapeLayer layer];
    self.bottomLayer.frame = self.bounds;
    self.bottomLayer.fillColor = [[UIColor clearColor] CGColor];
    self.bottomLayer.strokeColor = [[UIColor  colorWithRed:206.f / 256.f green:241.f / 256.f blue:227.f alpha:1.f] CGColor];
    self.bottomLayer.opacity = 0.5;
    self.bottomLayer.lineCap = kCALineCapRound;
    self.bottomLayer.lineWidth = self.lineWidth;
    self.bottomLayer.path = [path CGPath];
    [self.layer addSublayer:self.bottomLayer];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    [self.gradientLayer setColors:[NSArray arrayWithObjects:
                                   (id)[Color_Hex(@"0x7FFF00") CGColor],
                                   (id)[Color_Hex(@"0xEEEE00") CGColor],
                                   (id)[Color_Hex(@"0xFFEC8B") CGColor],
                                   (id)[Color_Hex(@"0xEE0000") CGColor],
                                   nil]];
    [self.gradientLayer setLocations:@[@0.2, @0.5, @0.7, @1]];
    [self.gradientLayer setStartPoint:CGPointMake(0, 0)];
    [self.gradientLayer setEndPoint:CGPointMake(1, 0)];
    [self.gradientLayer setMask:self.bottomLayer];

    [self.layer addSublayer:self.gradientLayer];
    
        // 240 是用整个弧度的角度之和 |-200| + 20 = 220
    [self createAnimationWithStartAngle:degreesToRadians(self.stareAngle)
                               endAngle:degreesToRadians(self.stareAngle + 220 * 0)];
}

#pragma mark - Animation
- (void)createAnimationWithStartAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle { // 光标动画
    CGFloat sw = self.bounds.size.width;
    CGFloat sh = self.bounds.size.height;
    self.markerImageView.frame = CGRectMake(-100, sh, kMarkerDiameter, kMarkerDiameter);
    self.markerImageView.layer.cornerRadius = self.markerImageView.frame.size.height / 2;
    [self addSubview:self.markerImageView];
        // 设置动画属性
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration = kAnimationTime;
    pathAnimation.repeatCount = 1;
    
        // 设置动画路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, sw / 2, sh / 2, (self.circelDiameter - self.lineWidth)/ 2, startAngle, endAngle, 0);
    pathAnimation.path = path;
    CGPathRelease(path);
    
    
    [self.markerImageView.layer addAnimation:pathAnimation forKey:@"moveMarker"];
}
- (void)updateDialAnimation {
        // 设置动画属性
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.values = @[@0., @(_percent)];
    pathAnimation.duration = kAnimationTime;
    pathAnimation.repeatCount = 1;
    [self.dialLayer addAnimation:pathAnimation forKey:nil];
}

#pragma mark - Setters / Getters
- (void)setPercent:(CGFloat)percent {
    [self setPercent:percent animated:YES];
}
- (void)setShowDial:(BOOL)showDial {
    _showDial = showDial;
    if (_showDial) {
        [self.layer addSublayer:self.dialLayer];
    } else {
        [self.dialLayer removeFromSuperlayer];
    }
    [self setNeedsDisplay];
}
- (void)setDialHighlightedColor:(UIColor *)dialHighlightedColor {
    _dialHighlightedColor = dialHighlightedColor;
    self.dialLayer.strokeColor = _dialHighlightedColor.CGColor;
}
- (void)setTitle:(NSString *)title {
    if ([_title isEqualToString:title]) {
        return;
    }
    _title = title;
    self.titleLabel.text = _title;
    [self.titleLabel sizeToFit];
    [self addSubview:self.titleLabel];
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = _titleColor;
}
- (void)setPercent:(CGFloat)percent animated:(BOOL)animated {
    _percent = percent;
    [self createAnimationWithStartAngle:degreesToRadians(self.stareAngle)
                               endAngle:degreesToRadians(self.stareAngle + 270 *percent)];
    if (animated) {
        [self updateDialAnimation];
    }
//    self.dialLayer.strokeEnd = percent;
}

- (UIImageView *)markerImageView {
    if (nil == _markerImageView) {
        _markerImageView = [[UIImageView alloc] init];
        _markerImageView.backgroundColor = Color_Hex(@"0x20B2AA");
        _markerImageView.alpha = 0.7;
        _markerImageView.layer.shadowColor =  Color_Hex(@"0x20B2AA").CGColor;
        _markerImageView.layer.shadowOffset = CGSizeMake(0, 0);
        _markerImageView.layer.shadowRadius = 3.f;
        _markerImageView.layer.shadowOpacity = 1;
    }
    return _markerImageView;
}

- (CAShapeLayer *)dialLayer {
    if (!_dialLayer) {
        CGFloat sw = self.bounds.size.width;
        CGFloat sh = self.bounds.size.height;
            // 圆形路径
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(sw / 2, sh / 2)
                                                            radius:(self.circelDiameter - self.lineWidth) / 2-15
                                                        startAngle:degreesToRadians(self.stareAngle)
                                                          endAngle:degreesToRadians(self.endAngle)
                                                         clockwise:YES];
        _dialLayer = [[CAShapeLayer alloc] init];
        _dialLayer = [CAShapeLayer layer];
        _dialLayer.frame = self.bounds;
        _dialLayer.fillColor = [[UIColor clearColor] CGColor];
        _dialLayer.strokeColor = [self.dialHighlightedColor CGColor];
        _dialLayer.lineCap = @"butt";
        _dialLayer.lineDashPattern = @[@2., @8.];
        _dialLayer.lineWidth = 10;
        _dialLayer.path = [path CGPath];
        _dialLayer.strokeEnd = 0.;
    }
    return _dialLayer;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:50.];
    }
    return _titleLabel;
}

@end
