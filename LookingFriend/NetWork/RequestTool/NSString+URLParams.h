//
// Created by chenjg on 2019-06-03.
// Copyright (c) 2019 爱康国宾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLParams)

+ (NSString *)httpHeaderFormat:(NSDictionary *)dic;

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


@interface NSObject (Extension)

/// 配置body
- (id)configBody:(id)body;

@end
