//
// Created by cjg on 2018/8/6.
// Copyright (c) 2018 爱康国宾. All rights reserved.
//

#import "BaseModel.h"
#import <Toast/Toast.h>
#import <MJExtension/MJExtension.h>
#import "LookingFriend-Swift.h"
#import "NSString+Category.h"
#import "DYTHUDTool.h"
#import "APPDefine.h"

@implementation BaseModel

MJCodingImplementation

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{};
}


+ (BOOL)handle:(id)model {
    if ([model isKindOfClass:[self class]]) {
        return ((BaseModel *)model).handle;
    }
    [DYTHUDTool showWDToast:@"服务器出小差了"];
    return false;
}

+ (BOOL)isSuccess:(id)model {
    if ([model isKindOfClass:[self class]]) {
        return ((BaseModel *)model).isSuccess;
    }
    return false;
}

- (instancetype)init {
    if (self = [super init]) {
        self.cellHeight = -1;
    }
    return self;
}
/**
 * 初始化方法
 * @param dictionary 可以是String, NSData, NSDictionary
 */
- (instancetype)initWithDictionary:(id)dictionary {
    if (self = [self init]) {
        [self mj_setKeyValues:dictionary];
    }
    return self;
}

- (void)updateWithDictionary:(id)dictionary {
    [self mj_setKeyValues:dictionary];
}

/** 转换josn字符串 */
- (NSString *)toJsonString {
    return [self toJson].mj_JSONString;
}

/** 转换为字典 */
- (NSDictionary *)toJson {
    return [self mj_keyValuesWithIgnoredKeys:@[@"message", @"code", @"otherMessage", @"indexPath", @"netWorkFinishType", @"errors", @"cellHeight"]];
}

/** 判断接口是否成功, 子类可自由实现*/
- (BOOL)isSuccess {
    if ([_code isEqualToString:@"1"]) {
        return YES;
    } else if ([_code isEqualToString:@"100"]) {
        
        [[DCDataManager shared] logout];
        return [[DCDataManager shared] checkLogin:^{}];
    } else{
        return NO;
    }
}

/**
 * 处理一些共有逻辑
 * @return 返回值和 isSuccess() 相同
 */
- (BOOL)handle {
    BOOL success = self.isSuccess;
    if (!success) {
        if (IsEmptyString(self.otherMessage)) {
            if (!IsEmptyString(self.message)) {
                if (self.message.length > 40) {
                     [DYTHUDTool showWDToast:@"服务器出小差了"];
                } else {
                    [DYTHUDTool showWDToast:self.message];
                }
            }
        } else {
            [DYTHUDTool showWDToast:self.otherMessage];
        }
    }
    return success;
}

/** 判断是否有下一页, 子类可自由实现 */
- (BOOL)isNextPages {
    return _pageSumCount > _pageNo;
}

- (BOOL)isRefreshSuccess {
    return self.isSuccess;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"%@\n\n%@", super.description, self.toJson.description];
}

- (NSString *)debugDescription {
    return self.description;
}

@end


#pragma mark - 初始化

@implementation NSObject (convert)

- (instancetype)initWithDictionary:(id)dictionary {
    if (self = [self init]) {
        [self mj_setKeyValues:dictionary];
    }
    return self;
}

+ (NSMutableArray *)arrayWithDictionary:(id)dictionary {
    return [self mj_objectArrayWithKeyValuesArray:dictionary];
}

+ (id)modelWithDictionary:(id)dictionary {
    return [self mj_objectWithKeyValues:dictionary];
}

- (void)updateWithDictionary:(id)dictionary {
    [self mj_setKeyValues:dictionary];
}

- (NSString *)toJsonString {
    return [self mj_JSONString];
}

- (NSDictionary *)toJson {
    return [self mj_keyValues];
}

- (NSData *)toData {
    return self.mj_JSONData;
}

/// 防止老代码崩溃
- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
}

@end
