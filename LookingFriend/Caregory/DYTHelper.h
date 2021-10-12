//
//  DYTHelper.h
//  pavodoctor
//
//  Created by maoge on 2020/7/31.
//  Copyright © 2020 导医通. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYTHelper : NSObject

+ (void)openURL:(NSString *_Nullable)openURL canOpenURL:(NSString *_Nullable)canOpenURL;
+ (void)openURL:(NSString *_Nullable)openURL canOpenURL:(NSString *_Nullable)canOpenURL completionHandler:(void (^ __nullable)(BOOL success))completion;

+ (void)openURL:(NSString *_Nullable)url;
+ (void)openURL:(NSString *_Nullable)url options:(NSDictionary<NSString *, id> *_Nullable)options completionHandler:(void (^ __nullable)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END
