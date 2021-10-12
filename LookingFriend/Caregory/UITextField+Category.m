
#import "UITextField+Category.h"
#import <objc/runtime.h>
#import <MJRefresh/MJRefresh.h>


@implementation UITextField (Category)

- (void)addLeftPadding:(CGFloat)ftValue
{
    UIView* pView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ftValue, 1)];
    pView.backgroundColor = [UIColor clearColor];
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setLeftView:pView];
}

- (void)setPlaceHolderColor:(UIColor *)color {
    if (color) {
        if (self.placeholder) {
            NSAttributedString *atr = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSFontAttributeName:self.font,NSForegroundColorAttributeName:color}];
            self.attributedPlaceholder = atr;
        }
    }
}
//添加textFiled的左边文字
- (void)addLeftPaddinText:(NSString *)text width:(CGFloat)ftValue height:(CGFloat)height
                    color:(UIColor *)color font:(float)font{
    UIButton *pBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ftValue, height)];
    [pBtn addTarget:self action:@selector(editingBegin) forControlEvents:UIControlEventTouchUpInside];
    
    //[pBtn setImage:image forState:UIControlStateNormal];
    [pBtn setTitle:text forState:UIControlStateNormal];
    //pBtn.font = [UIFont fontWithName:@"Helvetica" size:15.f]; [UIFont boldSystemFontOfSize:24.0f]
    //pBtn.font = [UIFont boldSystemFontOfSize:font];
    [pBtn.titleLabel setFont:[UIFont systemFontOfSize:font]];
    //    pBtn.font = [UIFont fontWithName:@"FZLTXHK--GBK1-0" size:font];  //设置字体大小
    [pBtn setTitleColor:color forState:UIControlStateNormal];
    //    pBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setLeftView:pBtn];
}


- (void)setRightPaddinText:(NSString *)rightStr fontSize:(float)fSize padding:(float)padding {
    
}

- (void)setLeftPaddinText:(NSString *)leftStr fontSize:(float)fSize padding:(float)padding {

}

- (void)editingBegin
{
    [self becomeFirstResponder];
}

- (void)addRightPaddinImage:(UIImage *)image width:(CGFloat)ftValue height:(CGFloat)height
{
    UIButton *pBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ftValue, height)];
    [pBtn setImage:image forState:UIControlStateNormal];
//    pBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self setRightViewMode:UITextFieldViewModeAlways];
    [self setRightView:pBtn];
}

- (void)addRightPaddinImage:(UIImage *)image width:(CGFloat)ftValue height:(CGFloat)height rightAction:(SEL)action target:(id)target
{
    UIButton *pBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ftValue, height)];
    [pBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [pBtn setImage:image forState:UIControlStateNormal];
    pBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10);
    [self setRightViewMode:UITextFieldViewModeAlways];
    [self setRightView:pBtn];
}

- (void)addLeftPaddinImage:(UIImage *)image width:(CGFloat)ftValue height:(CGFloat)height
{
    UIImageView *pBtn = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, ftValue + 5, height)];
    [pBtn setContentMode:UIViewContentModeScaleAspectFit];
    [pBtn setImage:image];
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setLeftView:pBtn];
}

- (void)addLeftImage:(UIImage *)image imageFrame:(CGRect)frame distance:(CGFloat)distance textFileHeight:(CGFloat)height{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:image];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageView.mj_w+imageView.mj_x+distance, height)];
    [leftView addSubview:imageView];
    leftView.userInteractionEnabled = 0;
    [self setLeftView:leftView];
    [self setLeftViewMode:UITextFieldViewModeAlways];
}


- (void)addLeftImage:(UIImage *)image padding:(CGFloat)padding distance:(CGFloat)distance{
    CGFloat height = self.mj_h;
    CGSize size = image.size;
    [self addLeftImage:image imageFrame:CGRectMake(padding, (height - size.height)/2.0, size.width, size.height) distance:distance textFileHeight:height];
}


- (void)addRightImage:(UIImage *)image padding:(CGFloat)padding distance:(CGFloat)distance block:(ImageBlock)block{
    CGFloat height = self.mj_h;
    CGSize size = image.size;
    CGRect frame = CGRectMake(distance, (height - size.height)/2.0, size.width, size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:image];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(self.mj_w-padding-distance-size.width, 0, imageView.mj_w+padding+distance, height)];
    [leftView addSubview:imageView];
    [self setRightView:leftView];
    [self setRightViewMode:UITextFieldViewModeWhileEditing];
    if (block) {
        self.imageBlock = block;
        leftView.userInteractionEnabled = 1;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftViewClick:)];
        [leftView addGestureRecognizer:tap];
    }
}

- (void)leftViewClick:(UITapGestureRecognizer*)tap{
    if (self.imageBlock) {
        self.imageBlock(tap.view.subviews[0]);
    }
}

- (BOOL )isHaveDian {
    return ((NSNumber*)objc_getAssociatedObject(self, @"isHaveDian")).boolValue;
}


- (void)setIsHaveDian:(BOOL)isHaveDian {
    objc_setAssociatedObject(self, @"isHaveDian", @(isHaveDian), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

 static void * imageBlockKey = &imageBlockKey;

- (ImageBlock)imageBlock{
    return objc_getAssociatedObject(self, &imageBlockKey);
}

- (void)setImageBlock:(ImageBlock)imageBlock{
    objc_setAssociatedObject(self, &imageBlockKey, imageBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)verifyTwoInput:(NSRange)range replacementString:(NSString *)string{
    UITextField* textField = self;
    if ([textField.text containsString:@"."]) {
        self.isHaveDian = YES;
    }else{
        self.isHaveDian = NO;
    }
    
    if (string.length > 0) {
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
//        BXLog(@"single = %c",single);
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
//            [MBProgressHUD bwm_showTitle:@"您的输入格式不正确" toView:self hideAfter:1.0];
            return NO;
        }
        
        // 只能有一个小数点
        if (self.isHaveDian && single == '.') {
//            [MBProgressHUD bwm_showTitle:@"最多只能输入一个小数点" toView:self hideAfter:1.0];
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
//                    [MBProgressHUD bwm_showTitle:@"第二个字符需要是小数点" toView:self hideAfter:1.0];
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
//                    [MBProgressHUD bwm_showTitle:@"第二个字符需要是小数点" toView:self hideAfter:1.0];
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
//                    [MBProgressHUD bwm_showTitle:@"小数点后最多有两位小数" toView:self hideAfter:1.0];
                    return NO;
                }
            }
        }
    }
    return YES;
}

@end
