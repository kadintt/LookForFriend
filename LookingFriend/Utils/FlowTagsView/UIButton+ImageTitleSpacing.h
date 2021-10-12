//
//  UIButton+ImageTitleSpacing.h
//  SystemPreferenceDemo
//
//  Created by moyekong on 12/28/15.
//  Copyright © 2015 wiwide. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, MKButtonEdgeInsetsStyle) {
    MKButtonEdgeInsetsStyleTop, // image在上，label在下
    MKButtonEdgeInsetsStyleLeft, // image在左，label在右
    MKButtonEdgeInsetsStyleBottom, // image在下，label在上
    MKButtonEdgeInsetsStyleRight // image在右，label在左
};

@interface UIButton (ImageTitleSpacing)

/// 设置button的titleLabel和imageView的布局样式，及间距
/// @param style titleLabel和imageView的布局样式
/// @param space titleLabel和imageView的间距
- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

@end

@interface UIButton (EnlargeTouchArea)

/// 扩大按钮点击区域
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end

IB_DESIGNABLE

typedef NS_ENUM (NSInteger, UIButtonLayoutStyle) {
    ImageLeftTitleRightStyle = 0, //默认的方式 image左 title右
    TitleLeftImageRightStyle = 1, // image右,title左
    ImageTopTitleBottomStyle = 2, //image上，title下
    TitleTopImageBottomStyle = 3, // image下,title上
};
@interface UIButton (Expand)

@property (nonatomic, assign) IBInspectable NSInteger aLayoutStyle;
@property (nonatomic, assign) IBInspectable CGFloat aSpacing;

/**
 *    功能:设置UIButton的布局，图片和文字按照指定方向显示
 *
 *    @param aLayoutStyle 参见OTSUIButtonLayoutStyle
 *    @param aSpacing 图片和文字之间的间隔
 */
- (void)setLayout:(UIButtonLayoutStyle)aLayoutStyle aSpacing:(CGFloat)aSpacing;

@end
