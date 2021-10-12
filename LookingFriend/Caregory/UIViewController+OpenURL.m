//
//  UIViewController+OpenURL.m
//  pavodoctor
//
//  Created by maoge on 2020/5/7.
//  Copyright © 2020 导医通. All rights reserved.
//
//版本号对比



#import "UIViewController+OpenURL.h"
#import "UIColor+Category.h"
#import "DYTHelper.h"

@implementation UIViewController (OpenURL)

- (void)openURLForContactWithNumber:(NSString *)number {
    NSString *alertString = [NSString stringWithFormat:@"\n是否立即拨打客服电话\n %@", number];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:alertString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [cancel setValue:[UIColor colorWithString:@"#999999"] forKey:@"_titleTextColor"];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"立即拨打" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [DYTHelper openURL:[NSString stringWithFormat:@"tel://%@", number]];
        
    }];
    [confirm setValue:[UIColor colorWithString:@"#007AFF"] forKey:@"_titleTextColor"];
    
    [alert addAction:cancel];
    [alert addAction:confirm];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)openURLForContactCustomerServiceNoAlert {
    [DYTHelper openURL:@"tel://400-920-2323"];
}
@end


