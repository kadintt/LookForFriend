//
//  DES3Util.h
//  DaoyitongCode
//
//  Created by maoge on 2018/9/17.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DES3Util : NSObject

/// 加密的公钥
+ (NSString *)key;

// 3EDS加密为HEX串
+ (NSString*)encryptHex:(NSString*)plainText;

// 3EDS解密为HEX串
+ (NSString*)decryptHex:(NSString*)encryptText;

// 3DES加密Base64
+ (NSString *)encrypt:(NSString *)plainText;

// 3DES解密Base64
+ (NSString *)decrypt:(NSString *)encryptText;

@end
