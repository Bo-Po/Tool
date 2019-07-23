//
//  UITextField+TextLength.m
//  test
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UITextField+TextLength.h"
#import <objc/runtime.h>

static NSString * old_text_key;

@implementation UITextField (TextLength)

- (instancetype)awakeAfterUsingCoder:(NSCoder *)aDecoder {
    if (self == [super awakeAfterUsingCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setLength:(NSInteger)length {
    objc_setAssociatedObject(self, @selector(length), @(length), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(byteLength), @(0), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(charLength), @(0), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)length {
    return [objc_getAssociatedObject(self, @selector(length)) integerValue];
}

- (void)setCharLength:(NSInteger)charLength {
    objc_setAssociatedObject(self, @selector(length), @(0), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(byteLength), @(0), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(charLength), @(charLength), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)charLength {
    return [objc_getAssociatedObject(self, @selector(charLength)) integerValue];
}

- (void)setByteLength:(NSInteger)byteLength {
    objc_setAssociatedObject(self, @selector(length), @(0), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(charLength), @(0), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(byteLength), @(byteLength), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)byteLength {
    return [objc_getAssociatedObject(self, @selector(byteLength)) integerValue];
}

- (void)setDidTextChange:(TextFieldValueChange)didTextChange {
    objc_setAssociatedObject(self, @selector(didTextChange), didTextChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (TextFieldValueChange)didTextChange {
    return objc_getAssociatedObject(self, @selector(didTextChange));
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    // 如拼音输入时，拼音字母处于选中状态，此时不判断是否超长
    UITextRange *selectedRange = [self markedTextRange];
    if (!selectedRange || !selectedRange.start) {
        NSString *text = self.text;
        if ([old_text_key isEqualToString:text]) {
            return;
        }
        if (self.length) {
            while (text.length > self.length) {
                text = [text substringToIndex:self.length];
            }
            NSLog(@"self.text.length   ===   %ld",text.length);
        }
        if (self.charLength) {
            //        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            while ([self textLength:text] > self.charLength) {
                text = [text substringToIndex:text.length-1];
            }
            NSLog(@"self.text.charLength   ===   %ld",[self textLength:text]);
        }
        if (self.byteLength) {
            while ([text lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > self.byteLength) {
                text = [text substringToIndex:text.length-1];
            }
            NSLog(@"self.text.byteLength   ===   %ld",[text lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        }
        self.text = text;
        if (![text isEqualToString:old_text_key]) {
            old_text_key = self.text;
            TextFieldValueChange block = self.didTextChange;
            if (block) {
                block(old_text_key);
            }
        }
    }
}

- (NSUInteger)textLength:(NSString *)text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength;
    return unicodeLength;
}

@end
