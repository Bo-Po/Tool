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

@property (nonatomic, assign) NSInteger length;
@property (nonatomic, assign) NSInteger charLength;
@property (nonatomic, assign) NSInteger byteLength;
@property (nonatomic, copy) TextFieldValueChange didTextChange;

@end
