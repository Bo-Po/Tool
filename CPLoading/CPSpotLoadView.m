//
//  CPSpotLoadView.m
//  O
//
//  Created by 州龚 on 2019/9/17.
//  Copyright © 2019 clearlove. All rights reserved.
//

#ifndef PrefixHeader_pch
#import "AppDelegate.h"

#define App_Delegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define App_Window (App_Delegate.window)
#endif

#import "CPSpotLoadView.h"

static NSInteger circleCount = 3;
static CGFloat cornerRadius = 10;
static CGFloat magin = 15;

@interface CPSpotLoadView() <CAAnimationDelegate>
@property (nonatomic, strong) NSMutableArray *layerArr;
@end

@implementation CPSpotLoadView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self drawCircles];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.number = circleCount;
        self.radius = cornerRadius;
        self.magin = magin;
    }
    return self;
}

+ (void)showLoadView {
    [App_Window showLoading];
}

// 画圆
- (void)drawCircles {
    CGFloat w = self.bounds.size.width;
    for (NSInteger i = 0; i < self.number; ++i) {
        CGFloat x = (w - (self.radius*2) * self.number - self.magin * (self.number-1)) / 2.0 + i * (self.radius*2 + self.magin) + self.radius;
        CGRect rect = CGRectMake(-self.radius, -self.radius , 2*self.radius, 2*self.radius);
        UIBezierPath *beizPath=[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.radius];
        CAShapeLayer *layer=[CAShapeLayer layer];
        layer.path=beizPath.CGPath;
        UIColor *color = [UIColor grayColor];
        if (self.colors && self.colors.count) {
            color = self.colors[i%self.colors.count];
        }
        layer.fillColor=color.CGColor;
//        layer.fillColor=[UIColor grayColor].CGColor;
        layer.position = CGPointMake(x, self.frame.size.height * 0.5);
        [self.layer addSublayer:layer];
        
        [self.layerArr addObject:layer];
    }
    
    [self drawAnimation:self.layerArr[0]];
    
    // 旋转(可打开试试效果)
//    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.toValue = [NSNumber numberWithFloat: - M_PI * 2.0 ];
//    rotationAnimation.duration = 1;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = MAXFLOAT;
//    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

    // 动画实现
- (void)drawAnimation:(CALayer*)layer {
    CABasicAnimation *scaleUp = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleUp.fromValue = @1;
    scaleUp.toValue = @1.5;
    scaleUp.duration = 0.25;
    scaleUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CABasicAnimation *scaleDown = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleDown.beginTime = scaleUp.duration;
    scaleDown.fromValue = @1.5;
    scaleDown.toValue = @1;
    scaleDown.duration = 0.25;
    scaleDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[scaleUp, scaleDown];
    group.repeatCount = 0;
    group.duration = scaleUp.duration + scaleDown.duration;
    group.delegate = self;
    [layer addAnimation:group forKey:@"groupAnimation"];
    
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    if ([anim isKindOfClass:CAAnimationGroup.class]) {
        CAAnimationGroup *animation = (CAAnimationGroup *)anim;
        
        [self.layerArr enumerateObjectsUsingBlock:^(CAShapeLayer *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CAAnimationGroup *a0 = (CAAnimationGroup *)[obj animationForKey:@"groupAnimation"];
            if (a0 && a0 == animation) {
                CAShapeLayer *nextlayer = self.layerArr[(idx+1)>=self.layerArr.count?0:(idx+1)];
                [self performSelector:@selector(drawAnimation:) withObject:nextlayer afterDelay:0.25];
                *stop = YES;
            }
        }];
    }
}
- (NSMutableArray *)layerArr{
    if (_layerArr == nil) {
        _layerArr = [[NSMutableArray alloc] init];
    }
    return _layerArr;
}

@end


@implementation UIView (CPSpotLoadView)

- (CPSpotLoadView *)loadingView
{
    return objc_getAssociatedObject(self, @"loadingView");
}
- (void)setLoadingView:(CPSpotLoadView *)loadingView
{
    objc_setAssociatedObject(self, @"loadingView", loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)showLoading {
    if (self.loadingView == nil) {
        self.loadingView = [[CPSpotLoadView alloc]init];
//        self.loadingView.number = 5;
//        self.loadingView.radius = 5;
//        self.loadingView.magin = 10;
        self.loadingView.colors = @[UIColor.redColor, UIColor.yellowColor, UIColor.lightGrayColor];
    }
    [self addSubview:self.loadingView];
    [self bringSubviewToFront:self.loadingView];
    self.loadingView.frame = self.bounds;
}
- (void)hideLoad{
    [self.loadingView removeFromSuperview];
}
@end
