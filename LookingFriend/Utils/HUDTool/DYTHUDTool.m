//
//  DYTHUDTool.m
//  DaoyitongCode
//
//  Created by maoge on 2018/8/7.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import "DYTHUDTool.h"
#import <MBProgressHUD/MBProgressHUD.h>
//#import "XLBallLoading.h"
#import "LookingFriend-Swift.h"

@implementation DYTHUDTool

#pragma mark  - WDToast

+ (void)showWDToast:(NSString *)text {
    
    for (MBProgressHUD* hud in UIApplication.sharedApplication.keyWindow.subviews) {
        if ([hud isKindOfClass:[MBProgressHUD class]] && hud.mode == MBProgressHUDModeText) {
            [hud hideAnimated:false];
        }
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:UIApplication.sharedApplication.keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    hud.label.textColor = [UIColor whiteColor];
    hud.userInteractionEnabled = false;
    [hud hideAnimated:YES afterDelay:1.5];
}

#pragma mark  - MBProgressHUD

+ (void)showMBHUDView:(UIView *)view {
//    [self showMBHUDMessage:nil view:view];
//    [XLBallLoading showInView:view];
    
    [DYTLoadingView showLoadingIn:view];

}

+ (void)showMBHUDMessage:(NSString *)message view:(UIView *)view {
    [self showMBHUDMessage:message view:view hideAfter:0];
}

+ (void)showMBHUDMessage:(NSString *)message view:(UIView *)view hideAfter:(NSTimeInterval)second {
    [self showLoadingWithMessage:message onView:view hideAfter:second];
}

+ (void)showLoadingWithMessage:(NSString *)message onView:(UIView *)aView hideAfter:(NSTimeInterval)second {
    if (!aView) {
        aView = UIApplication.sharedApplication.keyWindow;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    // 改MB样式
     hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
     hud.bezelView.backgroundColor = [UIColor clearColor];
     for (UIActivityIndicatorView* activity in hud.bezelView.subviews) {
         if ([activity isKindOfClass:[UIActivityIndicatorView class]]) {
             activity.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
         }
     }
    if (message) {
        hud.label.text = message;
        hud.label.font = [UIFont systemFontOfSize:12];
    }
    if (second > 0) {
        [hud hideAnimated:YES afterDelay:second];
    }
}

+ (void)hideMBHUDView:(UIView *)view {
    if (!view) {
        view = UIApplication.sharedApplication.keyWindow;
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
     [DYTLoadingView hideLoadingIn:view];
}

+ (void)hideAllMBHUDsForView:(UIView *)view {
    for (MBProgressHUD* hud in view.subviews) {
        if ([hud isKindOfClass:[MBProgressHUD class]]) {
            [hud hideAnimated:YES];
        }
    }
}

+ (void)showProgress:(NSProgress *)progress {
    
}

@end
