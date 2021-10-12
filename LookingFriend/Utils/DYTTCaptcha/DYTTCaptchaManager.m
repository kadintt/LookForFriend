//
//  DYTTCaptchaManager.m
//
//
//  Created by 曲超 on 2020/12/11.
//

#import "DYTTCaptchaManager.h"

#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>

@interface DYTTCaptchaManager ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) AuthCompleteBlock block;
@property (nonatomic, strong) UIView *maskView;
@end

@implementation DYTTCaptchaManager

static DYTTCaptchaManager *tcaptchaManager;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tcaptchaManager = [[self alloc] init];
    });
    return tcaptchaManager;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
       tcaptchaManager = [super allocWithZone:zone];
   });
   return tcaptchaManager;
}
 
- (id)copyWithZone:(NSZone *)zone {
   return tcaptchaManager;
}

-(WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
        config.allowsInlineMediaPlayback = YES;//可以禁止弹出全屏  网页video标签要加 上playsinline 这个属性
        WKUserContentController* uc = [[WKUserContentController alloc] init];
        config.userContentController = uc;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 261, 261) configuration:config];
        _webView.backgroundColor = [UIColor whiteColor];
        // 设置代理
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        //开启手势触摸
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.autoresizingMask = YES;
        //适应你设定的尺寸
        [_webView sizeToFit];
    }
    return _webView;
}

-(void)deallocWkWebView{
    [UIView animateWithDuration:0.25 animations:^{
        self.webView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.webView removeFromSuperview];
        WKUserContentController *controller = self.webView.configuration.userContentController;
        [controller removeScriptMessageHandlerForName:@"afterShowBack"];
        [controller removeScriptMessageHandlerForName:@"afterAuthResponse"];
        self.webView = nil;
    }];
}

-(void)afterShowBack:(NSDictionary *)res{
    NSDictionary *sdkView = res[@"sdkView"];
    if (sdkView) {
        CGFloat height = [sdkView[@"height"] floatValue];
        CGFloat width = [sdkView[@"width"] floatValue];
        CGSize superSize = _contentView.frame.size;
        [UIView animateWithDuration:0.25 animations:^{
            self.webView.frame = CGRectMake((superSize.width-width)/2.0, (superSize.height-height)/2.0, width, height);
        }];
    }
}

-(void)afterAuthResponse:(NSDictionary *)res{
    if (!res)return;
    if (self.block) {
        self.block(res);
    }
    [self deallocWkWebView];
}

-(void)showTCaptchaInView:(UIView *)view
                    block:(AuthCompleteBlock)block{
    
    NSAssert(view, @"请传入验证码要显示的父视图");
    self.appId = @"2099788396";
    self.contentView = view;
    self.block = block;
    [self showTCaptcha];
}

-(void)showTCaptcha{
    
    WKUserContentController *controller = self.webView.configuration.userContentController;
    [controller addScriptMessageHandler:self name:@"afterShowBack"];
    [controller addScriptMessageHandler:self name:@"afterAuthResponse"];
    CGSize superSize = _contentView.frame.size;
    self.webView.frame = CGRectMake((superSize.width-100)/2.0, (superSize.height-100)/2.0, 100, 100);
    self.webView.hidden = YES;
    [self.contentView addSubview:self.maskView];
    self.maskView.frame = self.contentView.frame;
    [self.contentView addSubview:self.webView];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index_auth" ofType:@"html"];
    NSURL *baseUrl = [[NSBundle mainBundle] bundleURL];
    NSString *indexContent = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:indexContent baseURL:baseUrl];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.webView.hidden = NO;
    }];
    
}

#pragma mark ================ WKNavigationDelegate ================

//这个是网页加载完成，导航的变化
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    /*
     主意：这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用），，否则不显示，或则部分显示时这个方法就不调用。
     */
    // 判断是否需要加载（仅在第一次加载）
}

//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    NSLog(@"-----开始加载");
}

//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    NSLog(@"-----加载完毕");
    
}

//服务器请求跳转的时候调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
    
}

//服务器开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载超时");
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *_Nullable))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
}

//进度条
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
}

#pragma mark ================ WKUIDelegate ================

// 获取js 里面的提示
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
}

// js 信息的交流
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
   
}

// 交互。可输入的文本。
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
}


#pragma mark ================ WKScriptMessageHandler ================

//拦截执行网页中的JS方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    //服务器固定格式写法 window.webkit.messageHandlers.名字.postMessage(内容);
    //客户端写法 message.name isEqualToString:@"名字"]
    NSLog(@"%@---%@-----%@", message.name,message.body,message.frameInfo);
    NSString *funName = message.name;
    if ([message.body isKindOfClass:[NSDictionary class]]) {
        funName = [funName stringByAppendingString:@":"];
    }
    /*
     SEL funSel = NSSelectorFromString(funName);
     IMP imp = [self methodForSelector:funSel];
     void (*func)(id, SEL) = (void *)imp;
     func(self, funSel);
     */
    SEL funSel = NSSelectorFromString(funName);
    IMP imp = [self methodForSelector:funSel];
    void (*func)(id, SEL, NSDictionary *) = (void *)imp;
    func(self, funSel, message.body);
    
//    if ([self respondsToSelector:funSel]) {
//        [self performSelector:funSel withObject:message.body];
//    }
}
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]init];
        _maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap)];
        [_maskView addGestureRecognizer:viewTap];
    }
    return _maskView;
}

- (void)viewTap {
    [self deallocWkWebView];
}
@end
