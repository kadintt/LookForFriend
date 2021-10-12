//
//  UIViewController+OpenURL.h
//  pavodoctor
//
//  Created by maoge on 2020/5/7.
//  Copyright © 2020 导医通. All rights reserved.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (OpenURL)

/// 拨打客服电话
- (void)openURLForContactWithNumber:(NSString *)number;
/// 拨打客服电话, 无提示框
- (void)openURLForContactCustomerServiceNoAlert;

@end


NS_ASSUME_NONNULL_END
