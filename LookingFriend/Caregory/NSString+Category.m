//
//  NSString+ITTAdditions.m
//
//  Created by Jack on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSString+Category.h"
#import "NSDate+Category.h"
#import "UIColor+Category.h"

//邮箱的正则表达式
#define EMAILREG               @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

//用户名的正则表达式   中英文、数字、下划线，至少2个字符,至多20
#define NAMEREG                @"^[\\w\\u4e00-\\u9fa5]{2,20}$"

//密码的正则表达式   以字母开头，长度在6~18之间，只包含英文、数字和下划线
//#define PASSWORDREG @"^[a-zA-Z]\\w{5,17}$"
//密码的正则表达式   修改后规则：长度在8~18之间，只包含英文、数字和下划线
#define PASSWORDREG            @"^(?![0-9]+$)(?![a-z]+$)(?![A-Z]+$)(?![~!$()&<>?{},\.#%'+*-:;^_`]+$)[~!$()&<>?{},\.#%'+*-:;^_`0-9A-Za-z]{8,18}$"

//预注册用户密码正则表达式  以M开头＋身份证后6位数
#define PREREGISTERPASSWORDREG @"^[M]\\w{6}$"

//手机号的正则表达式
#define PHONEREG               @"^1[3456789][\\d]{9}$"

//邮编的正则表达式
#define POSTCODEREG            @"^[\\d]{6}$"

//图片格式验证
#define PICTURESTYLEREG        @"/.+(\\.jpg|\\.jpeg|\\.gif|\\ .png)$/i"

//验证中文
#define CHINESEREG             @"[^\u4e00-\u9fa5]"

//字母和数字
#define CHARSNUMREG            @"^[0-9a-z]+$/i"

//社保卡
#define SOCIALCARDSREG         @"^[A-Za-z0-9]{0,30}$/i"

//身份证号
#define IDCARDREG              @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$"

#define PASSPORD               @"/^1[45][0-9]{7}$|(^[P|p|S|s]\d{7}$)|(^[S|s|G|g|E|e]\d{8}$)|(^[Gg|Tt|Ss|Ll|Qq|Dd|Aa|Ff]\d{8}$)|(^[H|h|M|m]\d{8,10}$)/"

@implementation NSString (Category)

/** 判断字符创是否为空 */
+ (NSString *)safeText:(NSString *)string {
    if ([string isKindOfClass:[NSNumber class]]) {
        string = [(NSNumber *)string stringValue];
    }
    return IsEmptyString(string) ? @"" : string;
}

/** 判断字符创是否为空 */
+ (BOOL)isEmptyString:(NSString *)string {
    return !([string isKindOfClass:[NSString class]] && string.length);
}


- (CGFloat)heightWithFont:(UIFont *)font
            withLineWidth:(NSInteger)lineWidth {
  
    CGSize size = [self sizeWithFont:font
                   constrainedToSize:CGSizeMake(lineWidth, CGFLOAT_MAX)
                       lineBreakMode:NSLineBreakByTruncatingTail];
    return size.height;
}

////////////
//- (CGSize)sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
//{
//    NSDictionary *attributes = @{NSFontAttributeName: font};
//
//    return [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
//}
//-(CGSize)sizeWithFont:(UIFont *)font
//{
//        return [self sizeWithAttributes:@{NSFontAttributeName:font}];
//}
//- (CGSize)sizeWithFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
//{
//    NSDictionary *attributes = @{NSFontAttributeName: font};
//    return [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
//}
//////////////////

- (NSString *)sha1 {
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);

    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }

    return result;
}

- (NSString *)md5 {
    const char *concat_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(concat_str, (CC_LONG)strlen(concat_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return [hash lowercaseString];
}

- (NSString *)encodeUrl {
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    return @"";
}

- (NSString *)changeStringWithAsterisk:(NSInteger)startLocation length:(NSInteger)length {
    if (self.length < 11) {
        return @"后台数据错误";
    }
    
    NSString *replaceStr = self;
    for (NSInteger i = 0; i < length; i++) {
        NSRange range = NSMakeRange(startLocation, 1);
        replaceStr = [replaceStr stringByReplacingCharactersInRange:range withString:@"*"];
        startLocation ++;
    }
    return replaceStr;
}

- (BOOL)isStartWithString:(NSString *)start {
    BOOL result = FALSE;
    NSRange found = [self rangeOfString:start options:NSCaseInsensitiveSearch];
    if (found.location == 0) {
        result = TRUE;
    }
    return result;
}

- (BOOL)isEndWithString:(NSString *)end {
    NSInteger endLen = [end length];
    NSInteger len = [self length];
    BOOL result = TRUE;
    if (endLen <= len) {
        NSInteger index = len - 1;
        for (NSInteger i = endLen - 1; i >= 0; i--) {
            if ([end characterAtIndex:i] != [self characterAtIndex:index]) {
                result = FALSE;
                break;
            }
            index--;
        }
    } else {
        result = FALSE;
    }
    return result;
}

- (NSString *)phonetic:(NSString *)sourceString {
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;
}

+ (id)getParameterOfParameterStr:(NSString *)parameterStr {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    NSArray *parameterArr = [parameterStr componentsSeparatedByString:@"&"];
    for (NSString *parameter in parameterArr) {
        NSRange rang = [parameter rangeOfString:@"="];
        NSString *dicKey = [parameter substringToIndex:rang.location];
        NSString *dicValue = nil;
        if (parameter.length > rang.location) {
            dicValue = [parameter substringFromIndex:rang.location + 1];
        }
        if (dic && dicValue) {
            [dic setObject:dicValue forKey:dicKey];
        } else {
            return @"非法字符串";
        }
    }
    return dic;
}

+ (NSString *)encodeToPercentEscapeString:(NSString *)input {
    // Encode all the reserved characters, per RFC 3986

    // (<http://www.ietf.org/rfc/rfc3986.txt>)

    NSString *outputStr = (NSString *)

        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,

                                                                  (CFStringRef)input,

                                                                  NULL,

                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",

                                                                  kCFStringEncodingUTF8));

    return outputStr;
}

+ (NSString *)decodeFromPercentEscapeString:(NSString *)input {
    NSMutableString *outputStr = [NSMutableString stringWithString:input];

    [outputStr replaceOccurrencesOfString:@"+"

                               withString:@" "

                                  options:NSLiteralSearch

                                    range:NSMakeRange(0, [outputStr length])];

    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//Unicode转UTF-8

+ (NSString *)replaceUnicode:(NSString *)aUnicodeString {
    NSString *tempStr1 = [aUnicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];

    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];

    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];

    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];

    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData

                                                           mutabilityOption:NSPropertyListImmutable

                                                                     format:NULL

                                                           errorDescription:NULL];

    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

+ (NSString *)utf8ToUnicode:(NSString *)string {
    NSUInteger length = [string length];

    NSMutableString *s = [NSMutableString stringWithCapacity:0];

    for (int i = 0; i < length; i++) {
        unichar _char = [string characterAtIndex:i];

        //判断是否为英文和数字

        if (_char <= '9' && _char >= '0') {
            [s appendFormat:@"%@", [string substringWithRange:NSMakeRange(i, 1)]];
        } else if (_char >= 'a' && _char <= 'z') {
            [s appendFormat:@"%@", [string substringWithRange:NSMakeRange(i, 1)]];
        } else if (_char >= 'A' && _char <= 'Z') {
            [s appendFormat:@"%@", [string substringWithRange:NSMakeRange(i, 1)]];
        } else {
            [s appendFormat:@"\\u%x", [string characterAtIndex:i]];
        }
    }

    return s;
}

//SH_添加
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000

    CGSize size = CGSizeMake(width, CGFLOAT_MAX);

    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    size = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;

    return size;

#else

    return [self sizeWithFont:font
            constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                lineBreakMode:UILineBreakModeWordWrap];

#endif
}

- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000

    CGSize size = CGSizeMake(CGFLOAT_MAX, height);

    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    size = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;

    return size;

#else

    return [self sizeWithFont:font
            constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                lineBreakMode:UILineBreakModeWordWrap];

#endif
}

/**
*  动态计算文字的宽高（单行）
*  @param
font 文字的字体
*  @return 计算的宽高
*/

- (CGSize)jq_sizeWithFont:(UIFont *)font {
    CGSize theSize;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    theSize = [self sizeWithAttributes:attributes];
    // 向上取整
    theSize.width = ceil(theSize.width);
    theSize.height = ceil(theSize.height);
    return theSize;
}

- (CGSize)jq_sizeWithFont:(UIFont *)font limitSize:(CGSize)limitSize {
    CGSize theSize;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    CGRect rect = [self boundingRectWithSize:limitSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    theSize.width = ceil(rect.size.width);
    theSize.height = ceil(rect.size.height);
    return theSize;
}

- (CGSize)jq_sizeWithFont:(UIFont *)font limitWidth:(CGFloat)limitWidth {
    return [self jq_sizeWithFont:font limitSize:CGSizeMake(limitWidth, MAXFLOAT)];
}

/**
 *  用于验证输入框的内容
 *
 *  @param regText   需要检测的正则表达式
 *  @param candidate 需要检测的字符串
 *
 *  @return 返回的是否为真
 */
+ (BOOL)validate:(NSString *)regText withCandidate:(NSString *)candidate {
    NSPredicate *predicateText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regText];

    return [predicateText evaluateWithObject:candidate];
}

//验证邮箱
+ (BOOL)validateEmail:(NSString *)candidate {
    return [self validate:EMAILREG withCandidate:candidate];
}

//验证姓名
+ (BOOL)validateName:(NSString *)candidate {
    return [self validate:NAMEREG withCandidate:candidate];
}

//手机号
+ (BOOL)validatePhone:(NSString *)candidate {
    return [self validate:PHONEREG withCandidate:candidate];
}

//密码
+ (BOOL)validatePassword:(NSString *)candidate {
    return [self validate:PASSWORDREG withCandidate:candidate];
}

//预注册密码
+ (BOOL)validatePrePassword:(NSString *)candidate {
    return [self validate:PREREGISTERPASSWORDREG withCandidate:candidate];
}

//邮编
+ (BOOL)validatePostCode:(NSString *)candidate {
    return [self validate:POSTCODEREG withCandidate:candidate];
}

//图片格式
+ (BOOL)validatePictureType:(NSString *)candidate {
    return [self validate:PICTURESTYLEREG withCandidate:candidate];
}

//中文
+ (BOOL)validateChinese:(NSString *)candidate {
    return [self validate:CHINESEREG withCandidate:candidate];
}

//包含表情
+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
    {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];

    return returnValue;
}

//字母和数字
+ (BOOL)validateCharNum:(NSString *)candidate {
    return [self validate:CHARSNUMREG withCandidate:candidate];
}

//社保卡号
+ (BOOL)validateSocialCard:(NSString *)candidate {
    return [self validate:SOCIALCARDSREG withCandidate:candidate];
}

//身份证号
//+ (BOOL)validateIDCard:(NSString *)candidate{
//
//    return [self validate:IDCARDREG withCandidate:candidate];
//}
// 精确校验身份证号
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    int length = 0;
    if (!value) {
        return NO;
    } else {
        length = (int)value.length;

        if (length != 15 && length != 18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11", @"12", @"13", @"14", @"15", @"21", @"22", @"23", @"31", @"32", @"33", @"34", @"35", @"36", @"37", @"41", @"42", @"43", @"44", @"45", @"46", @"50", @"51", @"52", @"53", @"54", @"61", @"62", @"63", @"64", @"65", @"71", @"81", @"82", @"91"];

    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag = YES;
            break;
        }
    }

    if (!areaFlag) {
        return false;
    }

    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;

    int year = 0;
    switch (length) {
        case 15:
            year = [value substringWithRange:NSMakeRange(6, 2)].intValue + 1900;

            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];

            if (numberofMatch > 0) {
                return YES;
            } else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6, 4)].intValue;
            if (year % 4 == 0 || (year % 100 == 0 && year % 4 == 0)) {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            } else {
                regularExpression = [[NSRegularExpression alloc] initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];

            if (numberofMatch > 0) {
                int S = ([value substringWithRange:NSMakeRange(0, 1)].intValue + [value substringWithRange:NSMakeRange(10, 1)].intValue) * 7 + ([value substringWithRange:NSMakeRange(1, 1)].intValue + [value substringWithRange:NSMakeRange(11, 1)].intValue) * 9 + ([value substringWithRange:NSMakeRange(2, 1)].intValue + [value substringWithRange:NSMakeRange(12, 1)].intValue) * 10 + ([value substringWithRange:NSMakeRange(3, 1)].intValue + [value substringWithRange:NSMakeRange(13, 1)].intValue) * 5 + ([value substringWithRange:NSMakeRange(4, 1)].intValue + [value substringWithRange:NSMakeRange(14, 1)].intValue) * 8 + ([value substringWithRange:NSMakeRange(5, 1)].intValue + [value substringWithRange:NSMakeRange(15, 1)].intValue) * 4 + ([value substringWithRange:NSMakeRange(6, 1)].intValue + [value substringWithRange:NSMakeRange(16, 1)].intValue) * 2 + [value substringWithRange:NSMakeRange(7, 1)].intValue * 1 + [value substringWithRange:NSMakeRange(8, 1)].intValue * 6 + [value substringWithRange:NSMakeRange(9, 1)].intValue * 3;
                int Y = S % 11;
                NSString *M = @"F";
                NSString *JYM = @"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y, 1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17, 1)]]) {
                    return YES;// 检测ID的校验位
                } else {
                    return NO;
                }
            } else {
                return NO;
            }
        default:
            return NO;
    }
}

+ (BOOL)validateIDCard:(NSString *)sPaperId {
    //return [self validate:IDCARDREG withCandidate:candidate];

    //判断位数
    if (sPaperId.length != 15 && sPaperId.length != 18) {
        return NO;
    }

    if ([sPaperId containsString:@"x"]) {
        sPaperId = [sPaperId stringByReplacingOccurrencesOfString:@"x" withString:@"X"];
    }

    NSString *carid = sPaperId;
    long lSumQT = 0;
    //加权因子
    int R[] = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    //校验码
    unsigned char sChecker[11] = { '1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2' };
    //将15位身份证号转换为18位
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    if (sPaperId.length == 15) {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        //        const char *pid = [mString UTF8String];
        for (int i = 0; i < 17; i++) {
            NSString *s = [mString substringWithRange:NSMakeRange(i, 1)];
            p += [s intValue] * R[i];
            //            p += (long)(pid-48) * R;//
        }
        int o = p % 11;
        NSString *string_content = [NSString stringWithFormat:@"%c", sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    //判断地区码
    NSString *sProvince = [carid substringToIndex:2];
    if (![self isAreaCode:sProvince]) {
        return NO;
    }
    //判断年月日是否有效
    //年份
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    //月份
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    //日
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01", strYear, strMonth, strDay]];
    if (date == nil) {
        return NO;
    }
    [carid uppercaseString];
    const char *PaperId = [carid UTF8String];
    //检验长度
    if (18 != strlen(PaperId)) {
        return NO;
    }
    //校验数字
    NSString *lst = [carid substringFromIndex:carid.length - 1];
    char di = [carid characterAtIndex:carid.length - 1];

    if (!isdigit(di)) {
        if ([lst isEqualToString:@"X"] || [lst isEqualToString:@"x"]) {
        } else {
            return NO;
        }
    }
    //验证最末的校验码
    lSumQT = 0;
    for (int i = 0; i < 17; i++) {
        NSString *s = [carid substringWithRange:NSMakeRange(i, 1)];
        lSumQT += [s intValue] * R[i];
    }
    if (sChecker[lSumQT % 11] != PaperId[17]) {
        return NO;
    }
    return YES;
}

+ (BOOL)validatePassport:(NSString *)value {
    const char *str = [value UTF8String];
    char first = str[0];
    NSInteger length = strlen(str);
    if (!(first == 'P' || first == 'G')) {
        return FALSE;
    }
    if (first == 'P') {
        if (length != 8) {
            return FALSE;
        }
    }
    if (first == 'G') {
        if (length != 9) {
            return FALSE;
        }
    }
    BOOL result = TRUE;
    for (NSInteger i = 1; i < length; i++) {
        if (!(str[i] >= '0' && str[i] <= '9')) {
            result = FALSE;
            break;
        }
    }
    return result;
}

+ (NSArray *)provinceArr {
    NSArray *pArr = @[

        @11,              //北京市|110000，

        @12,              //天津市|120000，

        @13,              //河北省|130000，

        @14,              //山西省|140000，

        @15,              //内蒙古自治区|150000，

        @21,              //辽宁省|210000，

        @22,              //吉林省|220000，

        @23,              //黑龙江省|230000，

        @31,              //上海市|310000，

        @32,              //江苏省|320000，

        @33,              //浙江省|330000，

        @34,              //安徽省|340000，

        @35,              //福建省|350000，

        @36,              //江西省|360000，

        @37,              //山东省|370000，

        @41,              //河南省|410000，

        @42,              //湖北省|420000，

        @43,              //湖南省|430000，

        @44,              //广东省|440000，

        @45,              //广西壮族自治区|450000，

        @46,              //海南省|460000，

        @50,              //重庆市|500000，

        @51,              //四川省|510000，

        @52,              //贵州省|520000，

        @53,              //云南省|530000，

        @54,              //西藏自治区|540000，

        @61,              //陕西省|610000，

        @62,              //甘肃省|620000，

        @63,              //青海省|630000，

        @64,              //宁夏回族自治区|640000，

        @65,              //新疆维吾尔自治区|650000，

        @71,              //台湾省（886)|710000,

        @81,              //香港特别行政区（852)|810000，

        @82,              //澳门特别行政区（853)|820000

        @91,              //国外
    ];
    return pArr;
}

+ (BOOL)isAreaCode:(NSString *)province {
    //在provinceArr中找
    NSArray *arr = [self provinceArr];
    int a = 0;
    //    for (NSString * pr in arr) {
    //        if ([pr isEqualToString:province]) {
    //            a ++;
    //        }
    //    }
    NSNumber *provinceNumber = [NSNumber numberWithInteger:[province integerValue]];
    for (NSNumber *pr in arr) {
        if ([pr isEqual:provinceNumber]) {
            a++;
        }
    }
    if (a == 0) {
        return NO;
    } else {
        return YES;
    }
}

+ (NSString *)getStringWithRange:(NSString *)str Value1:(int)v1 Value2:(int)v2 {
    NSString *sub = [str substringWithRange:NSMakeRange(v1, v2)];
    return sub;
}

+ (NSInteger)genderOfIDNumber:(NSString *)IDNumber {
    //  记录校验结果：0女，1男，2未知
    NSInteger result = 2;
    NSString *fontNumer = nil;

    if (IDNumber.length == 15) { // 15位身份证号码：第15位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(14, 1)];
    } else if (IDNumber.length == 18) { // 18位身份证号码：第17位代表性别，奇数为男，偶数为女。
        fontNumer = [IDNumber substringWithRange:NSMakeRange(16, 1)];
    } else { //  不是15位也不是18位，则不是正常的身份证号码，直接返回
        return result;
    }

    NSInteger genderNumber = [fontNumer integerValue];

    if (genderNumber % 2 == 1) result = 1;

    else if (genderNumber % 2 == 0) result = 0;
    return result;
}

@end

@implementation NSString (FormatTime)

+ (NSString *)timeStringWithData:(NSString *)dateString {
    //    1.创建时间格式化工具类
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // 2.格式时间
    // 指定时间的格式
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
#warning 如果时真机, 还需要指定需要格式化时间所属的时区, 否则格式化出来的时间时null
//  formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *createTime = [formatter dateFromString:dateString];
    // 利用服务器的和本地时间进行对比
    if ([createTime isThisYear]) {
        // 是今年
        if ([createTime isToday]) {
            // 其它天
            if ([createTime isAM]) {
                formatter.dateFormat = @"上午 HH:mm";
            }else {
                formatter.dateFormat = @"下午 HH:mm";
            }
            // 是今天
            return [formatter stringFromDate:createTime];
        } else if ([createTime isYesterday]) {
            // 是昨天
            formatter.dateFormat = @"昨天 HH:mm";
            return [formatter stringFromDate:createTime];
        } else {
            // 其它天
            formatter.dateFormat = @"MM月dd日 HH:mm";
            return [formatter stringFromDate:createTime];
        }
    } else {
        // 不是今年
        formatter.dateFormat = @"YY年MM月dd日 HH:mm";
        return [formatter stringFromDate:createTime];
    }

    return [formatter stringFromDate:createTime];
}

+ (NSString *)getTimeWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //转换当前所在时区
    [dateFormatter setDateStyle:0];

    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString *dateString = [dateFormatter stringFromDate:date];

    NSLog(@"转化时间：%@", dateString);

    return dateString;
}


@end

@implementation NSString (BHURLHelper)

- (NSString *)addRandomParameter{
    return [self addParameters:@{
                                 @"dytRandom":@(arc4random_uniform(99999999))
                                 }];
}

- (NSString *)addParameters:(NSDictionary *)parameters {
    NSMutableArray *parts = [NSMutableArray array];

    for (NSString *key in [parameters allKeys]) {
        NSString *part = [NSString stringWithFormat:@"%@=%@", key, [parameters valueForKey:key]];
        [parts addObject:part];
    }

    NSString *parametersString = [parts componentsJoinedByString:@"&"];

    NSString *addSuffixString = @"";
    if ([[self parseURLParameters] count] > 0) {
        addSuffixString = [NSString stringWithFormat:@"%@%@", @"&", parametersString]; // 原链接已经存在参数, 则用"&"直接拼接参数;
    } else {
        addSuffixString = [NSString stringWithFormat:@"%@%@", @"?", parametersString]; // 原链接不存在参数, 则先添加"?", 再拼接参数;
    }

    return [self stringByAppendingString:addSuffixString];
}

- (NSString *)deleteParameterOfKey:(NSString *)key; {
    NSString *finalString = [NSString string];

    if ([self containsString:key]) {
        NSMutableString *mutStr = [NSMutableString stringWithString:self];
        NSArray *strArray = [mutStr componentsSeparatedByString:key];

        NSMutableString *firstStr = [strArray objectAtIndex:0];
        NSMutableString *lastStr = [strArray lastObject];

        NSRange characterRange = [lastStr rangeOfString:@"&"];

        if (characterRange.location != NSNotFound) {
            NSArray *lastArray = [lastStr componentsSeparatedByString:@"&"];
            NSMutableArray *mutArray = [NSMutableArray arrayWithArray:lastArray];
            [mutArray removeObjectAtIndex:0];

            NSString *modifiedStr = [mutArray componentsJoinedByString:@"&"];
            finalString = [[strArray objectAtIndex:0]stringByAppendingString:modifiedStr];
        } else {
            finalString = [firstStr substringToIndex:[firstStr length] - 1];
        }
    } else {
        finalString = self;
    }

    return finalString;
}

- (NSString *)modifyParameterOfKey:(NSString *)key toValue:(NSString *)toValue {
    NSDictionary *parameters = [self parseURLParameters];

    if (parameters.count > 0 && [parameters.allKeys containsObject:key]) {
        [parameters setValue:toValue forKey:key];
    }

    NSString *urlString = self;
    for (NSString *key in parameters.allKeys) {
        urlString =    [urlString deleteParameterOfKey:key];
    }

    return [urlString addParameters:parameters];
}

- (NSMutableDictionary *)parseURLParameters {
    NSRange range = [self rangeOfString:@"?"];
    if (range.location == NSNotFound) return nil;

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    NSString *parametersString = [self substringFromIndex:range.location + 1];
    if ([parametersString containsString:@"&"]) {
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];

        for (NSString *keyValuePair in urlComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];

            if (key == nil || value == nil) {
                continue;
            }

            id existValue = [parameters valueForKey:key];
            if (existValue != nil) {
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [parameters setValue:items forKey:key];
                } else {
                    [parameters setValue:@[existValue, value] forKey:key];
                }
            } else {
                [parameters setValue:value forKey:key];
            }
        }
    } else {
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        if (pairComponents.count == 1) {
            return nil;
        }

        NSString *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString *value = [pairComponents.lastObject stringByRemovingPercentEncoding];

        if (key == nil || value == nil) {
            return nil;
        }
        [parameters setValue:value forKey:key];
    }

    return parameters;
}

@end


@implementation NSString (Price)



- (NSMutableAttributedString *)dyt_priceAttributed {
    return [self priceAttributedWithFontSize1:12 fontSize2:20 fontSize3:14 centerLine:false alignment:NSTextAlignmentLeft color:[UIColor colorWithString:@"#FD7038"]];
}

- (NSMutableAttributedString *)dyt_priceAttributedBig {
    return [self priceAttributedWithFontSize1:18 fontSize2:24 fontSize3:18 centerLine:false alignment:NSTextAlignmentLeft color:[UIColor colorWithString:@"#FD7038"]];
}

- (NSMutableAttributedString *)dyt_priceAttributedOrder {
    return [self priceAttributedWithFontSize1:12 fontSize2:18 fontSize3:12 centerLine:false alignment:NSTextAlignmentLeft color:[UIColor colorWithString:@"#FD7038"]];
}

- (NSMutableAttributedString *)dyt_oldPriceAttributed {
    return [self priceAttributedWithFontSize1:10 fontSize2:14 fontSize3:0 centerLine:true alignment:NSTextAlignmentLeft color:[UIColor colorWithString:@"#DBDBDB"]];
}

- (NSMutableAttributedString *)priceAttributedWithFontSize1:(NSInteger)size1
                                                  fontSize2:(NSInteger)size2
                                                  fontSize3:(NSInteger)size3
                                                 centerLine:(BOOL)centerLine
                                                  alignment:(NSTextAlignment)alignment
                                                      color:(UIColor *)color
{
    NSString *string = self;
    if ([NSString isEmptyString:string]) {
        string = @"0.00";
    }
    if ([string containsString:@"元"]) {
        string = [string stringByReplacingOccurrencesOfString:@"元" withString:@""];
    }
    if ([string containsString:@"￥"]) {
        string = [string stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    }

    NSMutableParagraphStyle *descStyle = [[NSMutableParagraphStyle alloc]init];
    descStyle.alignment = alignment;

    NSArray *numbers = [[NSString stringWithFormat:@"%.2f", string.floatValue] componentsSeparatedByString:@"."];
    NSMutableAttributedString *amountAtt = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:@{
                                                NSForegroundColorAttributeName: color,
                                                NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size:size1],
                                                NSParagraphStyleAttributeName: descStyle
    }];

    NSAttributedString *suffixAtt1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", numbers[0]] attributes:@{
                                          NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont systemFontOfSize:size2],
                                          NSStrikethroughStyleAttributeName: @(centerLine ? NSUnderlineStyleSingle : NSUnderlineStyleNone),
                                          NSParagraphStyleAttributeName: descStyle
    }];

    NSAttributedString *suffixAtt2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@".%@", numbers[1]] attributes:@{
                                          NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont systemFontOfSize:size3],
                                          NSStrikethroughStyleAttributeName: @(centerLine ? NSUnderlineStyleSingle : NSUnderlineStyleNone),
                                          NSParagraphStyleAttributeName: descStyle
    }];
    [amountAtt appendAttributedString:suffixAtt1];
    [amountAtt appendAttributedString:suffixAtt2];
    return amountAtt;
}

- (NSAttributedString *)placeholderText {
    return [[NSAttributedString alloc] initWithString:self attributes:@{
        NSForegroundColorAttributeName : [UIColor colorWithString:@"#C4C2C0"]
    }];
}
@end
