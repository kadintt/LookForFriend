//
//  DES3Util.m
//  DaoyitongCode
//
//  Created by maoge on 2018/9/17.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import "DES3Util.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "GTMBase64.h"

//密匙 key
NSString* const gkey = @"3gfNoZOCAnWJu94RfiNNop5O";

//偏移量
#define gIv  @""

@implementation DES3Util

+ (NSString *)key {
    return gkey;
}

// 加密HEX
+ (NSString*)encryptHex:(NSString*)plainText {
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t bufferPtrSize = 0; //size_t  是操作符sizeof返回的结果类型
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize); //将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    const void *vkey = (const void *) [gkey UTF8String];
    
    //CCCrypt函数 加密
    ccStatus = CCCrypt(kCCEncrypt,//  加密/解密
                       kCCAlgorithm3DES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,//密钥
                       kCCKeySize3DES,//   DES 密钥的大小（kCCKeySize3DES=24）
                       NULL,//  可选的初始矢量(偏移量)
                       vplainText,// 数据的存储单元
                       plainTextBufferSize,// 数据的大小
                       (void *)bufferPtr,// 用于返回数据
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    
    // 将Data信息转为Hex串
    NSString *result = [self hexStringFromData:myData];
    free(bufferPtr);
    return result ? result : @"";
}

// 解密HEX
+ (NSString*)decryptHex:(NSString*)encryptText {
    
    NSData *encryptData = [self hexStringToData:encryptText];
    
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [gkey UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       NULL,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                      length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    
    result = [result stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    // 解决返回数据过长导致的解密失败问题
//    result = [(NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)result,CFSTR(""), kCFStringEncodingUTF8) autorelease];
    
    free(bufferPtr);
    
    return result;
}

+ (NSString *)hexStringFromData:(NSData *)data{
    NSUInteger len = [data length];
    char *chars = (char *)[data bytes];
    NSMutableString *hexString = [[NSMutableString alloc]init];
    for (NSUInteger i=0; i<len; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx",chars[i]]];
    }
    return hexString;
}



+ (NSData *)hexStringToData:(NSString *)hexString{
    const char *chars = [hexString UTF8String];
    int i = 0;
    int len = (int)hexString.length;
    NSMutableData *data = [NSMutableData dataWithCapacity:len/2];
    char byteChars[3] = {'\0','\0','\0'};
    unsigned long wholeByte;
    
    while (i<len) {
        byteChars[0] = chars[i++];
        byteChars[1] = chars[i++];
        wholeByte = strtoul(byteChars, NULL, 16);
        [data appendBytes:&wholeByte length:1];
    }
    return data;
}

+ (NSString *)encrypt:(NSString *)plainText{
    
    NSData * data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void * vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t * bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t moveByTes = 0;
    
    bufferPtrSize = (plainTextBufferSize * kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0*0, bufferPtrSize);
    
    const void * vKey = (const void *)[gkey UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vKey,
                       kCCKeySize3DES,
                       NULL,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &moveByTes);
    NSData * resultData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)moveByTes];
    NSString * resultString = [GTMBase64 stringByEncodingData:resultData];
    
    return resultString;
}


+ (NSString *)decrypt:(NSString *)encryptText{
    
    NSData * data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    
    size_t plainTextBufferSize = data.length;
    const void * vplainText = [data bytes];
    
    CCCryptorStatus status;
    
    uint8_t * bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t moveByTes = 0;
    
    bufferPtrSize = (plainTextBufferSize * kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    
    memset(bufferPtr, 0*0, bufferPtrSize);
    
    const void * vkey = (const void *)[gkey UTF8String];
    
    status = CCCrypt(kCCDecrypt, kCCAlgorithm3DES, kCCOptionPKCS7Padding, vkey, kCCKeySize3DES, NULL, vplainText, plainTextBufferSize, (void *)bufferPtr, bufferPtrSize, &moveByTes);
    
    NSString * esultString = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)moveByTes] encoding:NSUTF8StringEncoding];
    
    return esultString;
    
}


@end
