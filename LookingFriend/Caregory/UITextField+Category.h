
#import <UIKit/UIKit.h>

typedef void(^ImageBlock)(UIImageView* imageV);

@interface UITextField (Category)

@property (nonatomic, assign) BOOL isHaveDian;

@property (nonatomic, copy)  ImageBlock imageBlock;

- (void)addLeftPadding:(CGFloat)ftValue;
- (void)addRightPaddinImage:(UIImage *)image width:(CGFloat)ftValue height:(CGFloat)height;
- (void)addLeftPaddinImage:(UIImage *)image width:(CGFloat)ftValue height:(CGFloat)height;
- (void)setLeftPaddinText:(NSString *)leftStr fontSize:(float)fSize padding:(float)padding;
- (void)setRightPaddinText:(NSString *)rightStr fontSize:(float)fSize padding:(float)padding;
- (void)setPlaceHolderColor:(UIColor *)color;
/**
 *  添加左边的图片
 *
 *  @param distance 图片和文字的距离
 *  @param image 图片
 *  @param frame 图片在textFiled里的坐标
 */
- (void)addLeftImage:(UIImage*)image imageFrame:(CGRect)frame distance:(CGFloat)distance textFileHeight:(CGFloat)height;
- (void)addLeftPaddinText:(NSString *)text width:(CGFloat)ftValue height:(CGFloat)height
                    color:(UIColor *)color font:(float)font;

- (void)addLeftImage:(UIImage*)image padding:(CGFloat)padding distance:(CGFloat)distance;

- (void)addRightImage:(UIImage*)image padding:(CGFloat)padding distance:(CGFloat)distance block:(ImageBlock)block;


- (BOOL)verifyTwoInput:(NSRange)range
     replacementString:(NSString*)string;

@end
