//
//  UIColor+Category.h
//  pavodoctor
//
//  Created by maoge on 2020/4/8.
//  Copyright © 2020 导医通. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIColor (Category)
//以#开头的字符串（不区分大小写），如：#ffFFff，若需要alpha，则传#abcdef255，不传默认为1
+ (UIColor *)colorWithString:(NSString *)name;

//16进制以及透明度的颜色转换
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
//16进制颜色转换
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
//颜色转换为16进制
+ (NSString *) hexFromUIColor: (UIColor*) color;
// 由上至下的渐变
+ (CAGradientLayer *)setGradualVerticalColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
// 由左至右的渐变
+ (CAGradientLayer *)setGradualHorizontalColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;


@end


NS_ASSUME_NONNULL_END
