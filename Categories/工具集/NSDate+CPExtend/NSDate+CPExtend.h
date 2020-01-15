//
//  NSDate+CPExtend.h
//  OCTest
//
//  Created by 陈波 on 2019/7/30.
//  Copyright © 2019 陈波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (CPExtend)

// string 参数格式 yyyyMMdd
+ (NSString *)stringFormatWithString:(NSString *)string;
+ (NSString *)stringFormatWithString:(NSString *)string fromFormat:(NSString *)from toFormat:(NSString *)to;


- (NSString *)dateFormat:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
