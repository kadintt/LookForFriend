//
//  PasswordKeyboard.h
//  DaoyitongCode
//
//  Created by maoge on 2018/8/21.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import "PasswordKeyboard.h"

#define main_bounds [UIScreen mainScreen].bounds
#define scale_w main_bounds.size.width/375.0

@interface UIView(keyboard)
- (CGFloat)getSupH;
@end
@implementation UIView(keyboard)
- (CGFloat)getSupH {
    NSMutableArray *svHs = [NSMutableArray array];
    for (UIView *sv in self.subviews) {
        [svHs addObject:@(CGRectGetMaxY(sv.frame))];
    }
    CGFloat max = [[svHs valueForKeyPath:@"@max.doubleValue"] floatValue];
    return max;
}
@end

@interface PasswordKeyboard()

//键盘视图
@property (weak, nonatomic) IBOutlet UIView *boardView;
//显示密码的视图
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *dotViews;
//键盘视图的y(用于动画)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomY;
//键盘按钮的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyBtnH;
//密码显示视图的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordH;
//数字数组
@property (nonatomic, strong) NSMutableArray *numbers;

@end
@implementation PasswordKeyboard

+ (instancetype) keyboard {
    PasswordKeyboard *keyboard = [[NSBundle mainBundle] loadNibNamed:@"PasswordKeyboard" owner:nil options:nil].firstObject;
    keyboard.frame = main_bounds;
    keyboard.passwordH.constant *= scale_w;
    keyboard.keyBtnH.constant *= scale_w;
    
    return keyboard;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = main_bounds;
    self.passwordH.constant *= scale_w;
    self.keyBtnH.constant *= scale_w;
}

- (IBAction)back:(id)sender {
    if (_hideBoardBlock) {
        _hideBoardBlock();
    }
}

- (IBAction)keyTap:(UIButton *)sender {
    NSString *str = [NSString stringWithFormat:@"%ld",sender.tag - 200];
    [self.numbers addObject:str];
    [self handleDot];
    if (self.numbers.count == _dotViews.count) {
        NSString *password = [self.numbers componentsJoinedByString:@""];
        if (_completeBlock) {
            _completeBlock(password);
        }
    }
}


- (IBAction)deleteNum:(id)sender {
    if (self.numbers.count > 0) {
        [self.numbers removeObjectAtIndex:self.numbers.count - 1];
        [self handleDot];
    }
}

- (void)handleDot {
    [_dotViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.numbers.count) {
            obj.hidden = NO;
        }
        else {
            obj.hidden = YES;
        }
    }];
}

- (NSMutableArray *)numbers {
    if (!_numbers) {
        _numbers = [NSMutableArray array];
    }
    return _numbers;
}

@end
