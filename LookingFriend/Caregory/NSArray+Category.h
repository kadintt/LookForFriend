//
//  NSArray+Category.h
//  Base
//
//  Created by cjg on 2017/12/22.
//  Copyright © 2017年 CJG. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^ArrayFilterBlock)(id __nonnull element, NSInteger index);

typedef BOOL(^ArraySortBlock)(id __nonnull a, id __nonnull b);

typedef id _Nullable(^ArrayMapBlock)(id __nonnull element, NSInteger index);

typedef void(^ArrayForBlock)(id __nonnull objc, NSInteger index);

@interface NSArray (Category)

/**
 根据key在数组冒泡排序,return为copy的

 @param array   数组
 @param keyPath 属性名
 @param down    是否降序列

 @return return value description
 */
+ (NSArray *_Nullable)sortArray:(NSArray *_Nullable)array
                            key:(NSString *_Nullable)keyPath
                           down:(BOOL)down;

/**
 给数组元素制定下标对象的某个属性赋值

 @param value         设置的值
 @param keyPath       属性名
 @param deafaultValue 默认值
 @param index         下标
 @param array         数组
 */
+ (void)setValue:(id _Nullable)value
         keyPath:(NSString *_Nullable)keyPath
   deafaultValue:(id _Nullable)deafaultValue
           index:(NSInteger)index
         inArray:(NSArray *_Nullable)array;

/**
 从数组中返回属性值为value的对象,只支持基本类型和objc类型

 @param array   数组
 @param keyPath 属性名
 @param value   值

 @return 对象
 */
+ (id _Nullable)getObjectInArray:(NSArray *_Nullable)array
                         keyPath:(NSString *_Nullable)keyPath
                      equalValue:(id _Nullable)value;


/**
 排序数组

 @param block return true的时候放后面
 @return return value description
 */
- (NSMutableArray *)sorted:(ArraySortBlock _Nullable)block;

/**
 筛选数组

 @param block 筛选条件
 @return return value description
 */
- (NSMutableArray *)filter:(ArrayFilterBlock _Nullable)block;

/**
 数组中某个获取元素

 @param filter filter description
 @return return value description
 */
- (id _Nullable)getObjcWithFilter:(ArrayFilterBlock _Nullable)filter;

/**
 map数组

 @param block block description
 @return return value description
 */
- (NSMutableArray *)map:(ArrayMapBlock _Nullable)block;


/**
 自由组合 筛选,排序,map数组, 参数都可为nil

 @param filter <#filter description#>
 @param sorted <#sorted description#>
 @param map <#map description#>
 @return <#return value description#>
 */
- (NSMutableArray *)filter:(ArrayFilterBlock _Nullable)filter
                    sorted:(ArraySortBlock _Nullable)sorted
                       map:(ArrayMapBlock _Nullable)map;


/**
 添加一个元素

 @param objc 元素
 @param filter 过滤规则,只要一次return false就不加入
 @return return value description
 */
- (NSMutableArray *)addObjc:(id)objc
                     filter:(ArrayFilterBlock _Nullable)filter;

/**
 * 在指定位置加入一个元素
 * @param objc 元素
 * @param filter 过滤规则,只要一次return false就不加入
 * @param index 插入的位置
 * @return 可变数组
 */
- (NSMutableArray *)addObjc:(id)objc
                     filter:(ArrayFilterBlock _Nullable)filter
                      index:(NSUInteger)index;

/**
 for

 @param block block description
 */
- (void)forEach:(ArrayForBlock)block;


/**
 根据keyPath排序数组, 只支持NSNumber, NSString, 基本类型

 @param keyPath 属性名
 @param isDown 是否降序
 @return return 排序后的数组
 */
- (NSMutableArray *)sortWithKeyPath:(NSString *)keyPath
                             isDown:(BOOL)isDown;

/**
 * 移动数组元素, 如果本身是可变数组会直接移动, 如果是不可变数组返回copy
 * @param index 原来下标
 * @param toIndex 新的下标
 * @return 如果本身是可变数组会直接移动返回自己, 如果是不可变数组返回copy
 */
- (NSMutableArray *)moveIndex:(NSInteger)index
                      toIndex:(NSInteger)toIndex;

- (BOOL)isEmpty;

/**
 * 数组转字符串
 * @param separator 分隔符
 * @return 字符串
 */
- (NSString *)convertStringWithSeparator:(NSString *)separator;

@end

@interface NSMutableArray (Category)

@end


NS_ASSUME_NONNULL_END



