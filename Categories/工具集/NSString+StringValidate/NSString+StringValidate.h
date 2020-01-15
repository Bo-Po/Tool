//
//  NSString+StringValidate.h
//
//
//  Created by Alfred on 14/1/10.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StringValidate)

-(BOOL)validateEmail;
-(BOOL)validatePhoneNumber;
-(BOOL)validateUserNameNoChar;//纯数字
-(BOOL)validateUserVerifyCode;//验证码
-(BOOL)validateUserName;
-(BOOL)validateUserNameNoNumber;//纯字母

-(BOOL)checkPassword;
-(BOOL)validateBlank;

+ (int)convertToInt:(NSString*)strtemp;
/**
 验证公司名称

 @return return value description
 */
-(BOOL)validateCompanyName;
/**
 验证昵称

 @return return value description
 */
-(BOOL)validateNick;

//验证提示信息
+ (NSString *)validateUserName:(NSString *)userName;
+ (NSString *)checkPassword:(NSString *)pwd;
+ (NSString *)validateEmail:(NSString *)email;
+ (NSString *)validateAccount:(NSString *)account;
+ (NSString *)validatePhoneNumber:(NSString *)phone;
+ (NSString *)validateUserVerifyCode:(NSString *)code;
+ (NSString *)validateTaxNumber:(NSString *)taxNumber;
+ (NSString *)compareNewPwd:(NSString *)newPwd confirmPwd:(NSString *)confirmPwd;

/// 属性字符串
+ (NSAttributedString *)attributedStringWithStrings:(NSArray<NSString *> *)strings fonts:(NSArray<UIFont *> *)fonts colors:(NSArray<UIColor *> *)colors;
+ (NSAttributedString *)attributedStringWithStrings:(NSArray<NSString *> *)strings fonts:(NSArray<UIFont *> *)fonts colors:(NSArray<UIColor *> *)colors spacingRow:(CGFloat)spacing alignment:(NSString *)alignment;
+ (NSAttributedString *)attributedStringWithStrings:(NSArray<NSString *> *)strings fonts:(NSArray<UIFont *> *)fonts colors:(NSArray<UIColor *> *)colors links:(NSArray<NSNumber *> *)links;
- (NSAttributedString *)attributedStringWithString:(NSString *)string color:(UIColor *)color;
/// 添加行间距
- (NSAttributedString *)attributedStringSpacingRow:(CGFloat)spacing;

- (BOOL)adjectiveValidatePassword;
- (BOOL)validateCharacters;
///是否含有表情
- (BOOL)stringContainsEmoji;
/// 数字转汉字
+ (NSString *)chineseStringWithInteger:(NSInteger)value;
@end
