//
//  UIColor+Category.m
//  pavodoctor
//
//  Created by maoge on 2020/4/8.
//  Copyright © 2020 导医通. All rights reserved.
//

#import "UIColor+Category.h"


int convertToInt(char c)
{
    if (c >= '0' && c <= '9') {
        return c - '0';
    } else if (c >= 'a' && c <= 'f') {
        return c - 'a' + 10;
    } else if (c >= 'A' && c <= 'F') {
        return c - 'A' + 10;
    } else {
        return printf("字符非法!");
    }
}

@implementation UIColor (Category)
+ (UIColor *)colorWithString:(NSString *)name {
    return [self colorWithHexString:name];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark - 自定义16进制准换颜色的方法
#pragma mark 16进制以及透明度的颜色转换
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:((float)((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((float)(hexValue & 0xFF)) / 255.0 alpha:alphaValue];
}

#pragma mark 16进制颜色转换
+ (UIColor *)colorWithHex:(NSInteger)hexValue
{
    return [UIColor colorWithHex:hexValue alpha:1.0];
}

#pragma mark 颜色转换为16进制
+ (NSString *)hexFromUIColor:(UIColor *)color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }

    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }

    return [NSString stringWithFormat:@"#0x%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0] * 255.0),
            (int)((CGColorGetComponents(color.CGColor))[1] * 255.0),
            (int)((CGColorGetComponents(color.CGColor))[2] * 255.0)];
}

//绘制渐变色颜色的方法
+ (CAGradientLayer *)setGradualVerticalColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr {
    return [self setGradualColor:view startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1) fromColor:fromHexColorStr toColor:toHexColorStr];
}

+ (CAGradientLayer *)setGradualHorizontalColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr {
    return [self setGradualColor:view startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0) fromColor:fromHexColorStr toColor:toHexColorStr];
}

+ (CAGradientLayer *)setGradualColor:(UIView *)view startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr {
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;

    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:fromHexColorStr].CGColor, (__bridge id)[UIColor colorWithHexString:toHexColorStr].CGColor];

    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;

    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0, @1];

    return gradientLayer;
}

@end
