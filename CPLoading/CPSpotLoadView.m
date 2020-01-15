//
//  CPSpotLoadView.m
//  O
//
//  Created by 州龚 on 2019/9/17.
//  Copyright © 2019 clearlove. All rights reserved.
//

#ifndef PrefixHeader_pch
#import "AppDelegate.h"
#import "CPInsetsLabel.h"

#define App_Delegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define App_Window (App_Delegate.window)
#endif

#import "CPSpotLoadView.h"

static NSInteger circleCount = 3;
static CGFloat cornerRadius = 10;
static CGFloat magin = 15;

@interface CPSpotLoadView() <CAAnimationDelegate>
    // 防止窗口被自动销毁
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
+ (void)hideLoad {
    [App_Window hideLoad];
//    [App_Window  makeKeyAndVisible];
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

- (UIWindow *)window {
    return objc_getAssociatedObject(self, @"window");
}
- (void)setWindow:(UIWindow *)window {
    objc_setAssociatedObject(self, @"window", window, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CPSpotLoadView *)loadingView {
    return objc_getAssociatedObject(self, @"loadingView");
}
- (void)setLoadingView:(CPSpotLoadView *)loadingView {
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
    [App_Window makeKeyAndVisible];
}

- (void)showLoadingWithMessage:(NSString *)msg {
    self.window = [[UIWindow alloc] initWithFrame:App_Window.bounds];
    UIView *view = [[UIView alloc] init];
    view.bounds = CGRectMake(0, 0, 150, 150);
    view.center = CGPointMake(Size_ScreenWidth/2., Size_ScreenHeight/2.);
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 15.;
    [self.window addSubview:view];
    
    CPInsetsLabel *lab = [[CPInsetsLabel alloc] init];
    lab.textInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15.];
    lab.text = msg;
    lab.textColor = UIColor.whiteColor;
    lab.backgroundColor = UIColor.clearColor;
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 5.;
    CGSize size = [lab sizeThatFits:CGSizeMake(view.bounds.size.width, 100)];
    lab.frame = CGRectMake(0, view.bounds.size.height - size.height, 150, size.height);
    [view addSubview:lab];
    
    CPSpotLoadView *loadingView = [[CPSpotLoadView alloc]initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height - size.height)];
        //    loadingView.number = 3;
    loadingView.radius = 5;
    loadingView.magin = 10;
    loadingView.colors = @[UIColor.redColor, UIColor.greenColor, UIColor.blueColor];
    [view addSubview:loadingView];
    
//    UIViewController *vc = [[UIViewController alloc] init];
//    [vc.view addSubview:view];
//
//    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}
@end
