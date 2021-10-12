//
// Created by maoge on 2020/3/26.
// Copyright (c) 2020 导医通. All rights reserved.
//

@objcMembers class DCWebViewController: BaseWebViewController {

    var jsHandler:JSHandler?
    
    override init!(url URL: String!) {
        super.init(url: URL)

        self.isRemoveCookies = true;
        self.isAutoTitle = false;
        self.isDisplayHTML = false;
        self.isDisplayCookies = false;
    }
    
  
    override func viewDidLoad() {
        
        setScriptOnJS()
        setCustumUserAgent()
        jsHandler = JSHandler.init(webView: self.webview, delegate: self)
        super.viewDidLoad()
    }
    
    func loadLocalPdf(pdfStr:String) {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}

// MARK: - 配置相关信息
extension DCWebViewController {
    
    /// 配置平台信息及token
    override func configRequest(_ url: String!) -> NSMutableURLRequest! {
        (url as NSString).addParameters(["appType":"ios"])
        
        let request = super.configRequest(url)
//        request?.addValue("access_token", forHTTPHeaderField: DCDataManager.shared.user?.pavoid ?? "")
        return request
    }
    
    /// 注入相关JS代码
    fileprivate func setScriptOnJS() {
        /// 注入cookie及token
        let localJS = String(format: "localStorage.setItem('userInfo', '%@');", DCDataManager.shared.user?.toJsonString() ?? "")
        let localScript = WKUserScript.init(source: localJS, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: true)
        webview.configuration.userContentController.addUserScript(localScript)
        
        /// 注入禁止长按和选择JS
        let noTouchJS = "document.documentElement.style.webkitTouchCallout='none';document.documentElement.style.webkitUserSelect='none';"
        let noneSelectScript = WKUserScript.init(source: noTouchJS, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)
        webview.configuration.userContentController.addUserScript(noneSelectScript)
    }
    
    /// 设置localStorage及Cookie
    fileprivate func saveUserLocalStorage() {
        if DCDataManager.shared.isLogin {
            let jsLocalStorage = String(format: "localStorage.setItem('userInfo', '%@')", DCDataManager.shared.user?.toJsonString() ?? "")
//            let jsCookie = String(format: "document.cookie = 'access_token=%@'", DCDataManager.shared.user?.sessionId ?? "")
            
            webview.evaluateJavaScript(jsLocalStorage, completionHandler: nil)
//            webview.evaluateJavaScript(jsCookie, completionHandler: nil)
        }else {
            webview.evaluateJavaScript("localStorage.setItem('userInfo', '')", completionHandler: nil)
        }
    }

    /// 设置自定义的UserAngent
    fileprivate func setCustumUserAgent() {
        let customUserAgent = "daoyitong/ios"
        
        if #available(iOS 12.0, *) {
            //由于iOS12的UserAgent改为异步，所以不管在js还是客户端第一次加载都获取不到，所以此时需要先设置好再去获取
            let baseAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15F79"
            let urserAgents = baseAgent + customUserAgent
            webview.customUserAgent = urserAgents
        }
        /// 自定义UA
        webview.evaluateJavaScript("navigator.userAgent") {[weak self] (result, error) in
            let userAgent = result as? String
            var newUserAgent = ""
            
            if userAgent?.contains(customUserAgent) ?? false {
                newUserAgent = (userAgent ?? "") + customUserAgent
            }else {
                newUserAgent = userAgent ?? ""
            }
            
            let dict:[String : Any] = ["UserAgent" : newUserAgent]
            
            UserDefaults.standard.register(defaults: dict)
            UserDefaults.standard.synchronize()
            
            if #available(iOS 9.0, *) {
                self?.webview.customUserAgent = newUserAgent
            }else {
                self?.webview.setValue(newUserAgent, forKey: "applicationNameForUserAgent")
            }
        }
    }
    
}


// MARK: - JS交互
extension DCWebViewController: JSHandlerDelegate {
    /// web唤起app登录
    func jsHandlerIOSLoginWebViewFunction(with jsHandler: JSHandler!, data: Any!, callBack: WVJBResponseCallback!) {
        DCDataManager.shared.checkLogin { [weak self] in
            self?.saveUserLocalStorage()
            callBack?(DCDataManager.shared.user?.toJson())
        }
    }
    /// 支付
    func jsHandlerCallNativePaymentWebViewFunction(with jsHandler: JSHandler!, data: Any!, callBack: WVJBResponseCallback!) {
        
    }
    /// 分享
    func jsHandlerShareFunction(with jsHandler: JSHandler!, data: Any!, callBack: WVJBResponseCallback!) {
        
    }
    
    
}
