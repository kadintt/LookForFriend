//
//  BaseWebViewController.m
//  Base
//
//  Created by cjg on 2017/9/4.
//  Copyright © 2017年 CJG. All rights reserved.
//

#import "BaseWebViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
#import "DYTFileManager.h"
#import "DYTHUDTool.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface BaseWebViewController ()

/** 进度条 */
@property(nonatomic, strong) UIProgressView *progressView;

@property(nonatomic, strong) NSString *localURL;

@property(nonatomic, strong) NSString *baseURL;

@end

@implementation BaseWebViewController

- (instancetype)init {
    self = [super init];
    if (self) { // custom configer
        _isRemoveCookies = YES;
        _isAutoTitle = YES;
        _isDisplayHTML = NO;
        _isDisplayCookies = NO;
        _autoNav = YES;
    }
    return self;
}

- (instancetype)initWithURL:(NSString *)URL {
    self = [self init];
    if (self) {
        _firstURL = URL;
        _curURL = URL;
    }
    return self;
}

#pragma mark - controller生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = false;
    self.extendedLayoutIncludesOpaqueBars = true;
    [self creatItems];
    if (_isLocal) {
        [self openLocalURL:_localURL basePath:_baseURL];
    }
    [self setupUI];
    if (!_isLocal) {
        [self openURL:self.firstURL];
    }
    self.webview.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)dealloc {
    [self removeCookies];
    [_webview removeObserver:self forKeyPath:@"title"];
    [_webview removeObserver:self forKeyPath:@"estimatedProgress"];
    _webview.configuration.processPool = [WKProcessPool new];
    [_webview.configuration.userContentController removeAllUserScripts];
    _webview.navigationDelegate = nil;
    _webview.UIDelegate = nil;
    NSLog(@"webView被销毁了☠️☠️☠️");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 3);
}

#pragma mark - function

- (NSMutableURLRequest *)configRequest:(NSString *)url {
    NSURL *URL = [NSURL URLWithString:url];
    if (!URL) {
        NSLog(@"url不正确 ===== %@", url);
        return nil;
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    if (!request) {
        NSLog(@"request不正确 ===== %@", url);
        return nil;
    }
    return request;
}

- (void)openURL:(NSString *)url {
    NSURLRequest *request = [self configRequest:url];
    if (request) {
        [_webview loadRequest:request];
    }
}

- (void)setLocalURL:(NSString *)url basePath:(NSString *)basePath {
    _localURL = url;
    _baseURL = basePath;
    _isLocal = true;
}

- (void)downloadLoacl:(NSString *)url fileId:(NSString *)fileId fileName:(NSString *)fileName {

    NSDictionary *dict = @{ @"url": url,
                            @"fileId": fileId,
                            @"fileName": fileName };

    if (![DYTFileManager isFileExist:dict]) {
        [DYTFileManager downloadFile:dict downloadSuccess:^(NSURLResponse *_Nonnull response, NSString *_Nonnull filePath) {
            [self openLocalURL:filePath basePath:nil];
        } downloadFailure:^(NSError *_Nonnull error) {
            [DYTHUDTool showWDToast:@"加载失败"];
        } downloadProgress:nil];
    } else {
        [self openLocalURL:[DYTFileManager previewFile:dict] basePath:nil];
    }
}

- (void)openLocalURL:(NSString *)url basePath:(NSString *)basePath {
    _isLocal = true;
//    basePath = [[[APPFileManager shareFileManager] getFilePathWithPathType:PathTypeHtml] stringByAppendingPathComponent:@"简书首页"];
//    url = [basePath stringByAppendingPathComponent:@"简书 - 创作你的创作.html"];
    NSURL *baseURL = [NSURL fileURLWithPath:url];
    if (basePath) {
        baseURL = [[NSURL alloc] initFileURLWithPath:basePath];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:url]) {
        NSLog(@"url  ==== %@,/n路径不存在", url);
        return;
    }
    [self.webview loadFileURL:[[NSURL alloc] initFileURLWithPath:url] allowingReadAccessToURL:baseURL];
}

// 创建左上角按钮
- (void)creatItems {
    if (!self.autoNav) {
        return;
    }
    NSMutableArray *items = [NSMutableArray new];
    if (SYSTEM_VERSION_LESS_THAN(@"11.0")) {
        // 2.添加UIBarButtonSystemItemFixedSpace类型的item
        UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        // 2.1－－－－－重点：通过调整width值来调整间距－－－－
        leftNegativeSpacer.width = -8;
        [items addObject:leftNegativeSpacer];
    }

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [items addObject:backItem];

    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];nav_close
    [closeBtn setImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(0, 0, 44, 44);
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    [items addObject:closeItem];

    for (UIBarButtonItem *item in items) {
        item.tintColor = UIColor.blackColor;
    }

    [self.navigationItem setLeftBarButtonItems:items];
}

- (void)goBack {
    if (_webview.canGoBack) {
        [_webview goBack];
    } else {
        [self close];
    }
}

- (void)close {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupUI {
    [self.view addSubview:self.webview];
    [self.view addSubview:self.progressView];
}

#pragma mark - js交互方法

#pragma mark - WKWebView代理

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    _curURL = navigationAction.request.URL.absoluteString;
    NSLog(@"当前加载url ======== %@", _curURL);
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
//    [self creatItems];
}

/** 网页加载完毕调用 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = true;
//    [self creatItems];
    if (_isDisplayCookies) {
        NSHTTPCookie *cookie;
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [cookieJar cookies]) {
            NSLog(@"%@", cookie);
        }
    }

    if (_isDisplayHTML) {
        NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
        [webView evaluateJavaScript:jsToGetHTMLSource completionHandler:^(id _Nullable HTMLsource, NSError *_Nullable error) {
            NSLog(@"%@", HTMLsource);
        }];
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(nonnull NSError *)error {
    self.progressView.hidden = YES;
//    [self creatItems];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ?: @"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ?: @"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *_Nullable))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(alertController.textFields[0].text ?: @"");
    }])];

    [self presentViewController:alertController animated:YES completion:nil];
}

// 信任不安全的https
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, card);
    }
}

//JS调用的OC回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

}

#pragma mark - 清除cookie

- (void)removeCookies {
    if (_isRemoveCookies) {
        WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
        [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                         completionHandler:^(NSArray<WKWebsiteDataRecord *> *__nonnull records) {
                             for (WKWebsiteDataRecord *record  in records) {
                                 [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:[NSSet setWithObject:WKWebsiteDataTypeCookies]
                                                                           forDataRecords:@[record]
                                                                        completionHandler:^{
                                                                            NSLog(@"Cookies deleted successfully: %@ ", record.displayName);
                                                                        }];
                             }
                         }];
    }
}

#pragma mark - kvo判断title和进度条

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // 首先，判断是哪个路径
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        // 判断是哪个对象
        if (object == _webview) {
            if (_webview.estimatedProgress == 1.0) {
                //隐藏
                self.progressView.hidden = YES;
            } else {
                // 添加进度数值
                self.progressView.hidden = NO;
                self.progressView.progress = (float) _webview.estimatedProgress;
            }
        }
    }
    if ([keyPath isEqualToString:@"title"]) {
        // 判断是哪个对象
        if (object == _webview) {
            __weak typeof(self) weakSelf = self;
            if (_isAutoTitle) {
                self.title = _webview.title;
            }
            if (weakSelf.titleBlock) {
                weakSelf.titleBlock(_webview.title);
            }
        }
    }
}

#pragma mark - SDPhotoBrowserDelegate
//// 返回高质量图片的url
//- (NSURL *)photoBrowser:(SDPhotoBrowserd *)browser highQualityImageURLForIndex:(NSInteger)index {
//    return [NSURL URLWithString:self.imgSrcArray[index]];
//}

#pragma mark - lazy

- (WKWebView *)webview {
    if (!_webview) {
        WKWebViewConfiguration *configer = [[WKWebViewConfiguration alloc] init];
        configer.selectionGranularity = WKSelectionGranularityCharacter;
        configer.userContentController = [[WKUserContentController alloc] init];
        configer.preferences = [[WKPreferences alloc] init];
        configer.preferences.javaScriptEnabled = YES;
        configer.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        configer.allowsInlineMediaPlayback = YES;
        configer.processPool = [BaseWebViewController singleWkProcessPool];
        _webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) configuration:configer];
        _webview.backgroundColor = [UIColor whiteColor];
        _webview.allowsBackForwardNavigationGestures = true;
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
        [_webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webview;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 3);
        _progressView.progressTintColor = UIColor.redColor;
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

+ (WKProcessPool *)singleWkProcessPool {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[WKProcessPool alloc] init];
    });
    return _sharedInstance;
}

@end
