//
//  UITextField+TextLength.h
//  test
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextFieldValueChange)(id text);

@interface UITextField (TextLength)

@property (nonatomic, assign) IBInspectable NSInteger length;
@property (nonatomic, assign) IBInspectable NSInteger charLength;
@property (nonatomic, assign) IBInspectable NSInteger byteLength;
@property (nonatomic, copy) TextFieldValueChange didTextChange;

@end
