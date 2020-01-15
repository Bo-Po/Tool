//
//  UIView+Touche.m
//  Dome
//
//  Created by 陈波 on 2017/5/8.
//  Copyright © 2017年 陈波. All rights reserved.
//

#import "UIView+Touche.h"

static void *isAllowToucheAddress = (void *)@"isAllowTouche_Key";
static void *isAllowToucheToTopAddress = (void *)@"isAllowToucheToTop_Key";
static void *startPointAddress = (void *)@"startPoint_Key";
static void *toucheDelegateAddress = (void *)@"toucheDelegate_Key";
static void *isAllowZoomAddress = (void *)@"isAllowZoom_Key";
static void *isAllowDragAddress = (void *)@"isAllowDrag_Key";
static void *startRegionAddress = (void *)@"startRegion_Key";
#define Zoom_Contact_Range 20.

typedef enum : NSUInteger {
    UIViewToucheRegionNormal = 0,
    UIViewToucheLeftTop,
    UIViewToucheLeftBottom,
    UIViewToucheRightTop,
    UIViewToucheRightBottom
} viewToucheRegionType;

@interface UIView ()

@property (assign, nonatomic) CGPoint startPoint;
@property (assign, nonatomic) viewToucheRegionType startRegion;

@end

@implementation UIView (Touche)



#pragma mark- -触点范围分析-
viewToucheRegionType Touche_Is_Left_Top_Region (CGPoint point, UIView *view) {
    CGFloat x = point.x;
    CGFloat y = point.y;
    CGFloat w = view.bounds.size.width;
    CGFloat h = view.bounds.size.height;
    if ((0. <= x) && (x <= Zoom_Contact_Range) && (0. <= y) && (y <= Zoom_Contact_Range)) {
        return UIViewToucheLeftTop;
    } else if ((0. <= x) && (x <= Zoom_Contact_Range) && ((h-Zoom_Contact_Range) <= y) && (y <= h)) {
        return UIViewToucheLeftBottom;
    } else if (((w-Zoom_Contact_Range) <= x) && (x <= w) && (0. <= y) && (y <= Zoom_Contact_Range)) {
        return UIViewToucheRightTop;
    } else if (((w-Zoom_Contact_Range) <= x) && (x <= w) && ((h-Zoom_Contact_Range) <= y) && (y <= h)) {
        return UIViewToucheRightBottom;
    }else {
        return UIViewToucheRegionNormal;
    }
}

#pragma mark- -setter/getter-
- (id<UIViewToucheDelegate>)toucheDelegate {
    return objc_getAssociatedObject(self, toucheDelegateAddress);
}
- (void)setToucheDelegate:(id<UIViewToucheDelegate>)toucheDelegate {
    objc_setAssociatedObject(self, toucheDelegateAddress, toucheDelegate, OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isAllowTouche {
    return ((NSNumber *)objc_getAssociatedObject(self, isAllowToucheAddress)).boolValue;
}
- (void)setIsAllowTouche:(BOOL)isAllowTouche {
    objc_setAssociatedObject(self, isAllowToucheAddress, @(isAllowTouche), OBJC_ASSOCIATION_RETAIN);
}
- (viewToucheRegionType)startRegion {
    return (viewToucheRegionType)((NSNumber *)objc_getAssociatedObject(self, startRegionAddress)).integerValue;
}
- (void)setStartRegion:(viewToucheRegionType)startRegion {
    objc_setAssociatedObject(self, startRegionAddress, @(startRegion), OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)isAllowToucheToTop {
    return ((NSNumber *)objc_getAssociatedObject(self, isAllowToucheToTopAddress)).boolValue;
}
- (void)setIsAllowToucheToTop:(BOOL)isAllowToucheToTop {
    objc_setAssociatedObject(self, isAllowToucheToTopAddress, @(isAllowToucheToTop), OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)isAllowZoom {
    return ((NSNumber *)objc_getAssociatedObject(self, isAllowZoomAddress)).boolValue;
}
- (void)setIsAllowZoom:(BOOL)isAllowZoom {
    objc_setAssociatedObject(self, isAllowZoomAddress, @(isAllowZoom), OBJC_ASSOCIATION_RETAIN);
}
- (CGPoint)startPoint {
    return CGPointFromString(objc_getAssociatedObject(self, startPointAddress));
}
- (void)setStartPoint:(CGPoint)startPoint {
    objc_setAssociatedObject(self, startPointAddress, NSStringFromCGPoint(startPoint), OBJC_ASSOCIATION_COPY);
}
- (BOOL)isAllowDrag {
    return ((NSNumber *)objc_getAssociatedObject(self, isAllowDragAddress)).boolValue;
}
- (void)setIsAllowDrag:(BOOL)isAllowDrag {
    objc_setAssociatedObject(self, isAllowDragAddress, @(isAllowDrag), OBJC_ASSOCIATION_RETAIN);
}

#pragma mark- -Touche-
//一根或者多根手指开始触摸view，系统会自动调用view的下面方
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    //初始point
    self.startPoint = [touch locationInView:self];
    if (self.isAllowZoom) {
        self.startRegion = Touche_Is_Left_Top_Region(self.startPoint, self);
    } else {
        self.startRegion = UIViewToucheRegionNormal;
    }
    if (self.isAllowToucheToTop) {
        [self.superview bringSubviewToFront:self];
    }
}
//一根或者多根手指在view上移动，系统会自动调用view的下面方法（随着手指的移动，会持续调用该方法)
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (!self.isAllowTouche) {
        return;
    }
    UITouch *touch = [touches anyObject];
    
    //当前的point
    CGPoint currentP = [touch locationInView:self];
    
    //以前的point
    CGPoint preP = [touch previousLocationInView:self];
    if (self.toucheDelegate && [self.toucheDelegate respondsToSelector:@selector(toucheView:didMovedFromPoint:toPoint:)]) {
        [self.toucheDelegate toucheView:self didMovedFromPoint:preP toPoint:currentP];
//        return; //如果实现了代理 ，还需要移动或缩放请注释这一句
    }
    
    { // 计算偏移量
        //x轴偏移的量
        CGFloat offsetX = currentP.x - preP.x;
        //Y轴偏移的量
        CGFloat offsetY = currentP.y - preP.y;
        CGRect rect = self.frame;
        { // 控制缩放
            if (self.isAllowZoom) {
                switch (self.startRegion) {
                    case UIViewToucheLeftTop:
                        if ((rect.size.width - offsetX) < 2*Zoom_Contact_Range) {
                            rect.size.width = 2*Zoom_Contact_Range;
                        } else {
                            rect.origin.x += offsetX;
                            rect.size.width -= offsetX;
                        }
                        if ((rect.size.height - offsetY) < 2*Zoom_Contact_Range) {
                            rect.size.height = 2*Zoom_Contact_Range;
                        } else {
                            rect.origin.y += offsetY;
                            rect.size.height -= offsetY;
                        }
                        break;
                    case UIViewToucheLeftBottom:
                        if ((rect.size.width - offsetX) < 2*Zoom_Contact_Range) {
                            rect.size.width = 2*Zoom_Contact_Range;
                        } else {
                            rect.origin.x += offsetX;
                            rect.size.width -= offsetX;
                        }
                        if ((rect.size.height + offsetY) < 2*Zoom_Contact_Range) {
                            rect.size.height = 2*Zoom_Contact_Range;
                        } else {
                            //rect.origin.y += offsetY;
                            rect.size.height += offsetY;
                        }
                        break;
                    case UIViewToucheRightTop:
                        if ((rect.size.width + offsetX) < 2*Zoom_Contact_Range) {
                            rect.size.width = 2*Zoom_Contact_Range;
                        } else {
                            //rect.origin.x += offsetX;
                            rect.size.width += offsetX;
                        }
                        if ((rect.size.height - offsetY) < 2*Zoom_Contact_Range) {
                            rect.size.height = 2*Zoom_Contact_Range;
                        } else {
                            rect.origin.y += offsetY;
                            rect.size.height -= offsetY;
                        }
                        break;
                    case UIViewToucheRightBottom:
                        if ((rect.size.width + offsetX) < 2*Zoom_Contact_Range) {
                            rect.size.width = 2*Zoom_Contact_Range;
                        } else {
                            //rect.origin.x += offsetX;
                            rect.size.width += offsetX;
                        }
                        if ((rect.size.height + offsetY) < 2*Zoom_Contact_Range) {
                            rect.size.height = 2*Zoom_Contact_Range;
                        } else {
                            //rect.origin.y += offsetY;
                            rect.size.height += offsetY;
                        }
                        break;
                        
                    default:
                        break;
                }
                self.frame = rect;
            }
        }
        { // 控制移动
            if (self.isAllowDrag && (self.startRegion == UIViewToucheRegionNormal)) {
                CGRect frame = self.frame;
                frame.origin.x += offsetX;
                frame.origin.y += offsetY;
                self.frame = frame;
            }
        }
        
        { // 防止超出父视图
            CGRect frame = self.frame;
            if (frame.origin.x < 0) {
                frame.origin.x = 0;
            }
            if (frame.origin.y < 0) {
                frame.origin.y = 0;
            }
            if ((frame.origin.x+frame.size.width) >= self.superview.bounds.size.width) {
                frame.origin.x = self.superview.bounds.size.width - frame.size.width;
            }
            if ((frame.origin.y+frame.size.height) >= self.superview.bounds.size.height) {
                frame.origin.y = self.superview.bounds.size.height - frame.size.height;
            }
            self.frame = frame;
        }
    }
}
//一根或者多根手指离开view，系统会自动调用view的下面方法
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (!self.isAllowTouche) {
        return;
    }
    UITouch *touch = [touches anyObject];
    //离开时point
    CGPoint currentP = [touch locationInView:self];
    if (self.toucheDelegate && [self.toucheDelegate respondsToSelector:@selector(toucheView:didEndPoint:)]) {
        [self.toucheDelegate toucheView:self didEndPoint:currentP];
    }
    
}
//触摸结束前，某个系统事件(例如电话呼入)会打断触摸过程，系统会自动调用view的下面方法
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (!self.isAllowTouche) {
        return;
    }
    
}
@end

@implementation UIView (Image)

//将UIView转成UIImage
- (UIImage *)getImage {
    return [self getImageWithScale:self.layer.contentsScale];
}
//将UIView转成UIImage
- (UIImage *)getImageWithScale:(CGFloat)scale {
    //UIGraphicsBeginImageContext(theView.bounds.size);
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/// view 添加毛玻璃效果
- (void)addBlurEffect:(BOOL)isBackground {
    [self addBlurEffect:isBackground alpha:.9];
}
- (void)addBlurEffect:(BOOL)isBackground alpha:(CGFloat)alpha {
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
    
    effe.frame = self.bounds;
    effe.layer.masksToBounds = YES;
    effe.layer.cornerRadius = self.layer.cornerRadius;
    effe.alpha = alpha;
        //把要添加的视图加到毛玻璃上
    [self addSubview:effe];
    if (isBackground) {
        [self sendSubviewToBack:effe];
    } else {
        [self bringSubviewToFront:effe];
    }
}

@end

@implementation UIView (CurrentController)

// 获取当前View的控制器对象
- (UIViewController *)getCurrentViewController {
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

@end
