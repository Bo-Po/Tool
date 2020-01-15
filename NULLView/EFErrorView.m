//
//  EFErrorView.m
//  haizeimi
//
//  Created by xiaoliZhang on 14-11-10.
//  Copyright (c) 2014年 antonyzhao. All rights reserved.
//

#import "EFErrorView.h"
//#import "UIView+GMAdditions.h"

@interface EFErrorView()
{
    UIImageView *_imageView;
    UILabel *_titleLabel;
    UIImage *_image;
    BOOL _isAdaption;
}
@end

@implementation EFErrorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kRGBA(255, 255, 255, 1.0);
        self.tag = 404;
        UIImage *errorImage = [UIImage imageNamed:@"error"];
        _image = errorImage;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - errorImage.size.width) / 2, (CGRectGetHeight(self.frame) - 44. - Size_StatuBarHeight - errorImage.size.height) / 2, errorImage.size.width, errorImage.size.height)];
        _imageView.image = errorImage;
        [self addSubview:_imageView];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_titleLabel];
        [self showErrorView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorViewRefreshed)];
        [self addGestureRecognizer:tapGesture];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_isAdaption) {
        _imageView.frame = CGRectMake((CGRectGetWidth(self.frame) - _image.size.width) / 2, (CGRectGetHeight(self.frame) - _image.size.height) / 2 - 80, _image.size.width, _image.size.height);
        _titleLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, _imageView.frame.origin.y + _imageView.frame.size.height + 20);
    } else {
        _imageView.frame = CGRectMake((Size_ScreenWidth - _image.size.width) / 2, (CGRectGetHeight(self.frame) - _image.size.height) / 2 - 80, _image.size.width, _image.size.height);
        _titleLabel.center = CGPointMake(Size_ScreenWidth/2, _imageView.frame.origin.y + _imageView.frame.size.height + 20);
    }
}

- (void)setErrorTitle:(NSString *)title errorImage:(UIImage *)image isAdaption:(BOOL)isAdaption {
    self.hidden = NO;
    [self setTitle:title image:image subTitle:nil isAdaption:isAdaption];
}

- (void)setTitle:(NSString *)title image:(UIImage *)image subTitle:(NSString *)subTitle isAdaption:(BOOL)isAdaption
{
    _image = image;
    _imageView.image = image;
    _isAdaption = isAdaption;
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    if (isAdaption) {
        _imageView.frame = CGRectMake((CGRectGetWidth(self.frame) - image.size.width) / 2, (CGRectGetHeight(self.frame) - image.size.height) / 2 - 80, image.size.width, image.size.height);
        _titleLabel.center = CGPointMake(CGRectGetWidth(self.frame)/2, _imageView.frame.origin.y + _imageView.frame.size.height + 20);
    } else {
        _imageView.frame = CGRectMake((Size_ScreenWidth - image.size.width) / 2, (CGRectGetHeight(self.frame) - image.size.height) / 2 - 80, image.size.width, image.size.height);
        _titleLabel.center = CGPointMake(Size_ScreenWidth/2, _imageView.frame.origin.y + _imageView.frame.size.height + 20);
    }
    
}

- (void)errorViewRefreshed
{
    if (_clickBlock) {
        _clickBlock();
    }
}

- (void)showErrorView
{
    self.hidden = NO;
    [self setTitle:@"网络不给力！请检查设置" image:[UIImage imageNamed:@"load_faild"] subTitle:@"点击屏幕重新加载" isAdaption:YES];
}

@end
