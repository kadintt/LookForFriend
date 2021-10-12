//
//  ViewController.h
//  demo
//
//  Created by CJG on 16/7/25.
//  Copyright © 2016年 CJG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollControllersVc;

@protocol ScrollHeaderDataSource <NSObject>

@required
/// 返回一个展示在顶部的实例
- (UIView*)scrollContent;
@optional
/// 回调滑动进度
- (void)scrollDidProgress:(CGFloat)progress controller:(ScrollControllersVc*)controller;
/// 回调选中的index
- (void)scrollDidIndex:(NSInteger)progress controller:(ScrollControllersVc*)controller;

@end

typedef void(^CommonBack)(id item);

@interface ScrollControllersVc: UIViewController
/// 头部自定义视图
@property (nonatomic, weak) id<ScrollHeaderDataSource> scrollHeaderDataSource;
/** 选中第几个控制器, item interger类型 */
@property (nonatomic, copy) CommonBack selectBack;
/** 移动的比例系数 item number类型*/
@property (nonatomic, copy) CommonBack scaleBack;

@property (nonatomic, assign) NSInteger curIndex;

@property (nonatomic, strong) NSArray* titles;

@property (nonatomic, strong) NSArray* controllers;

@property (nonatomic, strong) UIView *topView;

/// 获取当前控制器
- (UIViewController*)curController;
/// 滚动到对应索引Index
- (void)scrollWithIndex:(NSInteger)index;
/// 默认初始化
- (instancetype)initWithControllers:(NSArray*)controllers;
/// 增加标题初始化
- (instancetype)initWithControllers:(NSArray*)controllers
                             titles:(NSArray*)titles;
/// 增加标题固定宽度初始化
- (instancetype)initWithControllers:(NSArray*)controllers
                             titles:(NSArray*)titles
                         titleWidth:(CGFloat)titleWidth;

- (void)updateControllers:(NSArray*)controllers
                   titles:(NSArray*)titles;

- (void)updateTitles:(NSArray*)titles;

- (void)isDisableSpan:(BOOL)disable;

- (void)titleItemActionDisable:(BOOL)disable;

@end

