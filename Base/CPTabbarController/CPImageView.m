//
//  CPImageView.m
//  OCTest
//
//  Created by 陈波 on 2019/7/15.
//  Copyright © 2019 陈波. All rights reserved.
//

#import "CPImageView.h"

@interface CPImageView () {
    CGPoint _centerOfCircle;
    CGFloat _radius;
    CGFloat _offset;
}

@end

@implementation CPImageView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGSize size = self.bounds.size;
    CGFloat chordHalf = sqrt(_radius*_radius-((_centerOfCircle.y-_offset)*(_centerOfCircle.y-_offset)));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 10.0f, [UIColor grayColor].CGColor);//添加阴影
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(context, 0.f, size.height);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, size.width, _offset);
    CGContextAddLineToPoint(context, _centerOfCircle.x+chordHalf, _offset);
    CGContextAddArc(context, _centerOfCircle.x, _centerOfCircle.y, _radius, asin((_centerOfCircle.y-_offset)/_radius), M_PI+asin((_centerOfCircle.y-_offset)/_radius), YES);
    CGContextAddLineToPoint(context, 0.f, _offset);
    CGContextClosePath(context);
    CGContextFillPath(context);
    [super drawRect:rect];
    if (kIsShowLog) {
        NSLog(@"acos((_radius-_offset)/_radius) = =  %f",acos((_radius-_offset)/_radius)*2);
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

- (void)setArcCenterOfCircle:(CGPoint)center offset:(CGFloat)offset radius:(CGFloat)radius {
    _centerOfCircle = center;
    _radius = radius;
    _offset = offset;
    [self setNeedsDisplay];
}

@end
