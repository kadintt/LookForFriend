//
//  APPConfig.h
//  DaoyitongCode
//
//  Created by chenjg on 2018/9/6.
//  Copyright © 2018年 爱康国宾. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define KAPPConfig [APPConfig sharedInstance]

@class RequestHostModel;

@interface APPConfig : NSObject

/// 是否调试模式
@property (nonatomic, assign) BOOL debugMode;
/// 是否打开加密模式
@property (nonatomic, assign) BOOL isSecretAPI;
/// 版本号
@property (nonatomic, strong) NSString *DYT_ProductVersion;
/// host信息
@property (nonatomic, strong) RequestHostModel *host;

@property (nonatomic, strong) NSString *hostString;

@property (nonatomic, strong) NSDictionary *environments;

@property (nonatomic, strong) NSString *testJson;

+ (instancetype)sharedInstance;

@end

@interface RequestHostModel : NSObject

/** 导医通UAT环境 */
@property (nonatomic, strong) NSString *HOSTURL;
/** H5体检UAT环境 */
@property (nonatomic, strong) NSString *H5URL;
/** H5微信Host地址 */
@property (nonatomic, strong) NSString *H5WXURL;
/** 支付UAT环境 */
@property (nonatomic, strong) NSString *PAYURL;
/** 统一支付UAT环境 */
@property (nonatomic, strong) NSString *AccompanyPAYURL;
/** 健康商城Uat环境 */
@property (nonatomic, strong) NSString *MallHost;
/** 腾讯云appid */
@property (nonatomic, strong) NSString *TIMSDK_APPID;
/// ik体检报告URL
@property (nonatomic, strong) NSString *reportURL;
/** 支付appCode */
@property (nonatomic, strong) NSString *payAppCode;

@end

NS_ASSUME_NONNULL_END
