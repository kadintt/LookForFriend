//
//  DYTHUDTool.h
//  DaoyitongCode
//
//  Created by maoge on 2018/8/7.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TapBlock)(void);

@interface DYTHUDTool : NSObject

/**
 *  WDToast
 */

/** 显示WDToast 默认显示时间为TOASTSHOWTIME */
+ (void)showWDToast:(NSString *)text;


/**
 *  MBProgressHUD
 */

/** 展示MBProgressHUD */
+ (void)showMBHUDView:(UIView *)view;

/** 展示MBProgressHUD带文字 */
+ (void)showMBHUDMessage:(NSString *)message view:(UIView *)view;

/** 展示MBProgressHUD带文字 并设置隐藏间隔 */
+ (void)showMBHUDMessage:(NSString *)message view:(UIView *)view hideAfter:(NSTimeInterval)second;

/** 隐藏MBProgressHUD */
+ (void)hideMBHUDView:(UIView *)view;

/** 隐藏指定view的所有MBProgressHUD */
+ (void)hideAllMBHUDsForView:(UIView *)view;
@end
