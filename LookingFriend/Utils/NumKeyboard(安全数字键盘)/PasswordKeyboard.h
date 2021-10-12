//
//  PasswordKeyboard.h
//  DaoyitongCode
//
//  Created by maoge on 2018/8/21.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordKeyboard : UIView

+ (instancetype) keyboard;

// 输入完成后回调 password为保存的密码
@property (nonatomic, copy) void(^completeBlock)(NSString *password);
// 缩回键盘
@property (nonatomic, copy) void(^hideBoardBlock)(void);

@end
