//
//  UIView+Catetory.m
//  pavodoctor
//
//  Created by maoge on 2020/4/15.
//  Copyright © 2020 导医通. All rights reserved.
//

#import "UIView+Catetory.h"
#import "UIColor+Category.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "NSArray+Category.h"
#import <objc/runtime.h>
static NSString *tapKey = @"tapKey";

@implementation UIView (Catetory)

- (void)addTranstionColor {
    [self addTranstionColorWithFrame:self.bounds];
}

- (void)addTranstionColorWithFrame:(CGRect)frame {
    [self addTranstionColorWithFrame:frame startColor:[UIColor colorWithHex:0x0080FF] endColor:[UIColor colorWithHex:0x00D0C0] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
}

+ (UIView *)gradientBgColorWithFrame:(CGRect)frame {
    UIView *view = [UIView new];
    [view addTranstionColorWithFrame:frame startColor:[UIColor colorWithHex:0xFFFFFF] endColor:[UIColor colorWithHex:0xFAFAFA] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    return view;
}

- (void)removeTranstionColor {
    NSMutableArray *layers = @[].mutableCopy;
    for (CALayer *subLayer in self.layer.sublayers) {
        if ([subLayer.name isEqualToString:@"渐变色"]) {
            [layers addObject:subLayer];
        }
    }
    for (CALayer *layer in layers) {
        [layer removeFromSuperlayer];
    }
}

- (void)addTranstionColorWithFrame:(CGRect)frame startColor:(UIColor *)sColor endColor:(UIColor *)ecolor startPoint:(CGPoint)sPoint endPoint:(CGPoint)ePoint {
    [self addTranstionColorsWithFrame:frame colors:[NSArray arrayWithObjects:(id)sColor.CGColor, (id)ecolor.CGColor, nil] startPoint:sPoint endPoint:ePoint locations:[NSArray array]];
}

- (void)addTranstionColorsWithFrame:(CGRect)frame colors:(NSArray *)colors startPoint:(CGPoint)sPoint endPoint:(CGPoint)ePoint locations:(NSArray *)locations {
    //为颜色设置渐变效果：
    UIView *view = self;
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = sPoint;
    gradient.endPoint = ePoint;
    gradient.frame = frame;
    gradient.colors = colors;
    gradient.name = @"渐变色";
    if (locations.count) {
        gradient.locations = locations;
    }
    
    [view.layer insertSublayer:gradient atIndex:0];
}

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
}

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width cornerRadius:(CGFloat)radius {
    [self setBorderColor:color width:width];
    if (radius) {
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = YES;
    }
}

/** 删除所有子视图 */
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}
/// 刷新所有子视图的布局
- (void)updateLayoutSubViews {
    [self updateLayout];
    [self.subviews forEach:^(UIView *_Nonnull objc, NSInteger index) {
        [objc updateLayoutSubViews];
    }];
    [self updateLayout];
}

@end

@implementation UIView (KDGesture)

- (UITapGestureRecognizer *)addTapTarget:(id)target selector:(SEL)selector {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    tapGestureRecognizer.cancelsTouchesInView = YES;
    tapGestureRecognizer.delaysTouchesBegan = YES;
    tapGestureRecognizer.delaysTouchesEnded = YES;
    self.userInteractionEnabled = true;
    [self addGestureRecognizer:tapGestureRecognizer];
    return tapGestureRecognizer;
}

- (UILongPressGestureRecognizer *)addLongPressTarget:(id)target selector:(SEL)selector {
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:selector];
    //用几个手指触屏，默认1
    longPressGesture.numberOfTouchesRequired = 1;
    //设置最短长按时间，单位为秒（默认0.5）
    longPressGesture.minimumPressDuration = 0.5;
    //设置手势识别期间所允许的手势可移动范围
    longPressGesture.allowableMovement = 10;
    self.userInteractionEnabled = true;
    [self addGestureRecognizer:longPressGesture];
    return longPressGesture;
}

- (TaplBlock)block {
    return objc_getAssociatedObject(self, &tapKey);
}

- (void)setBlock:(TaplBlock)block {
    objc_setAssociatedObject(self, &tapKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)addTapBlock:(TaplBlock)block {
    self.block = block;
    self.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    __weak typeof(self) weakSelf = self;
    weakSelf.block(tap);
}

@end

@implementation UIView (Responder)

- (UINavigationController *)jq_navController {
    UIResponder *next = self.nextResponder;

    do {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)next;
        }

        next = next.nextResponder;
    } while (next != nil);

    return nil;
}

@end

@implementation UIView (BottomLine)
NSInteger bottomLineTag = 98765411;
NSInteger rightLineTag = 98765410;
NSInteger emptyViewTag = 98765412;

- (void)bottomLineShow:(BOOL)show padding:(CGFloat)padding {
    [self bottomLineShow:show padding:padding lineHeight:0.5];
}

- (void)bottomLightLineShow:(BOOL)show padding:(CGFloat)padding {
    [self bottomLineShow:show padding:padding lineHeight:0.5 lineColor:[UIColor colorWithString:@"#ECEEEF"]];
}

- (void)bottomLineShow:(BOOL)show padding:(CGFloat)padding lineHeight:(CGFloat)lineHeight {
    [self bottomLineShow:show padding:padding lineHeight:lineHeight lineColor:[UIColor colorWithString:@"#E1E0DF"]];
}

- (void)bottomLineShow:(BOOL)show padding:(CGFloat)padding lineHeight:(CGFloat)lineHeight lineColor:(UIColor *)lineColor {
    UIView *line = [self viewWithTag:bottomLineTag];
    if (!line) {
        line = [UIView new];
        line.tag = bottomLineTag;
        line.backgroundColor = lineColor;
        [self addSubview:line];
        line.sd_layout.bottomEqualToView(self).leftSpaceToView(self, padding).rightSpaceToView(self, padding).heightIs(lineHeight);
    }
    line.hidden = !show;
    [line updateLayout];
}

- (void)rightLineShow:(BOOL)show padding:(CGFloat)padding lineWidth:(CGFloat)lineWidth {
    UIView *line = [self viewWithTag:rightLineTag];
    if (!line) {
        line = [UIView new];
        line.tag = rightLineTag;
        line.backgroundColor = [UIColor colorWithString:@"d8d8d8"];
        [self addSubview:line];
        line.sd_layout.bottomSpaceToView(self, padding).topSpaceToView(self, padding).rightSpaceToView(self, 0).widthIs(lineWidth);
    }
    line.hidden = !show;
    [line updateLayout];
}

- (void)topLineShow:(BOOL)show padding:(CGFloat)padding {
    UIView *line = [self viewWithTag:bottomLineTag];
    if (!line) {
        line = [UIView new];
        line.tag = bottomLineTag;
        line.backgroundColor = [UIColor colorWithString:@"ECEEEF"];
        [self addSubview:line];
        line.sd_layout.topEqualToView(self).leftSpaceToView(self, padding).rightSpaceToView(self, padding).heightIs(0.5);
    }
    line.hidden = !show;
    [line updateLayout];
}

@end
