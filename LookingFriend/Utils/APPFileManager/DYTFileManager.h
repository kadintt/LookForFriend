//
//  DYTFileManager.h
//  DaoyitongCode
//
//  Created by maoge on 2019/8/6.
//  Copyright © 2019 爱康国宾. All rights reserved.
//

#import <Foundation/Foundation.h>

#define strIsEmpty(str)      (str==nil || [str length]==0 || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
#define root [UIApplication sharedApplication].keyWindow.rootViewController


extern NSString * DocumentsDirectory();
extern NSString * CachesDirectory();
extern NSString *const contactFile;


@interface DYTFileManager : NSObject

/// 下载图片文件
+ (void)downloadFile:(NSDictionary * __nonnull)params
     downloadSuccess:(void (^_Nullable)(NSURLResponse *  __nullable response, NSString * __nullable filePath))success
     downloadFailure:(void (^_Nullable)(NSError * __nullable error))failure
    downloadProgress:(void (^_Nullable)(NSProgress * __nullable downloadProgress))progress;

/// 判断是否存在
+ (BOOL)isFileExist: (NSDictionary *_Nullable)params;

/// 删除相关路径文件
+ (void)removeDirectoryPath:(NSString *_Nullable)directoryPath;

/// 获取文件大小
+ (void)getFileSize:(NSString *_Nonnull)directoryPath completion:(void(^_Nonnull)(NSInteger totalSize))completion;

/// 换算缓存大小
+ (NSString *_Nonnull)cacheSizeStr: (NSInteger)totalSize;

/// 根据字典获取文件路径
+ (NSString *_Nullable)previewFile: (NSDictionary *_Nullable)params;

/// 创建文件存储路径
+ (void) createContactFilePath;
/// 获取路径
+ (NSString *_Nullable)contactPath;

+ (BOOL)fileExistAtPath: (NSString *_Nullable)path;
@end
