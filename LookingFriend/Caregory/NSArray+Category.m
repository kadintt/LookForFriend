//
//  NSArray+Category.m
//  Base
//
//  Created by cjg on 2017/12/22.
//  Copyright © 2017年 CJG. All rights reserved.
//

#import "NSArray+Category.h"

@implementation NSArray (Category)
/**
 根据key在数组冒泡排序,return为copy的

 @param array   数组
 @param keyPath 属性名
 @param down    是否降序列

 @return return value description
 */
+ (NSArray *)sortArray:(NSArray *)array key:(NSString *)keyPath down:(BOOL)down {
    NSMutableArray *sortArr = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < sortArr.count; i++) {
        for (int j = 0; j < sortArr.count - 1; j++) {

            NSNumber *value1 = [sortArr[j] valueForKeyPath:keyPath];
            NSNumber *value2 = [sortArr[j + 1] valueForKeyPath:keyPath];

            if ([value1 isKindOfClass:[NSString class]]) {
                if (down) {
                    if (((NSString *) value1).floatValue < ((NSString *) value2).floatValue) {
                        [sortArr exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                    }
                } else {
                    if (((NSString *) value1).floatValue > ((NSString *) value2).floatValue) {
                        [sortArr exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                    }
                }

            } else {
                if (down) {
                    if (value1.doubleValue < value2.doubleValue) {
                        [sortArr exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                    }
                } else {
                    if (value1.doubleValue > value2.doubleValue) {
                        [sortArr exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                    }
                }
            }
        }
    }
    return sortArr;
}

/**
 给数组元素制定下标对象的某个属性赋值

 @param value         设置的值
 @param keyPath       属性名
 @param deafaultValue 默认值
 @param index         下标
 @param array         数组
 */
+ (void)setValue:(id)value keyPath:(NSString *)keyPath deafaultValue:(id)deafaultValue index:(NSInteger)index inArray:(NSArray *)array {
    if (index < array.count && index >= 0) {
        for (int i = 0; i < array.count; i++) {
            id model = array[i];
            [model setValue:i == index ? value : deafaultValue forKeyPath:keyPath];
        }
    }
}

/**
 从数组中返回属性值为value的对象,只支持基本类型和string类型

 @param array   数组
 @param keyPath 属性名
 @param value   值

 @return 对象
 */
+ (id)getObjectInArray:(NSArray *)array keyPath:(NSString *)keyPath equalValue:(id)value {
    return [array getObjcWithFilter:^BOOL(id _Nonnull element, NSInteger integer) {
        id objcValue = [element valueForKeyPath:keyPath];
        if (value) {
            if ([objcValue isEqual:value] || objcValue == value) {
                return YES;
            }
        }
        return NO;
    }];
}

/**
 排序数组

 @param block return true的时候放后面
 @return return value description
 */
- (NSMutableArray *)sorted:(ArraySortBlock)block {
    NSMutableArray *sortArr = [NSMutableArray arrayWithArray:self];
    if (block) {
        for (int i = 0; i < sortArr.count; i++) {
            for (int j = 0; j < sortArr.count - 1; j++) {
                id a = sortArr[j];
                id b = sortArr[j + 1];
                BOOL isExchange = block(a, b);
                if (isExchange) {
                    [sortArr exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
                }
            }
        }
    }
    return sortArr;
}

/**
 筛选数组

 @param block 筛选条件
 @return return value description
 */
- (NSMutableArray *)filter:(ArrayFilterBlock)block {
    if (block) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < self.count; i++) {
            id object = self[i];
            BOOL isAdd = block(object, i);
            if (isAdd) {
                [array addObject:object];
            }
        }
        return array;
    } else {
        return [NSMutableArray arrayWithArray:self];
    }
}

/**
 数组中某个获取元素

 @param filter filter description
 @return return value description
 */
- (id)getObjcWithFilter:(ArrayFilterBlock)filter {
    id objc = nil;
    if (filter) {
        NSArray *filterArray = [self filter:filter];
        if (filterArray.count) {
            objc = filterArray[0];
        }
    }
    return objc;
}

/**
 map数组

 @param block block description
 @return return value description
 */
- (NSMutableArray *)map:(ArrayMapBlock)block {
    if (block) {
        NSMutableArray *array = [NSMutableArray array];
        [self forEach:^(id _Nonnull objc, NSInteger index) {
            id map = block(objc, index);
            if (map) {
                [array addObject:map];
            }
        }];
        return array;
    } else {
        return [NSMutableArray arrayWithArray:self];
    }
}

/**
 自由组合 筛选,排序,map数组, 参数都可为nil

 @param filter <#filter description#>
 @param sorted <#sorted description#>
 @param map <#map description#>
 @return <#return value description#>
 */
- (NSMutableArray *)filter:(ArrayFilterBlock)filter sorted:(ArraySortBlock)sorted map:(ArrayMapBlock)map {
    return [[[self filter:filter] sorted:sorted] map:map];
}

/**
 添加一个元素

 @param objc 元素
 @param filter 过滤规则,只要一次return false就不加入
 @return return value description
 */
- (NSMutableArray *)addObjc:(id)objc filter:(ArrayFilterBlock)filter {
    if (objc && filter) {
        NSMutableArray *array;
        if ([self isKindOfClass:[NSMutableArray class]]) {
            array = (NSMutableArray *)self;
        } else {
            array = [NSMutableArray arrayWithArray:self];
        }
        int i = 0;
        for (int j = 0; j < self.count; j++) {
            id model = self[j];
            BOOL throw = filter(model, j);
            if (throw) {
                i++;
            } else {
                break;
            }
        }
        if (i == self.count) {
            [array addObject:objc];
        }
        return array;
    } else {
        return [NSMutableArray arrayWithArray:self];
    }
}

/**
 * 在指定位置加入一个元素
 * @param objc 元素
 * @param filter 过滤规则,只要一次return false就不加入
 * @param index 插入的位置
 * @return
 */
- (NSMutableArray *)addObjc:(id)objc
                     filter:(ArrayFilterBlock _Nullable)filter
                      index:(NSUInteger)index{
    if (objc && filter) {
        NSMutableArray *array;
        if ([self isKindOfClass:[NSMutableArray class]]) {
            array = (NSMutableArray *)self;
        } else {
            array = [NSMutableArray arrayWithArray:self];
        }
        int i = 0;
        for (int j = 0; j < self.count; j++) {
            id model = self[j];
            BOOL throw = filter(model, j);
            if (throw) {
                i++;
            } else {
                break;
            }
        }
        if (i == self.count) {
            [array insertObject:objc atIndex:index];
        }
        return array;
    } else {
        return [NSMutableArray arrayWithArray:self];
    }
}

/**
 for

 @param block block description
 */
- (void)forEach:(ArrayForBlock)block {
    if (block) {
        for (NSInteger i = 0; i < self.count; i++) {
            block(self[i], i);
        }
    }
}

- (NSMutableArray *)sortWithKeyPath:(NSString *)keyPath isDown:(BOOL)isDown {
    return [self sorted:^BOOL(id _Nonnull a, id _Nonnull b) {
        double v1 = 0;
        double v2 = 0;
        id value1 = [a valueForKeyPath:keyPath];
        id value2 = [b valueForKeyPath:keyPath];
        if ([value1 isKindOfClass:[NSString class]] || [value2 isKindOfClass:[NSString class]]) {
            v1 = ((NSString *) value1).doubleValue;
            v2 = ((NSString *) value2).doubleValue;
        }
        if ([value1 isKindOfClass:[NSNumber class]] || [value2 isKindOfClass:[NSNumber class]]) {
            v1 = ((NSNumber *) value1).doubleValue;
            v2 = ((NSNumber *) value2).doubleValue;
        }
        return v1 < v2 == isDown;
    }];
}

- (NSMutableArray *)moveIndex:(NSInteger)index toIndex:(NSInteger)toIndex {
    if (index == toIndex || self.count <= index || self.count <= toIndex) {
        return nil;
    }
    NSMutableArray *array = nil;
    if ([self isKindOfClass:[NSMutableArray class]]) {
        array = (NSMutableArray *) self;
    } else {
        array = self.mutableCopy;
    }
    id tmp = array[index];
    [array removeObjectAtIndex:index];
    [array insertObject:tmp atIndex:toIndex];
    return array;
}

- (BOOL)isEmpty {
    return !self.count;
}

/**
 * 数组转字符串
 * @param separator 分隔符
 * @return
 */
- (NSString *)convertStringWithSeparator:(NSString *)separator {
    __block NSString *string = @"";
    [self forEach:^(NSObject * objc, NSInteger index) {
        if (index == 0) {
            string = objc.description;
        } else{
            string = [NSString stringWithFormat:@"%@%@%@",string,separator,objc];
        }
    }];
    return string;
}

// 重写这个方法，可以保证在log的时候，能够正确输出数组中的中文
// 需要重写对象的description才能够正确输出
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];

    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];

    [strM appendString:@")"];
    return strM;
}

- (NSString *)description {
    return [self debugDescription];
}

@end

@implementation NSMutableArray (Category)
// 重写这个方法，可以保证在log的时候，能够正确输出数组中的中文
// 需要重写对象的description才能够正确输出
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    return strM;
}

- (NSString *)description {
    return [self debugDescription];
}
@end
