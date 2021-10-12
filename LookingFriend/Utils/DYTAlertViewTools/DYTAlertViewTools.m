//
//  DYTAlertViewTools.m
//  DaoyitongCode
//
//  Created by maoge on 2018/7/23.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import "DYTAlertViewTools.h"
#import "UIColor+Category.h"

#define RootVC [[UIApplication sharedApplication] keyWindow].rootViewController

@interface DYTAlertViewTools ()

@property (nonatomic, copy) AlertViewBlock block;

@end

@implementation DYTAlertViewTools

#pragma mark - 对外方法
+ (DYTAlertViewTools *)shareInstance {
    static DYTAlertViewTools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[self alloc] init];
    });
    return tools;
}

/**
 *  创建提示框
 */
- (void) showAlert:(NSString *)title
           message:(NSString *)message
       cancelTitle:(NSString *)cancelTitle
        titleArray:(NSArray *)titleArray
    viewController:(UIViewController *)vc
           confirm:(AlertViewBlock)confirm {
    //
    if (!vc) vc = RootVC;

    [self p_showAlertController:title message:message
                    cancelTitle:cancelTitle titleArray:titleArray
                 viewController:vc confirm:^(NSInteger buttonTag) {
        if (confirm) confirm(buttonTag);
    }];
}

/**
 *  创建菜单(Sheet)
 */
- (void) showSheet:(NSString *)title
           message:(NSString *)message
       cancelTitle:(NSString *)cancelTitle
        titleArray:(NSArray *)titleArray
    viewController:(UIViewController *)vc
           confirm:(AlertViewBlock)confirm {
    if (!vc) vc = RootVC;

    [self p_showSheetAlertController:title message:message cancelTitle:cancelTitle
                          titleArray:titleArray viewController:vc confirm:^(NSInteger buttonTag) {
        if (confirm) confirm(buttonTag);
    }];
}

#pragma mark - ----------------内部方法------------------

//UIAlertController(iOS8及其以后)
- (void)p_showAlertController:(NSString *)title
                      message:(NSString *)message
                  cancelTitle:(NSString *)cancelTitle
                   titleArray:(NSArray *)titleArray
               viewController:(UIViewController *)vc
                      confirm:(AlertViewBlock)confirm {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    if (message) {
        // 修改message字体及颜色
        NSMutableAttributedString *messageStr = [[NSMutableAttributedString alloc] initWithString:message];
        //    [messageStr addAttribute:NSForegroundColorAttributeName value:UIColor.text range:NSMakeRange(0, messageStr.length)];
        [messageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, messageStr.length)];

        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.paragraphSpacing = 4.f;
        paragraphStyle.lineSpacing = 4.f;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [messageStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, messageStr.length)];
        [alert setValue:messageStr forKey:@"attributedMessage"];
    }

    if (cancelTitle) {
        // 取消
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action) {
            if (confirm) confirm(cancelIndex);
        }];
        [cancelAction setValue:[UIColor colorWithString:@"#8E8E93"] forKey:@"_titleTextColor"];
        [alert addAction:cancelAction];
    }
    // 确定操作
    if (!titleArray || titleArray.count == 0) {
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction *_Nonnull action) {
            if (confirm) confirm(0);
        }];
        [confirmAction setValue:[UIColor colorWithString:@"#007AFF"] forKey:@"_titleTextColor"];
        [alert addAction:confirmAction];
    } else {
        for (NSInteger i = 0; i < titleArray.count; i++) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:titleArray[i]
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *_Nonnull action) {
                if (confirm) confirm(i);
            }];
            [action setValue:[UIColor colorWithString:@"#007AFF"] forKey:@"_titleTextColor"];  // 此代码 可以修改按钮颜色
            [alert addAction:action];
        }
    }

    [vc presentViewController:alert animated:YES completion:nil];
}

// ActionSheet的封装
- (void)p_showSheetAlertController:(NSString *)title
                           message:(NSString *)message
                       cancelTitle:(NSString *)cancelTitle
                        titleArray:(NSArray *)titleArray
                    viewController:(UIViewController *)vc
                           confirm:(AlertViewBlock)confirm {
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    if (!cancelTitle) cancelTitle = @"取消";
    // 取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action) {
        if (confirm) confirm(cancelIndex);
    }];
    [sheet addAction:cancelAction];

    if (titleArray.count > 0) {
        for (NSInteger i = 0; i < titleArray.count; i++) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:titleArray[i]
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *_Nonnull action) {
                if (confirm) confirm(i);
            }];
            [sheet addAction:action];
        }
    }

    [vc presentViewController:sheet animated:YES completion:nil];
}

@end
