//
//  BaseWebViewController.h
//  Base
//
//  Created by cjg on 2017/9/4.
//  Copyright © 2017年 CJG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "DCViewController.h"

typedef void (^WebViewBlock)(id item);

@interface BaseWebViewController : DCViewController<WKUIDelegate, WKNavigationDelegate, UIWebViewDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webview;

/**
 * 自动设置导航栏返回按钮等, 默认yes
 */
@property (nonatomic, assign) BOOL autoNav;

/** 当前请求的url */
@property (nonatomic, strong) NSString *curURL;

/** 第一次请求的url */
@property (nonatomic, strong) NSString *firstURL;

/** web页面中的图片链接数组 */
@property (nonatomic, strong) NSMutableArray *imgSrcArray;

/** 网页标题更改回调 */
@property (nonatomic, strong) WebViewBlock titleBlock;

/** 是否清楚cookie,默认YES */
@property (nonatomic, assign) BOOL isRemoveCookies;

/** 是否取网页标题为controller标题,默认YES */
@property (nonatomic, assign) BOOL isAutoTitle;

/**
 是否显示加载的HTML页面源码 default NO
 */
@property (nonatomic, assign) BOOL isDisplayHTML;

/**
 是否显示加载的HTML页面中的cookie default NO
 */
@property (nonatomic, assign) BOOL isDisplayCookies;

/**
 是否本地链接,默认NO
 */
@property (nonatomic, assign) BOOL isLocal;

- (instancetype)initWithURL:(NSString *)URL;

- (NSMutableURLRequest *)configRequest:(NSString *)url;

- (void)openURL:(NSString *)url;

- (void)setLocalURL:(NSString *)url basePath:(NSString *)basePath;

- (void)downloadLoacl:(NSString *)url fileId:(NSString *)fileId fileName:(NSString *)fileName;

- (void)openLocalURL:(NSString *)url basePath:(NSString *)basePath;

- (void)close;

- (void)goBack;

@end
