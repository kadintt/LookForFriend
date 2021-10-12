//
// Created by cjg on 2018/8/6.
// Copyright (c) 2018 爱康国宾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RefreshTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject <RefreshToolDataSource>

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *message;
/** 优先级比message高, 默认为nil */
@property (nonatomic, copy) NSString *otherMessage;

//@property (nonatomic, copy) NSString *errors;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) NSString *name;
/** default -1, 自动计算, 不是-1,直接取 */
@property (nonatomic, assign) CGFloat cellHeight;
// 页码
@property (nonatomic, assign) NSInteger pageNo;
// 总页数
@property (nonatomic, assign) NSInteger pageSumCount;
// 总条数
@property (nonatomic, assign) NSInteger recordCount;
// 每页请求条数
@property (nonatomic, assign) NSInteger rowsPerPage;


+ (BOOL)handle:(__nullable id)model;
+ (BOOL)isSuccess:(__nullable id)model;

/**
 * 处理一些共有逻辑
 * @return 返回值和 isSuccess() 相同
 */
- (BOOL)handle;

/** 判断是否有下一页, 子类可自由实现 */
- (BOOL)isNextPages;

/** 判断接口是否成功, 子类可自由实现*/
- (BOOL)isSuccess;
@end


#pragma mark - convert

@interface NSObject (convert)
/**
 * 初始化方法
 * @param dictionary 可以是String, NSData, NSDictionary
 */
- (instancetype)initWithDictionary:(__nullable id)dictionary;

/// 字典数组转模型数组
/// @param dictionary 可以是String, NSData, NSDictionary
+ (NSMutableArray *)arrayWithDictionary:(id)dictionary;

/// 字典转model
/// @param dictionary 可以是String, NSData, NSDictionary
+ (id)modelWithDictionary:(id)dictionary;

/// 更新模型的值
/// @param dictionary 可以是String, NSData, NSDictionary
- (void)updateWithDictionary:(id)dictionary;

/// 模型转换为josn字符串
- (NSString *)toJsonString;

/// 模型转换为字典
- (NSDictionary *)toJson;

/// 模型转换data
- (NSData*)toData;

@end
NS_ASSUME_NONNULL_END
