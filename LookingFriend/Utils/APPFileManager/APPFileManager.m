//
//  FileManager.m
//  Base
//
//  Created by cjg on 2017/9/18.
//  Copyright © 2017年 CJG. All rights reserved.
//

#import "APPFileManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <MJExtension/MJExtension.h>

//https://gitee.com/chen_jg/files/blob/master/%E7%AE%80%E4%B9%A6%E9%A6%96%E9%A1%B5.zip

@interface APPFileManager ()

@end

@implementation APPFileManager

+ (NSString *)fileMD5:(NSString *)filePath {
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!handle) {
        return nil;
    }

    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while (!done) {
        NSData *fileData = [handle readDataOfLength:256];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG) [fileData length]);
        if ([fileData length] == 0)
            done = YES;
    }

    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);

    NSString *result = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                                  digest[0], digest[1],
                                                  digest[2], digest[3],
                                                  digest[4], digest[5],
                                                  digest[6], digest[7],
                                                  digest[8], digest[9],
                                                  digest[10], digest[11],
                                                  digest[12], digest[13],
                                                  digest[14], digest[15]];
    NSLog(@"filePath = %@ /n/n fileMD5 = %@", filePath, result);
    return result;
}

+ (instancetype)sharedInstance {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });

    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
    }
    return self;
}

//- (FMDatabase *)database {
//    NSString *path = [[self getFilePathWithPathType:PathTypeDocuments] stringByAppendingPathComponent:@"fmdb.db"];
//    FMDatabase *database = [[FMDatabase alloc] initWithPath:path];
//    return database;
//}

- (NSString *)getFilePathWithPathType:(PathType)pathType {
    // 获取沙盒主目录
    NSString *homeDir = NSHomeDirectory();
    if (pathType == PathTypeLibrary) {
        // 获取Library的目录路径
        NSString *libDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        return libDir;
    }
    if (pathType == PathTypeCache) {
        // 获取缓存目录
        NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        return cachesDir;

    }
    if (pathType == PathTypeDocuments) {
        // 获取Documents目录路径
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        return docDir;
    }
    if (pathType == PathTypeHtml) {
        // 获取缓存的html路径, Documents/html
        return [self getHtmlFilePath];
    }
    if (pathType == PathTypeCustom) {
        NSString *string = [[self getFilePathWithPathType:PathTypeDocuments] stringByAppendingString:@"/custom"];
        [self creatFileOrDirectory:string isForce:false];
        return string;
    }
    return homeDir;
}

- (NSString *)getHtmlFilePath {
    //先判断路径是否存在
    NSString *docDir = [self getFilePathWithPathType:PathTypeDocuments];
    NSString *htmlDir = [docDir stringByAppendingPathComponent:@"html"];
    if (![_fileManager isExecutableFileAtPath:htmlDir]) { // 如果html目录不存在,就创建
        BOOL success = [_fileManager createDirectoryAtPath:htmlDir withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"创建目录%@%@", htmlDir, success ? @"成功" : @"失败");
        if (success) {
            return htmlDir;
        } else {
            return nil;
        }
    }
    return htmlDir;
}

- (void)unZipFilePath:(NSString *)filePath toPath:(NSString *)toPath progress:(FileManagerBlock)progress finish:(FileManagerBlock)finish errorBlock:(FileManagerBlock)errorBlock {
//    [SSZipArchive unzipFileAtPath:filePath toDestination:toPath progressHandler:^(NSString *_Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
//        if (progress) {
//            float precent = total / entryNumber;
//            progress(@(precent));
//        }
//    }           completionHandler:^(NSString *_Nonnull path, BOOL succeeded, NSError *_Nullable error) {
//        if (succeeded) {
//            NSLog(@"成功解压文件\n%@", filePath);
//            if (finish) {
//                finish(path);
//            }
//        } else {
//            NSLog(@"错误解压文件\n%@, \n错误信息:\n%@", filePath, error);
//            if (errorBlock) {
//                errorBlock(error);
//            }
//        }
//    }];
}

- (BOOL)isExistFile:(NSString *)filePath {
    return [self.fileManager fileExistsAtPath:filePath];
}

- (BOOL)saveJson:(id)json config:(FileManagerBlock)config fileName:(NSString *)fileName {
    if (config) {
        config(json);
    }
    NSString *filePath = [[self getFilePathWithPathType:PathTypeCustom] stringByAppendingPathComponent:fileName];
    if (!json) {
        BOOL success = [self.fileManager removeItemAtPath:filePath error:nil];
        NSLog(@"%@", [NSString stringWithFormat:@"\n/**清除路径**/ \n %@ \n/**是否成功:%@**/ \n", filePath, @(success).stringValue]);
        return success;
    }
    NSString *jsonObjc = [json mj_JSONString];
    if (!jsonObjc) {
        NSLog(@"\n/***/ \n json 为 nil, 写入失败\n /***/");
        return false;
    }
    BOOL success = [jsonObjc writeToFile:filePath atomically:true encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@", [NSString stringWithFormat:@"\n/**写入路径**/ \n %@ \n/**是否成功:%@**/ \n", filePath, @(success).stringValue]);
    return success;

}

- (BOOL)saveJson:(id)json fileName:(NSString *)fileName {
    return [self saveJson:json config:nil fileName:fileName];
}

- (NSString *)getJsonWithFileName:(NSString *)fileName {
    NSString *filePath = [[self getFilePathWithPathType:PathTypeCustom] stringByAppendingPathComponent:fileName];
    NSString *json = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return json;
}

- (BOOL)creatFileOrDirectory:(NSString *)path isForce:(BOOL)isForce {
    NSError *error;
    if ([self isExistFile:path]) {
        if (isForce) {
            [self removePath:path];
            if ([self isFile:path]) {
                return [_fileManager createFileAtPath:path contents:nil attributes:nil];
            } else {
                return [_fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
            }
        } else {
//            NSLog(@"文件已存在,路径:\n%@", path);
            return true;
        }
    } else {
        if ([self isFile:path]) {
            return [_fileManager createFileAtPath:path contents:nil attributes:nil];
        } else {
            return [_fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];

        }
    }
}

// 删除路径下文件或者目录
- (BOOL)removePath:(NSString *)path {
    return [_fileManager removeItemAtPath:path error:nil];
}

// 判断是否文件
- (BOOL)isFile:(NSString *)path {
    return [path componentsSeparatedByString:@"."].count > 1;
}

@end
