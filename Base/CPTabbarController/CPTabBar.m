//
//  CPTabBar.m
//  XianYu
//
//  Created by li  bo on 16/5/28.
//  Copyright © 2016年 li  bo. All rights reserved.
//

#import "CPTabBar.h"
#import "CPImageView.h"
#import <objc/runtime.h>

@interface CPTabBar () {
    int _index;
    CGFloat _offset;
}

/** plus按钮 */
@property (nonatomic, strong) UIButton *plusBtn;

@property(nonatomic,strong)UIImageView *addView;
@property(nonatomic,strong)UILabel *titleLbl;

@property (nonatomic, strong) UIView *customBigView;
@property (nonatomic, strong) CPImageView *shadowImageLayer;

@end

@implementation CPTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
//        [self addSubview:self.plusBtn];
//
//        UIImageView *img = [[UIImageView alloc] init];
//        img.image = [UIImage imageNamed:@"app_center"];
//        img.userInteractionEnabled = YES;
//        img.tag = 10011;
//        self.addView = img;
//
//        UILabel *label = [[UILabel alloc] init];
//        label.text = @"发布";
//        label.font = [UIFont systemFontOfSize:10];
//        [label sizeToFit];
//        label.textColor = [UIColor grayColor];
//        label.tag = 12580;
//        [self addSubview:label];
//        self.titleLbl = label;
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hanleTap:)];
//        [img addGestureRecognizer:tap];
//        [self addSubview:img];
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    
    NSInteger count = self.items.count;

    CGFloat w = self.bounds.size.width / count;
    int btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            // 如果是索引是2(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来发布按钮的位置
//            if (btnIndex == _index) {
//                btnIndex++;
//            }
            CGRect frame = btn.frame;
            //每一个按钮的宽度
            frame.size.width = w;
            frame.origin.x = frame.size.width * btnIndex;
            if (btnIndex == _index) {
                frame.origin.y = frame.origin.y - _offset;
                frame.size.height = frame.size.height + _offset;
                _customBigView = btn;
                [self.shadowImageLayer setArcCenterOfCircle:CGPointMake(CGRectGetMidX(frame), _offset+15) offset:_offset+5 radius:_offset+10.f];
                self.shadowImageLayer.frame = CGRectMake(0, -(_offset+5), self.frame.size.width, _offset+5+self.frame.size.height);
            }
            btn.frame = frame;
            btnIndex++;
        }
    }
    [self sendSubviewToBack:self.shadowImageLayer];
}

- (void)setBigItem:(int)index {
    _index = index;
}

- (void)setBigItem:(int)index offset:(CGFloat)offset {
    _index = index;
    _offset = offset;
}

//点击了发布按钮
- (void)plusBtnDidClick
{
    _plusBtn.selected = YES;
    //如果tabbar的代理实现了对应的代理方法，那么就调用代理的该方法
    if ([self.delegate respondsToSelector:@selector(tabBarPlusBtnClick:)]) {
        [self.myDelegate tabBarPlusBtnClick:self];
    }
}

-(void)hanleTap:(UITapGestureRecognizer *)tap
{
    _addView.image = [UIImage imageNamed:@"app_center_press"];
    if ([self.delegate respondsToSelector:@selector(tabBarPlusBtnClick:)]) {
        [self.myDelegate tabBarPlusBtnClick:self];
    }
}

- (void)setShowShadow:(BOOL)showShadow {
    if (_showShadow == showShadow) {
        return;
    }
    _showShadow = showShadow;
    if (_showShadow) {
        [self addSubview:self.shadowImageLayer];
    } else {
        _shadowImageLayer = nil;
    }
}
- (UIButton *)plusBtn {
    if (!_plusBtn) {
        _plusBtn = [[UIButton alloc] init];
        [_plusBtn addTarget:self action:@selector(plusBtnDidClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _plusBtn;
}

- (CPImageView *)shadowImageLayer {
    if (!_shadowImageLayer && _showShadow) {
        _shadowImageLayer = [[CPImageView alloc] init];
    }
    return _shadowImageLayer;
}

//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:_customBigView];
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ([_customBigView pointInside:newP withEvent:event]) {
            return _customBigView;
        }else{//如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    } else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

@end
