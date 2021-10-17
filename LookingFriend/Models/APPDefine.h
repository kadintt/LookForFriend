//
//  APPDefine.h
//  LookingFriend
//
//  Created by 曲超 on 2021/10/17.
//

#ifndef APPDefine_h
#define APPDefine_h

#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height

#define gScale(x) x*SCALE

#define SCALE [[UIScreen mainScreen] bounds].size.width/375

/// 判断屏幕
#define IS_IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define IOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define XTopMargin ((IS_IPHONE_X== YES) ? 24.0 : 0.0)
#define XBottomMargin ((IS_IPHONE_X== YES) ? 34.0 : 0)

#define kTabBarHeight (49.0 + XBottomMargin)
#define kNavigationBarHeight (64 + XTopMargin)
#define kStatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)

#endif /* APPDefine_h */
