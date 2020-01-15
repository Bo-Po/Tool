//
//  UIView+CALayer.m
//  shangmen
//
//  Created by 州龚 on 2019/11/20.
//  Copyright © 2019 rzx. All rights reserved.
//

#import "UIView+CALayer.h"
//#import "YYKit.h"

@implementation UIView (CALayer)

- (void)setGradientLayer:(CAGradientLayer *)gradientLayer {
    if (self.gradientLayer) {
        [self.gradientLayer removeFromSuperlayer];
    }
    objc_setAssociatedObject(self, @selector(gradientLayer), gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.layer insertSublayer:gradientLayer atIndex:0];
}
- (CAGradientLayer *)gradientLayer {
    return objc_getAssociatedObject(self, @selector(gradientLayer));
}
- (void)setTextGradientLayer:(CAGradientLayer *)textGradientLayer {
    if (self.superview) {
        [self.superview.layer addSublayer:textGradientLayer];
    }
    objc_setAssociatedObject(self, @selector(textGradientLayer), textGradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CAGradientLayer *)textGradientLayer {
    return objc_getAssociatedObject(self, @selector(textGradientLayer));
}
- (void)setTextGradientDirection:(CPGradientDirection)textGradientDirection {
    if (!self.textGradientLayer) {
        self.textGradientLayer = [[CAGradientLayer alloc] init];
    }
    CGPoint start;
    CGPoint end;
    if (textGradientDirection == CPGradientDirectionHorizontal) {
        start = CGPointMake(0, 0.5);
        end = CGPointMake(1, 0.5);
    } else if (textGradientDirection == CPGradientDirectionVertical) {
        start = CGPointMake(0.5, 0.);
        end = CGPointMake(0.5, 1.);
    } else if (textGradientDirection == CPGradientDirectionOblique) {
        start = CGPointMake(0, 0.0);
        end = CGPointMake(1, 1.);
    } else {
        start = CGPointMake(0, 0.5);
        end = CGPointMake(1, 0.5);
    }
    self.textGradientLayer.startPoint = start;
    self.textGradientLayer.endPoint = end;
    self.textGradientLayer.frame = self.frame;
    self.textGradientLayer.mask = self.layer;
    
    objc_setAssociatedObject(self, @selector(textGradientDirection), @(textGradientDirection), OBJC_ASSOCIATION_ASSIGN);
}
- (CPGradientDirection)textGradientDirection {
    return [objc_getAssociatedObject(self, @selector(textGradientDirection)) integerValue];
}
- (void)layoutSubviews {
    self.gradientLayer.frame = self.bounds;
}

static NSString *kViewLineShowLine = @"view_show_line";
static NSString *kViewLineLineLayer = @"view_line_layer";

- (void)setCp_showLine:(BOOL)cp_showLine {
    objc_setAssociatedObject(self, &kViewLineShowLine, @(cp_showLine), OBJC_ASSOCIATION_ASSIGN);
    if (!self.cp_lineLayer) {
        self.cp_lineLayer = [[CALayer alloc] init];
        [self layoutIfNeeded];
        [self setNeedsLayout];
        self.cp_lineLayer.frame = CGRectMake(0, self.cp_height-.25, self.cp_width, .5);
        self.cp_lineLayer.backgroundColor = kColor_Line.CGColor;
        [self.layer addSublayer:self.cp_lineLayer];
    }
    self.cp_lineLayer.hidden = !cp_showLine;
}

- (BOOL)isCp_showLine {
    return [objc_getAssociatedObject(self, &kViewLineShowLine) boolValue];
}

- (void)setCp_lineLayer:(CALayer *)cp_lineLayer {
    objc_setAssociatedObject(self, &kViewLineLineLayer, cp_lineLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CALayer *)cp_lineLayer {
    return objc_getAssociatedObject(self, &kViewLineLineLayer);
}

- (void)setImages:(NSArray<UIImage *> *)images {
    objc_setAssociatedObject(self, @selector(images), images, OBJC_ASSOCIATION_COPY);
    NSMutableArray *muarr = [[NSMutableArray alloc] initWithArray:[self layers]];
    for (; muarr.count < images.count; ) {
        CALayer *layer = [[CALayer alloc] init];
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer.backgroundColor = UIColor.groupTableViewBackgroundColor.CGColor;
        layer.masksToBounds = YES;
        [muarr addObject:layer];
    }
    [self setLayers:muarr];
//    [self configImageDisplay:images];
}
- (NSArray<UIImage *> *)images {
    return objc_getAssociatedObject(self, @selector(images));
}

- (void)setImageUrls:(NSArray *)imageUrls {
    objc_setAssociatedObject(self, @selector(imageUrls), imageUrls, OBJC_ASSOCIATION_COPY);
    self.images = nil;
    NSMutableArray *muarr = [[NSMutableArray alloc] initWithArray:[self layers]];
    for (; muarr.count < imageUrls.count; ) {
        CALayer *layer = [[CALayer alloc] init];
        layer.contentsGravity = kCAGravityResizeAspectFill;
        layer.backgroundColor = UIColor.groupTableViewBackgroundColor.CGColor;
        layer.masksToBounds = YES;
        [muarr addObject:layer];
    }
    [self setLayers:muarr];
//    [self configImageDisplay:imageUrls];
}
- (NSArray *)imageUrls {
    return objc_getAssociatedObject(self, @selector(imageUrls));
}

- (void)setLayers:(NSArray *)layers {
    objc_setAssociatedObject(self, @selector(layers), layers, OBJC_ASSOCIATION_COPY);
}
- (NSArray *)layers {
    return objc_getAssociatedObject(self, @selector(layers));
}

//- (void)configImageDisplay:(NSArray *)array {
//    [[self layers] enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj removeFromSuperlayer];
//    }];
//    for (id obj in array) {
//        NSUInteger idx = [array indexOfObject:obj];
//        CALayer *layer = [[self layers] objectAtIndex:idx];
//        if ([obj isKindOfClass:[UIImage class]]) {
//            layer.contents = (__bridge id _Nullable)(((UIImage *)obj).CGImage);
//        } else if ([obj isKindOfClass:[NSURL class]]) {
//            [layer setImageWithURL:obj placeholder:kDefaultImage];
//        } else {
//            [layer setImageWithURL:Code_UrlFromString(obj) placeholder:kDefaultImage];
//        }
//    }
//    if (array.count == 1) {
//        CALayer *layer = [[self layers] firstObject];
//        layer.frame = self.bounds;
//        [self.layer addSublayer:layer];
//    } else if (array.count == 2) {
//        CALayer *layer_temporary = nil;
//        for (int i=0; i<2; i++) {
//            CGFloat w = self.cp_width/2.-1;
//            CALayer *layer = [[self layers] objectAtIndex:i];
//            layer.frame = CGRectMake(i*(w+2), 0, w, self.cp_height);
//            if (layer_temporary) {
//                [self.layer insertSublayer:layer above:layer_temporary];
//            } else {
//                [self.layer addSublayer:layer];
//            }
//        }
//    } else if (array.count == 3) {
//        CALayer *layer_temporary = nil;
//        for (int i=0; i<3; i++) {
//            CGFloat w = self.cp_width/2.-1;
//            CGFloat h = self.cp_height/2.-1;
//            CALayer *layer = [[self layers] objectAtIndex:i];
//            if (i==0) {
//                layer.frame = CGRectMake(0, 0, w, self.cp_height);
//            } else {
//                NSInteger idx = i-1;
//                layer.frame = CGRectMake(w+2, idx*(h+2), w, h);
//            }
//            if (layer_temporary) {
//                [self.layer insertSublayer:layer above:layer_temporary];
//            } else {
//                [self.layer addSublayer:layer];
//            }
//        }
//    } else if (array.count == 4) {
//        CALayer *layer_temporary = nil;
//        for (int i=0; i<4; i++) {
//            CGFloat w = self.cp_width/2.-1;
//            CGFloat h = self.cp_height/2.-1;
//            CALayer *layer = [[self layers] objectAtIndex:i];
//            layer.frame = CGRectMake((i%2)*(w+2), (i/2)*(h+2), w, h);
//            if (layer_temporary) {
//                [self.layer insertSublayer:layer above:layer_temporary];
//            } else {
//                [self.layer addSublayer:layer];
//            }
//        }
//    }
//
//}

    //将layer转成UIImage
+ (UIImage *)imageFormLayer:(CALayer *)layer {
    return [self imageFormLayer:layer scale:layer.contentsScale];
}
+ (UIImage *)imageFormLayer:(CALayer *)layer scale:(CGFloat)scale {
        //UIGraphicsBeginImageContext(theView.bounds.size);
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
