//
//  UIButton+ImageTitleSpacing.m
//  SystemPreferenceDemo
//
//  Created by moyekong on 12/28/15.
//  Copyright © 2015 wiwide. All rights reserved.
//

#import "UIButton+ImageTitleSpacing.h"
#import <objc/runtime.h>

@implementation UIButton (ImageTitleSpacing)

- (void)layoutButtonWithEdgeInsetsStyle:(MKButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space
{
    //    self.backgroundColor = [UIColor cyanColor];

    /**
     *  前置知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */

    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;

    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }

    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;

    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case MKButtonEdgeInsetsStyleTop: {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight - space / 2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight - space / 2.0, 0);
        }
        break;
        case MKButtonEdgeInsetsStyleLeft: {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space / 2.0, 0, space / 2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space / 2.0, 0, -space / 2.0);
        }
        break;
        case MKButtonEdgeInsetsStyleBottom: {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight - space / 2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight - space / 2.0, -imageWith, 0, 0);
        }
        break;
        case MKButtonEdgeInsetsStyleRight: {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + space / 2.0, 0, -labelWidth - space / 2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith - space / 2.0, 0, imageWith + space / 2.0);
        }
        break;
        default:
            break;
    }

    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

@end

@implementation UIButton (EnlargeTouchArea)

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left
{
    objc_setAssociatedObject(self, &topNameKey, @(top), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, @(right), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, @(bottom), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, @(left), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect
{
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    //如果按钮设置为不可点击、隐藏、透明度小于等于0.01或者点击在按钮内部，则直接执行父类方法
    if (CGRectEqualToRect(rect, self.bounds) || self.userInteractionEnabled == NO || self.hidden == YES || self.alpha <= 0.01) {
        return [super hitTest:point withEvent:event];
    }
    //判断点击是否在放大的范围内
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end

@implementation UIButton (Expand)

- (void)setLayout:(UIButtonLayoutStyle)aLayoutStyle aSpacing:(CGFloat)aSpacing
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;

    CGFloat totalHeight = (imageSize.height + titleSize.height + aSpacing);
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsZero;
    if (aLayoutStyle == ImageLeftTitleRightStyle) {
        imageEdgeInsets = UIEdgeInsetsMake(0, -(aSpacing / 2.0f), 0, 0);
        titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(aSpacing / 2.0f));
    } else if (aLayoutStyle == TitleLeftImageRightStyle) {
        imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -(titleSize.width * 2 + aSpacing / 2.0f));
        titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width * 2 + aSpacing / 2.0f), 0, 0);
    } else if (aLayoutStyle == ImageTopTitleBottomStyle) {
        imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height),
                                           0.0,
                                           0.0,
                                           -titleSize.width);
        titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                           -imageSize.width,
                                           -(totalHeight - titleSize.height),
                                           0.0);
    } else if (aLayoutStyle == TitleTopImageBottomStyle) {
        imageEdgeInsets = UIEdgeInsetsMake(0.0,
                                           0.0,
                                           -(totalHeight - imageSize.height),
                                           -titleSize.width);

        titleEdgeInsets = UIEdgeInsetsMake(-(totalHeight - titleSize.height),
                                           0.0,
                                           -imageSize.width,
                                           0.0);
    }

    if (!UIEdgeInsetsEqualToEdgeInsets(self.imageEdgeInsets, imageEdgeInsets)
        || !UIEdgeInsetsEqualToEdgeInsets(self.titleEdgeInsets, titleEdgeInsets)) {
        self.imageEdgeInsets = imageEdgeInsets;
        self.titleEdgeInsets = titleEdgeInsets;
        [self layoutIfNeeded];
    }
}

- (void)setALayoutStyle:(NSInteger)aLayoutStyle {
    objc_setAssociatedObject(self, @selector(aLayoutStyle), @(aLayoutStyle), OBJC_ASSOCIATION_ASSIGN);

    [self setLayout:aLayoutStyle aSpacing:[self aSpacing]];
}

- (NSInteger)aLayoutStyle {
    return [objc_getAssociatedObject(self, @selector(aLayoutStyle)) integerValue];
}

- (void)setASpacing:(CGFloat)aSpacing {
    objc_setAssociatedObject(self, @selector(aSpacing), @(aSpacing), OBJC_ASSOCIATION_ASSIGN);

    [self setLayout:[self aLayoutStyle] aSpacing:aSpacing];
}

- (CGFloat)aSpacing {
    return [objc_getAssociatedObject(self, @selector(aSpacing)) floatValue];
}

@end
