//
//  JSHandle.h
//  Base
//
//  Created by cjg on 2017/9/4.
//  Copyright © 2017年 CJG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebViewJavascriptBridge/WebViewJavascriptBridge.h>

@protocol JSHandlerDelegate;

@interface JSHandler : NSObject

@property (nonatomic, weak) WKWebView *wkWebView;

@property (nonatomic, weak) UIWebView *webView;

@property (nonatomic, strong) WebViewJavascriptBridge *jsBridge;

@property (nonatomic, weak) id <JSHandlerDelegate> delegate;

+ (instancetype)jsHandlerWithWebView:(id)webView
                            delegate:(id <JSHandlerDelegate>)delegate;

@end

#pragma mark - js交互协议

@protocol JSHandlerDelegate <NSObject>

/**
 iOS登录商城

 @param jsHandler jsHandler description
 @param data data description
 @param callBack callBack description
 */
- (void)jsHandlerIOSLoginWebViewFunctionWith:(JSHandler *)jsHandler
                                        data:(id)data
                                    callBack:(WVJBResponseCallback)callBack;

/**
 调用原生支付

 @param jsHandler jsHandler description
 @param data data description
 @param callBack callBack description
 */
- (void)jsHandlerCallNativePaymentWebViewFunctionWith:(JSHandler *)jsHandler
                                                 data:(id)data
                                             callBack:(WVJBResponseCallback)callBack;

/**
 * 调用分享
 * @param jsHandler JS
 * @param data {
    "shareType": "QQ", //WEIXIN
    "goodsId": "1045911485442297856",
    "goodsName": "时测商品挂三级未批量设置092902",
    "goodsShowPic": "http://static.uat.daoyitong.com/group1/M00/00/55/wKjcYFuvEKWAFMykAAD-wAn_de8803.png",
    "goodsUrl": "https://uat-mall.daoyitong.com/app2.0/index.html?goodsId=1045911485442297856#/goodsDetail"
}
 * @param callBack 回调
 */
- (void)jsHandlerShareFunctionWith:(JSHandler *)jsHandler
                              data:(id)data
                          callBack:(WVJBResponseCallback)callBack;


@end
