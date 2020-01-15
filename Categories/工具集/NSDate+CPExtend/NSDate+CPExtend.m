//
//  NSDate+CPExtend.m
//  OCTest
//
//  Created by 陈波 on 2019/7/30.
//  Copyright © 2019 陈波. All rights reserved.
//

#import "NSDate+CPExtend.h"

@implementation NSDate (CPExtend)

+ (NSString *)stringFormatWithString:(NSString *)string {
    return [self stringFormatWithString:string fromFormat:@"yyyyMMdd" toFormat:@"yyyy-MM-dd"];
}

+ (NSString *)stringFormatWithString:(NSString *)string fromFormat:(NSString *)from toFormat:(NSString *)to {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:from];
    NSDate *birthdayDate = [dateFormatter dateFromString:string];
    if (!birthdayDate) {
        return nil;
    }
    [dateFormatter setDateFormat:to];
    return [dateFormatter stringFromDate:birthdayDate];
}

- (NSString *)dateFormat:(NSString *)format {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

@end
