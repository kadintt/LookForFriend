//
//  NSObject+Extension.m
//  DaoyitongCode
//
//  Created by maoge on 2018/9/7.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

static NSString *dytIdkey = @"dytIdkey"; //那么的key

@implementation NSObject (Extension)

/**
 setter方法
 */
- (void)setDytID:(NSString *)dytID {
    objc_setAssociatedObject(self, &dytIdkey, dytID, OBJC_ASSOCIATION_COPY);
}

/**
 getter方法
 */
- (NSString *)dytID {
    return objc_getAssociatedObject(self, &dytIdkey);
}

const void *propertyListKey = @"propertyListKey";

+ (NSArray *)dyt_propertyList {
    // 0. --- 判断属性数组是否存在，如果存在直接返回 `属性数组对象` ---
    NSArray *result = objc_getAssociatedObject(self, propertyListKey);

    if (result != nil) {
        return result;
    }

    // 1. 获取属性数组
    unsigned int count = 0;
    objc_property_t *list = class_copyPropertyList([self class], &count);

    NSLog(@"属性数量 %u", count);

    NSMutableArray *arrM = [NSMutableArray array];
    // 2. 遍历数组
    for (unsigned int i = 0; i < count; i++) {
        // 1> 通过下标获取属性对象
        objc_property_t property = list[i];

        // 2> 获取属性的名称
        const char *pty = property_getName(property);

        // 3> 转换成 OC 的字符串
        NSString *str = [NSString stringWithUTF8String:pty];

        [arrM addObject:str];
    }

    //释放数组
    free(list);

    // --- 保存属性数组对象 ---
    objc_setAssociatedObject(self, propertyListKey, arrM, OBJC_ASSOCIATION_COPY_NONATOMIC);

    return arrM.copy;
}

+ (NSArray *)dyt_ivarList {
    // 1. 取类的成员变量列表
    unsigned int count = 0;
    Ivar *list = class_copyIvarList([self class], &count);

    // NSLog(@"%u", count);
    NSMutableArray *arrayM = [NSMutableArray array];

    // 2. 遍历数组
    for (unsigned int i = 0; i < count; i++) {
        // 1> 根据下标获取成员变量
        Ivar ivar = list[i];

        // 2> 取 ivar 的名字
        const char *cName = ivar_getName(ivar);

        // 3> 转换成 NSString
        NSString *name = [NSString stringWithUTF8String:cName];

        [arrayM addObject:name];
    }

    // 3. 释放列表
    free(list);

    return arrayM.copy;
}

@end

@implementation NSObject (methodSwizzle)

+ (BOOL)dyt_hookInstanceOrigMenthod:(SEL)origSel NewMethod:(SEL)altSel {
    Class class = self;
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method altMethod = class_getInstanceMethod(class, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    BOOL didAddMethod = class_addMethod(class, origSel,
                                        method_getImplementation(altMethod),
                                        method_getTypeEncoding(altMethod));

    if (didAddMethod) {
        class_replaceMethod(class, altSel,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, altMethod);
    }

    return YES;
}

+ (BOOL)dyt_hookClassOrigMenthod:(SEL)origSel NewMethod:(SEL)altSel {
    Class class = self;
    Method origMethod = class_getClassMethod(class, origSel);
    Method altMethod = class_getClassMethod(class, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    Class metaClass = object_getClass(class);
    BOOL didAddMethod = class_addMethod(metaClass, origSel,
                                        method_getImplementation(altMethod),
                                        method_getTypeEncoding(altMethod));

    if (didAddMethod) {
        class_replaceMethod(metaClass, altSel,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, altMethod);
    }

    return YES;
}

@end



