//
//  DYTHelper.m
//  pavodoctor
//
//  Created by maoge on 2020/7/31.
//  Copyright © 2020 导医通. All rights reserved.
//

#import "DYTHelper.h"
#import <UIKit/UIKit.h>

//版本号对比
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define DYT_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define iOS10_Or_GREATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")
#define iOS8_Or_GREATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

@implementation DYTHelper

+ (void)openURL:(NSString *)openURL canOpenURL:(NSString *)canOpenURL {
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:canOpenURL]] ) {
        [DYTHelper openURL:openURL];
    }
}

+ (void)openURL:(NSString *)openURL canOpenURL:(NSString *)canOpenURL completionHandler:(void (^ __nullable)(BOOL success))completion {
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:canOpenURL]] ) {
        [DYTHelper openURL:openURL options:nil completionHandler:completion];
    }
}

+ (void)openURL:(NSString *)url {
    if (iOS10_Or_GREATER) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

+ (void)openURL:(NSString *)url options:(NSDictionary<NSString *, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion {
    if (iOS10_Or_GREATER) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:options completionHandler:completion];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

@end
