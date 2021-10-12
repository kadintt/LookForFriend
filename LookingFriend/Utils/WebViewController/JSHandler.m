//
//  JSHandle.m
//  Base
//
//  Created by cjg on 2017/9/4.
//  Copyright © 2017年 CJG. All rights reserved.
//

#import "JSHandler.h"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#define DLog(...)
#endif

@implementation JSHandler

+ (instancetype)jsHandlerWithWebView:(id)webView delegate:(id<JSHandlerDelegate>)delegate {
    JSHandler *handler = [[JSHandler alloc] init];
    if ([webView isKindOfClass:[UIWebView class]]) {
        handler.webView = webView;
    }
    if ([webView isKindOfClass:[WKWebView class]]) {
        handler.wkWebView = webView;
    }
    handler.delegate = delegate;
    handler.jsBridge = [WebViewJavascriptBridge bridgeForWebView:webView];
    [handler.jsBridge setWebViewDelegate:delegate];
    [handler addFunctions:handler.jsBridge];
    return handler;
}

- (void)addFunctions:(WebViewJavascriptBridge *)bridge {
    __weak typeof(self) weakSelf = self;
    [bridge registerHandler:@"jsCallAppLogin" handler:^(id data, WVJBResponseCallback responseCallback) {
        DLog(@"\nh5调用了jsCallAppLogin方法\n")
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(jsHandlerIOSLoginWebViewFunctionWith:data:callBack:)]) {
            DLog(@"\n对象 === %@,\n接收了jsCallAppLogin方法\n", weakSelf.delegate);
            [weakSelf.delegate jsHandlerIOSLoginWebViewFunctionWith:weakSelf data:data callBack:responseCallback];
        }
    }];
    [bridge registerHandler:@"pay" handler:^(id data, WVJBResponseCallback responseCallback) {
        DLog(@"\nh5调用了pay方法\n")
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(jsHandlerCallNativePaymentWebViewFunctionWith:data:callBack:)]) {
            DLog(@"\n对象 === %@,\n接收了pay方法\n", weakSelf.delegate);
            [weakSelf.delegate jsHandlerCallNativePaymentWebViewFunctionWith:weakSelf data:data callBack:responseCallback];
        }
    }];
    [bridge registerHandler:@"jsCallAppShare" handler:^(id data, WVJBResponseCallback responseCallback) {
        DLog(@"\nh5调用了jsCallAppShare方法\n")
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(jsHandlerShareFunctionWith:data:callBack:)]) {
            DLog(@"\n对象 === %@,\n接收了jsCallAppShare方法\n", weakSelf.delegate);
            [weakSelf.delegate jsHandlerShareFunctionWith:weakSelf data:data callBack:responseCallback];
        }
    }];

}

@end
