//
//  NSObject+Extension.h
//  DaoyitongCode
//
//  Created by maoge on 2018/9/7.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Extension)
@property (nonatomic, copy) NSString *dytID;

/**
 * 返回当前类的所有属性
 *
 * @return 属性名称数组
 */
+ (NSArray *)dyt_propertyList;

/**
 * 返回当前类的所有成员变量的属性
 *
 * @return 成员变量的数组
 */
+ (NSArray *)dyt_ivarList;

@end

@interface NSObject (methodSwizzle)

/**
 *  交换对象方法
 */
+ (BOOL)dyt_hookInstanceOrigMenthod:(SEL)origSel NewMethod:(SEL)altSel;

/**
 *  交换类方法
 */
+ (BOOL)dyt_hookClassOrigMenthod:(SEL)origSel NewMethod:(SEL)altSel;

@end


