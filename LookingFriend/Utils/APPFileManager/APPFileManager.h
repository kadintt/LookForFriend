//
//  FileManager.h
//  Base
//
//  Created by cjg on 2017/9/18.
//  Copyright © 2017年 CJG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FileManagerBlock)(id item);

typedef enum : NSUInteger {
    PathTypeLibrary,
    PathTypeCache,
    PathTypeDocuments,
    PathTypeHtml, //h5缓存路径 PathTypeDocuments/html
    PathTypeCustom //save json缓存路径
} PathType;


@interface APPFileManager : NSObject

@property(nonatomic, strong) NSFileManager *fileManager;

+ (instancetype)sharedInstance;


/**
 获取文件路径md5值
 
 @param filePath filePath description
 @return return value description
 */
+ (NSString *)fileMD5:(NSString *)filePath;

/**
 * 默认数据库
 * @return 数据库实例
 */
//- (FMDatabase *)database;

/**
 获取目录路径

 @param pathType pathType description
 @return return value description
 */
- (NSString *)getFilePathWithPathType:(PathType)pathType;


/**
 解压操作

 @param filePath zip路径
 @param toPath 解压路劲
 @param progress 进度
 @param finish 成功回调
 @param errorBlock 失败回调
 */
- (void)unZipFilePath:(NSString *)filePath toPath:(NSString *)toPath
             progress:(FileManagerBlock)progress
               finish:(FileManagerBlock)finish
           errorBlock:(FileManagerBlock)errorBlock;

/**
 是否存在文件/文件夹

 @param filePath 文件/文件夹路径
 @return return value description
 */
- (BOOL)isExistFile:(NSString *)filePath;


/**
  存储json,  json为任意可序列化的objc对象

 @param json objc
 @param config 可以在这里对objc进行一些操作
 @param fileName 文件名
 @return return value description
 */
- (BOOL)saveJson:(id)json
          config:(FileManagerBlock)config
        fileName:(NSString *)fileName;


/**
 存储json,  json为任意可序列化的objc对象

 @param json objc
 @param fileName 文件名
 @return return value description
 */
- (BOOL)saveJson:(id)json
        fileName:(NSString *)fileName;


/**
 根据文件名去json

 @param fileName fileName description
 @return return value description
 */
- (NSString *)getJsonWithFileName:(NSString *)fileName;


/**
 创建文件或者文件夹

 @param path 路径或者文件名
 @param isForce 是否强制创建(如文件或者目录存在则删除原有的)
 @return 写入成功/失败
 */
- (BOOL)creatFileOrDirectory:(NSString *)path isForce:(BOOL)isForce;


- (BOOL)removePath:(NSString *)path;

@end
