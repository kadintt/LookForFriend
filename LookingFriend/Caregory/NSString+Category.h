//
//  NSString+ITTAdditions.h
//
//  Created by Jack on 11-9-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#define IsEmptyString(string) [NSString isEmptyString:string]

#define SafeText(string)      [NSString safeText:string]

@interface NSString (Category)

+ (NSString *)safeText:(id)string;

+ (BOOL)isEmptyString:(NSString *)string;

- (BOOL)isStartWithString:(NSString *)start;

- (BOOL)isEndWithString:(NSString *)end;

- (CGFloat)heightWithFont:(UIFont *)font withLineWidth:(NSInteger)lineWidth;

- (NSString *)sha1;

- (NSString *)md5;

- (NSString *)encodeUrl;

// 身份证, 手机号替换星***用的
- (NSString *)changeStringWithAsterisk:(NSInteger)startLocation length:(NSInteger)length;

//汉子转拼音
- (NSString *)phonetic:(NSString *)sourceString;

+ (id)getParameterOfParameterStr:(NSString *)parameterStr;

+ (NSString *)encodeToPercentEscapeString:(NSString *)input;

+ (NSString *)decodeFromPercentEscapeString:(NSString *)input;

+ (NSString *)replaceUnicode:(NSString *)aUnicodeString;

+ (NSString *)utf8ToUnicode:(NSString *)string;

//SH_添加
- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;

- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;

/**
 *  动态计算文字的宽高（单行）
 *
 *  @param font 文字的字体
 *
 *  @return 计算的宽高
 */
- (CGSize)jq_sizeWithFont:(UIFont *)font;

/**
 *  动态计算文字的宽高（多行）
 *
 *  @param font 文字的字体
 *  @param limitSize 限制的范围
 *
 *  @return 计算的宽高
 */
- (CGSize)jq_sizeWithFont:(UIFont *)font limitSize:(CGSize)limitSize;

/**
 *  动态计算文字的宽高（多行）
 *
 *  @param font 文字的字体
 *  @param limitWidth 限制宽度 ，高度不限制
 *
 *  @return 计算的宽高
 */
- (CGSize)jq_sizeWithFont:(UIFont *)font limitWidth:(CGFloat)limitWidth;

//检测  邮箱是否正确
+ (BOOL)validateEmail:(NSString *)candidate;

//检测  用户名
+ (BOOL)validateName:(NSString *)candidate;

//密码
+ (BOOL)validatePassword:(NSString *)candidate;

//预注册密码
+ (BOOL)validatePrePassword:(NSString *)candidate;

//手机号
+ (BOOL)validatePhone:(NSString *)candidate;

//邮编
+ (BOOL)validatePostCode:(NSString *)candidate;

//图片格式
+ (BOOL)validatePictureType:(NSString *)candidate;

//判断是否包含表情
+ (BOOL)stringContainsEmoji:(NSString *)string;

//中文
+ (BOOL)validateChinese:(NSString *)candidate;

//字母和数字
+ (BOOL)validateCharNum:(NSString *)candidate;

//社保卡号
+ (BOOL)validateSocialCard:(NSString *)candidate;

//身份证号
+ (BOOL)validateIDCard:(NSString *)candidate;

/// 护照
+ (BOOL)validatePassport:(NSString *)value;

+ (NSInteger)genderOfIDNumber:(NSString *)IDNumber;
@end

@interface NSString (FormatTime)

/** 当前时间格式成今天今年等 */
+ (NSString *)timeStringWithData:(NSString *)dateString;

/** 0时区转化为当前时区 */
+ (NSString *)getTimeWithDate:(NSDate *)date;

@end

@interface NSString (BHURLHelper)

/// 添加随机数参数
- (NSString *)addRandomParameter;

/** 增:
 为链接增加参数和值;
 @param parameters 要增加的参数和值 eg: @{@"version" : @"1.1.0"}
 @return 增加参数后生成一个新的URL String;
 */
- (NSString *)addParameters:(NSDictionary *)parameters;

/** 删:
 删除参数为key的键值对;
 @param key 要删除的参数对的键;
 @return 删除的参数后生成一个新的URL String;
 */
- (NSString *)deleteParameterOfKey:(NSString *)key;

/** 改:
 修改参数中的值
 @param key 要修改的值对应的键
 @param toValue 要求改成的值
 @return 修改值后生成一个新的URL String;
 */
- (NSString *)modifyParameterOfKey:(NSString *)key toValue:(NSString *)toValue;

/** 查:
 获取URL中的所有参数键值对
 @返回值为字典, 字典中key为参数, value为参数值;
 */
- (NSDictionary *)parseURLParameters;

@end

@interface NSString (Price)

/**
 *  导医通新版价格显示 #FD7038
 *  ￥40.00
 *  【[￥] 苹方 12】
 *  【[40.] DIN Alternate Bold 18】
 *  【[00] DIN Alternate Bold 12】
 */
/// 导医通新版价格显示 #FD7038 ￥40.00 【[￥] 苹方 12】【[40.] DIN Alternate Bold 20】【[00] DIN Alternate Bold 14】
- (NSMutableAttributedString *)dyt_priceAttributed;
/// 导医通新版价格显示 - 大号字体 #FD7038 ￥40.00 【[￥] 苹方 18】【[40.] DIN Alternate Bold 24】【[00] DIN Alternate Bold 18】
- (NSMutableAttributedString *)dyt_priceAttributedBig;
/// 导医通新版价格显示 - 订单详情 12 18 12
- (NSMutableAttributedString *)dyt_priceAttributedOrder;
/// 导医通老价格显示   10  14  0
- (NSMutableAttributedString *)dyt_oldPriceAttributed;

/// 设置价格富文本
/// @param size1 ￥符号大小
/// @param size2 点前面数字大小
/// @param size3 点后面的数字大小
/// @param centerLine 中线
/// @param alignment 对齐方式
/// @param color 颜色
- (NSMutableAttributedString *)priceAttributedWithFontSize1:(NSInteger)size1
                                                  fontSize2:(NSInteger)size2
                                                  fontSize3:(NSInteger)size3
                                                 centerLine:(BOOL)centerLine
                                                  alignment:(NSTextAlignment)alignment
                                                      color:(UIColor *)color;

- (NSAttributedString *)placeholderText;

@end
