//
//  UIImage+Extension.m
//  DaoyitongCode
//
//  Created by 王帅 on 15/11/4.
//  Copyright © 2015年 爱康国宾. All rights reserved.
//

#import "UIImage+Extension.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (Extension)

+ (UIImage *)resizedImage:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (UIImage *)jq_imageWithColor:(UIColor *)color size:(CGSize)size {

    if (!color || size.width <= 0 || size.height <= 0) return nil;

    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 修改图片颜色 */
- (UIImage *)jq_imageWithTintColor:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)imageScaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageClipedWithRect:(CGRect)clipRect {
    CGImageRef imageRef = self.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, clipRect);

    UIGraphicsBeginImageContext(clipRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, clipRect, subImageRef);
    UIImage *clipImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();

    return clipImage;
}

//模糊化图片
- (UIImage *)bluredImageWithRadius:(CGFloat)blurRadius {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [self scale]);
    CGContextRef effectInContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(effectInContext, 1.0, -1.0);
    CGContextTranslateCTM(effectInContext, 0, -self.size.height);
    CGContextDrawImage(effectInContext, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    vImage_Buffer effectInBuffer;
    effectInBuffer.data = CGBitmapContextGetData(effectInContext);
    effectInBuffer.width = CGBitmapContextGetWidth(effectInContext);
    effectInBuffer.height = CGBitmapContextGetHeight(effectInContext);
    effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);

    UIGraphicsBeginImageContextWithOptions(self.size, NO, [self scale]);
    CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
    vImage_Buffer effectOutBuffer;
    effectOutBuffer.data = CGBitmapContextGetData(effectOutContext);
    effectOutBuffer.width = CGBitmapContextGetWidth(effectOutContext);
    effectOutBuffer.height = CGBitmapContextGetHeight(effectOutContext);
    effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);

    BOOL hasBlur = blurRadius > __FLT_EPSILON__;

    if (hasBlur) {
        CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
        uint32_t radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
        if (radius % 2 != 1) {
            radius += 1; // force radius to be odd so that the three box-blur methodology works.
        }
        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
        vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
    }

    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    UIGraphicsEndImageContext();

    return returnImage;
}

//黑白图片
- (UIImage *)monochromeImage {
    CIImage *beginImage = [CIImage imageWithCGImage:[self CGImage]];

    CIColor *ciColor = [CIColor colorWithCGColor:[UIColor lightGrayColor].CGColor];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey, beginImage, kCIInputColorKey, ciColor, nil];
    CIImage *outputImage = [filter outputImage];

    return [UIImage imageWithCIImage:outputImage];
}


// 获取图片的主要颜色
- (UIColor *)mostColor {

    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize = CGSizeMake(50, 50);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
            thumbSize.width,
            thumbSize.height,
            8,//bits per component
            thumbSize.width * 4,
            colorSpace,
            kCGImageAlphaPremultipliedLast);

    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, self.CGImage);
    CGColorSpaceRelease(colorSpace);



    //第二步 取每个点的像素值
    unsigned char *data = CGBitmapContextGetData(context);

    if (data == NULL) {
        CGContextRelease(context);
        return nil;
    };

    NSCountedSet *cls = [NSCountedSet setWithCapacity:thumbSize.width * thumbSize.height];

    for (int x = 0; x < thumbSize.width; x++) {
        for (int y = 0; y < thumbSize.height; y++) {

            int offset = 4 * (x * y);

            int red = data[offset];
            int green = data[offset + 1];
            int blue = data[offset + 2];
            int alpha = data[offset + 3];

            NSArray *clr = @[@(red), @(green), @(blue), @(alpha)];
            [cls addObject:clr];

        }
    }
    CGContextRelease(context);


    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;

    NSArray *MaxColor = nil;
    NSUInteger MaxCount = 0;

    while ((curColor = [enumerator nextObject]) != nil) {
        NSUInteger tmpCount = [cls countForObject:curColor];

        if (tmpCount < MaxCount) continue;

        MaxCount = tmpCount;
        MaxColor = curColor;

    }

    return [UIColor colorWithRed:([MaxColor[0] intValue] / 255.0f) green:([MaxColor[1] intValue] / 255.0f) blue:([MaxColor[2] intValue] / 255.0f) alpha:([MaxColor[3] intValue] / 255.0f)];
}


//截取部分图像
- (UIImage *)getSubImage:(CGRect)rect {
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));

    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();

    CGImageRelease(subImageRef);

    return smallImage;
}

//等比例缩放
- (UIImage *)scaleToSize:(CGSize)size {
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);

    float verticalRadio = size.height * 1.0 / height;
    float horizontalRadio = size.width * 1.0 / width;

    float radio = 1;
    if (verticalRadio > 1 && horizontalRadio > 1) {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    } else {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }

    width = width * radio;
    height = height * radio;

    int xPos = (size.width - width) / 2;
    int yPos = (size.height - height) / 2;

    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);

    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];

    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    // 使当前的context出堆栈
    UIGraphicsEndImageContext();

    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (UIImage *)clipImage:(UIImage *)image {
    image = [image imageCompressForTargetSize:CGSizeMake(image.size.width * 0.5, image.size.height * 0.5)];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    if (imageData.length > 300 * 1024) {
        return [self clipImage:image];
    }
    image = [UIImage imageWithData:imageData];
    return image;
}


- (UIImage *)imageCompressForTargetSize:(CGSize)size {
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    UIGraphicsBeginImageContext(size);

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();

    if (newImage == nil) {
        NSLog(@"scale image fail");
    }

    UIGraphicsEndImageContext();

    return newImage;

}

+ (UIImage *)resizedImageNamed:(NSString *)name {
    return [self resizedImageNamed:name leftScale:0.5 topScale:0.5];
}

+ (UIImage *)resizedImageNamed:(NSString *)name leftScale:(CGFloat)leftScale topScale:(CGFloat)topScale {
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * leftScale topCapHeight:image.size.height * topScale];
}

/**
 * 滚动视图截屏
 * @param scrollView view
 * @return image
 */
+ (UIImage *)screenShotScrollView:(UIScrollView*)scrollView {
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, 0.0);

    //保存collectionView当前的偏移量
    CGPoint savedContentOffset = scrollView.contentOffset;
    CGRect saveFrame = scrollView.frame;

    //将collectionView的偏移量设置为(0,0)
    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);

    //在当前上下文中渲染出collectionView
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    //截取当前上下文生成Image
    image = UIGraphicsGetImageFromCurrentImageContext();

    //恢复collectionView的偏移量
    scrollView.contentOffset = savedContentOffset;
    scrollView.frame = saveFrame;

    UIGraphicsEndImageContext();

    if (image != nil) {
        return image;
    }else {
        return nil;
    }
}

@end
