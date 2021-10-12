//
//  UIView+Catetory.h
//  pavodoctor
//
//  Created by maoge on 2020/4/15.
//  Copyright © 2020 导医通. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TaplBlock)(UITapGestureRecognizer *tap);

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Catetory)
/// 添加水平渐变色
- (void)addTranstionColor;
/// 移除渐变色
- (void)removeTranstionColor;
/// 添加水平渐变色带frame
- (void)addTranstionColorWithFrame:(CGRect)frame;
/// 添加渐变色
- (void)addTranstionColorWithFrame:(CGRect)frame startColor:(UIColor *)sColor endColor:(UIColor *)ecolor startPoint:(CGPoint)sPoint endPoint:(CGPoint)ePoint;
// 添加背景垂直渐变视图
+ (UIView *)gradientBgColorWithFrame:(CGRect)frame;
///添加多种颜色渐变
- (void)addTranstionColorsWithFrame:(CGRect)frame colors:(NSArray *)colors startPoint:(CGPoint)sPoint endPoint:(CGPoint)ePoint locations:(NSArray *)locations;
/// 添加边框
- (void)setBorderColor:(UIColor *)color width:(CGFloat)width;
/// 添加边框带圆角
- (void)setBorderColor:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)radius;
/// 布局所有子视图
- (void)updateLayoutSubViews;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;
@end

@interface UIView (KDGesture)

- (UITapGestureRecognizer *)addTapTarget:(id)target selector:(SEL)selector;

- (UILongPressGestureRecognizer *)addLongPressTarget:(id)target selector:(SEL)selector;

- (void)addTapBlock:(TaplBlock)block;
@end


@interface UIView (Responder)

- (UINavigationController *)jq_navController;

@end


@interface UIView (BottomLine)
- (void)bottomLineShow:(BOOL)show padding:(CGFloat)padding;
///加浅色底线
- (void)bottomLightLineShow:(BOOL)show padding:(CGFloat)padding;

- (void)bottomLineShow:(BOOL)show padding:(CGFloat)padding lineHeight:(CGFloat)lineHeight;

- (void)bottomLineShow:(BOOL)show padding:(CGFloat)padding lineHeight:(CGFloat)lineHeight lineColor:(UIColor *)lineColor;

- (void)rightLineShow:(BOOL)show padding:(CGFloat)padding lineWidth:(CGFloat)lineWidth;

/// 顶部线
- (void)topLineShow:(BOOL)show padding:(CGFloat)padding;
@end
NS_ASSUME_NONNULL_END

