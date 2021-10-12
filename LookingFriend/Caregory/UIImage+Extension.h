//
//  UIImage+Extension.h
//  DaoyitongCode
//
//  Created by 王帅 on 15/11/4.
//  Copyright © 2015年 爱康国宾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

//根据颜色绘制图片
+ (UIImage *)jq_imageWithColor:(UIColor *)color size:(CGSize)size;

/** 修改图片颜色 */
- (UIImage *)jq_imageWithTintColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *)imageScaledToSize:(CGSize)newSize;

- (UIImage *)imageClipedWithRect:(CGRect)clipRect;

//模糊化图片
- (UIImage *)bluredImageWithRadius:(CGFloat)blurRadius;

//黑白图片
- (UIImage *)monochromeImage;

// 获取图片的主要颜色
- (UIColor *)mostColor;

//截取部分图像
- (UIImage *)getSubImage:(CGRect)rect;

//等比例缩放
- (UIImage *)scaleToSize:(CGSize)size;

//  压缩图片
- (UIImage *)imageCompressForTargetSize:(CGSize)size;

// 限定图片大小进行压缩
+ (UIImage *)clipImage:(UIImage *)image;

+ (UIImage *)resizedImageNamed:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale;

+ (UIImage *)resizedImageNamed:(NSString *)name;

/**
 * 滚动视图截屏
 * @param scrollView view
 * @return image
 */
+ (UIImage *)screenShotScrollView:(UIScrollView*)scrollView;


@end
