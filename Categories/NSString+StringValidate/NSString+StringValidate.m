//
//  NSString+StringValidate.m
//
//
//  Created by Alfred on 14/1/10.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "NSString+StringValidate.h"

@implementation NSString (StringValidate)
-(BOOL)validateUserName
{
//    NSString *RegEx =@"^[\\d\\w_]{5,20}$";
	//NSString *RegEx = @"^\\S{1,50}$";//dfhe
    NSString *RegEx = @"^[a-z0-9A-Z\u4e00-\u9fa5]+$";//dfhe
    
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", RegEx];
	BOOL isCorrect = [regExPredicate evaluateWithObject:[self lowercaseString]];
    return isCorrect ? YES : NO;
    
    //中文{2,10}
    //字母{4,20}
    // /  ^[a-z0-9A-Z]${4,20}  /
}

-(BOOL)validateUserNameNoChar
{
    NSString *phoneNumberRegEx =@"^[\\d_]{5,20}$";
	
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumberRegEx];
	BOOL isCorrect = [regExPredicate evaluateWithObject:[self lowercaseString]];
    return isCorrect ? YES : NO;
}
-(BOOL)validateUserVerifyCode
{
    NSString *phoneNumberRegEx =@"^[\\d_]{4,4}$";
	
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumberRegEx];
	BOOL isCorrect = [regExPredicate evaluateWithObject:[self lowercaseString]];
    return isCorrect ? YES : NO;
}

-(BOOL)validateUserNameNoNumber
{
    NSString *phoneNumberRegEx = @"^[a-zA-Z]*$";
	
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumberRegEx];
	BOOL isCorrect = [regExPredicate evaluateWithObject:[self lowercaseString]];
    return isCorrect ? YES : NO;
}
-(BOOL)validatePhoneNumber
{
    NSString *phoneNumberRegEx =@"^1[3|4|5|6|7|8|9][0-9]{9}$";//@"^(13[0-9]|15[0|3|6|7|8|9]|18[6|8|9])\\d{8}$";
	
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumberRegEx];
	BOOL isCorrect = [regExPredicate evaluateWithObject:[self lowercaseString]];
    return isCorrect ? YES : NO;
    
    
}

-(BOOL)validateEmail{
    
    NSString *mailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	
	NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mailRegEx];
	BOOL isCorrect = [regExPredicate evaluateWithObject:[self lowercaseString]];
    return isCorrect ? YES : NO;
}

-(BOOL)validateBlank{
    NSString *priceRegEx =@"\\s*";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", priceRegEx];
	BOOL isCorrect = [regExPredicate evaluateWithObject:[self lowercaseString]];
    return isCorrect ? YES : NO;
}
-(BOOL)checkSpace{
    //判断是否有空格
    NSString *priceRegEx =@"^[^\\s]+$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", priceRegEx];
    BOOL isCorrect = [regExPredicate evaluateWithObject:[self lowercaseString]];
    return isCorrect ? YES : NO;
}
- (BOOL)checkPassword
{
//    if (self.length < 6) {
//        return NO;
//    }
//    if (self.length > 16) {
//        return NO;
//    }
//    return YES;
    
    /*
        1，不能全部是数字
        2，不能全部是字母
        3，必须是数字或字母
        只要能同时满足上面3个要求就可以了，写出来如下：^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,16}$
     
         ^ 匹配一行的开头位置
         (?![0-9]+$) 预测该位置后面不全是数字
         (?![a-zA-Z]+$) 预测该位置后面不全是字母
         [0-9A-Za-z] {8,16} 由8-16位数字或这字母组成
         $ 匹配行结尾位置
     */
    NSString *priceRegEx =@"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", priceRegEx];
	BOOL isCorrect = [regExPredicate evaluateWithObject:[self lowercaseString]];
    return isCorrect ? YES : NO;
    /*
    if(pwd.length == 0){  
        return NO;//@"请填写密码";
    }
    
    if(pwd.length > 50){
        return NO;//@"密码长度太长";
    }
    
    if(pwd.length<6){
        return NO;// @"密码长度太短";
    }
    if([pwd validateUserNameNoChar] == YES)
    {
        return NO;//@"密码不能为纯数字";
    }
    if([pwd validateUserNameNoNumber] == YES)
    {
        return NO;//@"密码不能为纯字母";
    }
    
    return YES;*/
}

-(BOOL)validateCompanyName {
    NSString *other = @"➋➌➍➎➏➐➑➒";     //九宫格的输入值
    unsigned long len=self.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[self characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a==' '))
             ||((a >= 0x4e00 && a <= 0x9fa6))
             ||([other rangeOfString:self].location != NSNotFound)
             )){
            if ([self isEqualToString:@"("] || [self isEqualToString:@")"] || [self isEqualToString:@"（"] || [self isEqualToString:@"）"] || [self isEqualToString:@"（）"] || [self isEqualToString:@"()"]) {
                return YES;
            }else{
                return NO;
            }
        }
    }
    return YES;
}

-(BOOL)validateNick {
    NSString *other = @"➋➌➍➎➏➐➑➒";     //九宫格的输入值
    unsigned long len=self.length;
    for(int i=0;i<len;i++)
    {
        unichar a=[self characterAtIndex:i];
        if(!((isalpha(a))
             ||(isalnum(a))
             ||((a==' '))
             ||((a >= 0x4e00 && a <= 0x9fa6))
             ||([other rangeOfString:self].location != NSNotFound)
             ))
            return NO;
    }
    return YES;
}

+ (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+(NSString *)validateUserName:(NSString *)userName
{
    int charLength = userName.length;
    if(![userName validateUserName]){
        if([userName length] == 0){
            return @"请输入昵称";
        }
        return @"不能含有特殊字符";
    }
    if (charLength > 13) {
        return @"昵称最多支持13个字符";
    }
//    if ( charLength > 20) {
//        return @"昵称支持2-10 汉字或 4-20 字母，可输入中文、字母、数字";
//    }
    return nil;
}

+(NSString *)validateUserVerifyCode:(NSString *)code
{
    if(![code validateUserVerifyCode]){
        if([code length] == 0){
            return @"验证码不为空";
        }
        return @"验证码格式错误";
    }
    return nil;
}

+ (NSString *)checkPassword:(NSString *)pwd
{
    if(![pwd checkPassword]){
        if([pwd length] == 0){
            return @"密码不能为空";
        }
        if ([pwd length] < 6) {
            return @"密码不能少于6位";
        }
        if ([pwd length] > 12) {
            return @"密码不能超过12位";
        }
        return @"密码仅支持大小写字母，数字";
    }
    if (![pwd checkSpace]) {
        return @"密码仅支持大小写字母，数字";
    }
    return nil;
}

+ (NSString *)validateAccount:(NSString *)account {
    if(![account validatePhoneNumber]){
        if([account length] == 0){
            return @"账号不能为空";
        }
        return @"账号格式错误";
    }
    return nil;
}

+ (NSString *)validatePhoneNumber:(NSString *)phone
{
    if(![phone validatePhoneNumber]){
        if([phone length] == 0){
            return @"手机号码不能为空";
        }
        return @"手机号码格式错误";
    }
    return nil;
}

+ (NSString *)validateEmail:(NSString *)email
{
    if(![email validateEmail]){
        if([email length] == 0){
            return @"邮箱不为空";
        }
        return @"邮箱格式错误";
    }
    return nil;
}


+ (NSString *)validateTaxNumber:(NSString *)taxNumber {

    if (![taxNumber validateTaxNumber]) {
        if ([taxNumber length] < 10) {
            return @"纳税人识别码不能少于10位";
        }
        if ([taxNumber length] > 20) {
            return @"纳税人识别码不能大于20位";
        }
        return @"纳税人识别码格式错误";
    }
    return nil;
}

-(BOOL)validateTaxNumber{
    
    NSString *taxRegEx = @"^[0-9A-Z]{10,20}$";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", taxRegEx];
    BOOL isCorrect = [regExPredicate evaluateWithObject:self];
    return isCorrect ? YES : NO;
}


+ (NSString *)compareNewPwd:(NSString *)newPwd confirmPwd:(NSString *)confirmPwd {
    if (![newPwd isEqualToString:confirmPwd]) {
        return @"两次输入的密码不一致";
    }
    return nil;
}

+ (NSAttributedString *)attributedStringWithStrings:(NSArray<NSString *> *)strings fonts:(NSArray<UIFont *> *)fonts colors:(NSArray<UIColor *> *)colors {
    __block NSMutableAttributedString * firstPart = [[NSMutableAttributedString alloc] initWithString:@""];
    if (strings && strings.count > 0) {
        [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableAttributedString * otherPart = [[NSMutableAttributedString alloc] initWithString:obj];
            NSDictionary * otherAttributes = @{NSFontAttributeName:fonts[idx],NSForegroundColorAttributeName:colors[idx]};
            [otherPart setAttributes:otherAttributes range:NSMakeRange(0,otherPart.length)];
            [firstPart appendAttributedString:otherPart];
        }];
    }
    return firstPart;
}

- (NSAttributedString *)attributedStringWithString:(NSString *)string color:(UIColor *)color {
    __block NSMutableAttributedString * part = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange rangel = [[part string] rangeOfString:string];
    [part addAttribute:NSForegroundColorAttributeName value:color range:rangel];
//    [part addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:rangel];
    return part;
}

- (BOOL)adjectiveValidatePassword {
    NSString *taxRegEx = @"^[0-9A-Za-z]{0,12}$";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", taxRegEx];
    BOOL isCorrect = [regExPredicate evaluateWithObject:self];
    return isCorrect ? YES : NO;
}

- (BOOL)validateCharacters {
    NSString *taxRegEx = @"^[0-9A-Za-z]{0,100}$";
    
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", taxRegEx];
    BOOL isCorrect = [regExPredicate evaluateWithObject:self];
    return isCorrect ? YES : NO;
}
//是否含有表情
- (BOOL)stringContainsEmoji {
    __block BOOL returnValue = NO;
    
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (substring.length > 1) {
                                    if (0xd800 <= hs && hs <= 0xdbff) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                            *stop = YES;
                                        }
                                    }
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                    }
                                    returnValue = YES;
                                    *stop = YES;
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                        *stop = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                        *stop = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                        *stop = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                        *stop = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                        *stop = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

@end
