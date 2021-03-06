//
//  PurchaseCarAnimationTool.m
//  PruchaseCarAnimation
//
//  Created by zhenyong on 16/8/17.
//  Copyright © 2016年 com.demo. All rights reserved.
//
#import "AppDelegate.h"
#import "PurchaseCarAnimationTool.h"
@interface PurchaseCarAnimationTool()<CAAnimationDelegate>

@end

@implementation PurchaseCarAnimationTool
#pragma mark - instancetype
+ (instancetype)shareTool
{
    return [[PurchaseCarAnimationTool alloc]init];
}
#pragma public function
- (void)startAnimationandView:(UIView *)view
                         rect:(CGRect)rect
                  finisnPoint:(CGPoint)finishPoint
                  finishBlock:(animationFinisnBlock)completion
{
    //图层
    _layer = [CALayer layer];
    _layer.contents = view.layer.contents;
    _layer.contentsGravity = kCAGravityResizeAspectFill;
    _layer.position = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect)); //a 点
    rect.size.width  = view.bounds.size.width;
    rect.size.height = view.bounds.size.height;   //重置图层尺寸
    _layer.bounds = rect;
    _layer.cornerRadius  = rect.size.width/2;
    _layer.masksToBounds = YES;          //圆角
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow.layer addSublayer:_layer];
    /// 路径
    [self createAnimationwithRect:rect finishPoint:finishPoint];
    /// 回调
    if (completion) {
        _animationFinisnBlock = completion;
    }
}
+ (void)shakeAnimation:(UIView *)shakeView
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shakeAnimation.duration = 0.25f;
    shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
    shakeAnimation.toValue = [NSNumber numberWithFloat:5];
    shakeAnimation.autoreverses = YES;
    [shakeView.layer addAnimation:shakeAnimation forKey:nil];
}
#pragma mark - private function
/// 创建动画
- (void)createAnimationwithRect:(CGRect)rect
                    finishPoint:(CGPoint)finishPoint {
    /// 路径动画
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:_layer.position];
    CGFloat w = fabs(finishPoint.x - CGRectGetMidX(rect))+50;
    CGFloat startx = (finishPoint.x - CGRectGetMidX(rect))/2. + CGRectGetMidX(rect);
    NSLog(@"rect.origin.y == %f",rect.origin.y);
    [path addQuadCurveToPoint:finishPoint controlPoint:CGPointMake(startx, rect.origin.y-w)];
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.path = path.CGPath;
    /// 旋转动画
    CABasicAnimation *rotateAnimation   = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.removedOnCompletion = YES;
    rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotateAnimation.toValue   = [NSNumber numberWithFloat:12];
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    /// 添加动画动画组合
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[pathAnimation,rotateAnimation];
    groups.duration = 1.2f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [_layer addAnimation:groups forKey:@"group"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == [_layer animationForKey:@"group"]) {
        [_layer removeFromSuperlayer];
        _layer = nil;
        if (_animationFinisnBlock) {
            _animationFinisnBlock(YES);
        }
    }
}
@end
