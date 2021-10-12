//
//  DCRequestTool.swift
//  pavodoctor
//
//  Created by maoge on 2020/4/2.
//  Copyright © 2020 导医通. All rights reserved.
//

import UIKit

// 网络请求类型
@objc enum DCHttpMethodType:NSInteger {
    case get
    case post
    case upload
}

// 网络请求结果
@objc enum DCNetWorkFinishType: NSInteger {
    case cancel
    case success
    case failure
}

/// 编码格式
enum NetWorkEncodeType: Int {
    case json = 0
    case url = 1
    case form = 2
}

/// 网络配置闭包
typealias RequestConfigClosure = (_ tool: RequestTool) -> Void
/// 请求结果闭包
typealias RequestFinishClosure = (_ tool: RequestTool, _ error: Error?, _ finishType: DCNetWorkFinishType) -> Void
/// 请求头配置闭包
typealias RequestHeaderClosure = (_ tool: RequestTool) -> Dictionary<String, String>

@objcMembers class RequestTool: NSObject {
    var url: String?
    /// 主域名
    var hostString: String?
    /// 请求方式
    var method: DCHttpMethodType?
    /// 设置Post请求参数Body
    var body: Any? {
        didSet {
            body = configBody(body)
        }
    }

    var headerClosure: RequestHeaderClosure?
    var responseSerializer: AFHTTPResponseSerializer?

    /// 拼接URL后面的参数, 可以传String类型, String直接拼接
    var queryParams: Any?
    /// json解析类, nil不解析
    var classes: BaseModel.Type?
    /// body序列化方式, 默认json
    var encodeType: NetWorkEncodeType = .json
    /// 返回序列化完成后的model
    var netModel: BaseModel?
    /// 返回的json字符串
    var json: String?
    /// 返回的原始数据
    var responseObject: Any?
    /// 是否请求成功
    var isSuccess: Bool?

    static let shared = RequestTool()

    private var globalConfig: RequestConfigClosure?
    private var finishClosure: RequestFinishClosure?
    private var upProgress: ((_ progress: Int) -> Void)?

    fileprivate static func initWithParam(url: String?, method: DCHttpMethodType, body: Any?, classes: BaseModel.Type?) -> RequestTool {
        let tool = RequestTool()
        tool.url = url
        tool.method = method
        tool.body = body
        tool.classes = classes
        return tool
    }

    private lazy var manager: AFHTTPSessionManager = {
        let manager = AFHTTPSessionManager()

        manager.responseSerializer = RequestTool.shared.responseSerializer ?? AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json", "text/html", "text/json", "text/javascript", "text/plain") as? Set<String>

        let policy = AFSecurityPolicy(pinningMode: .none)
        policy.allowInvalidCertificates = true
        policy.validatesDomainName = false
        manager.securityPolicy = policy

        return manager
    }()
}

// MARK: - 主要的网络请求方法

extension RequestTool {
    /// 配置并记录host相关信息
    static func configGlobalHost(_ hostString: String?, _ header: RequestHeaderClosure?, _ globalConfig: RequestConfigClosure?, _ responseSerializer: AFHTTPResponseSerializer?) {
        RequestTool.shared.hostString = hostString
        RequestTool.shared.headerClosure = header
        RequestTool.shared.globalConfig = globalConfig
        RequestTool.shared.responseSerializer = responseSerializer ?? AFJSONResponseSerializer()
    }

    /// 主要的请求方法
    /// - Parameters:
    ///   - url: URL字符串
    ///   - method: 调用方法
    ///   - queryParams: 拼接URL后面的参数
    ///   - body: Body体
    ///   - classes: 需要模型化的类
    ///   - config: 配置闭包
    ///   - finish: 完成回调闭包
    @discardableResult static func requestWithURL(_ url: String?,
                                                  _ method: DCHttpMethodType,
                                                  _ queryParams: Any?,
                                                  _ body: Any?,
                                                  _ classes: BaseModel.Type?,
                                                  _ config: RequestConfigClosure?,
                                                  _ finish: @escaping RequestFinishClosure) -> RequestTool {
        let tool = initWithParam(url: url, method: method, body: method == .get ? nil : body, classes: classes)
        tool.queryParams = queryParams
        tool.finishClosure = finish
        if config != nil {
            config?(tool)
        }

        // 配置header与host
        if RequestTool.shared.globalConfig != nil {
            RequestTool.shared.globalConfig?(tool)
        }

        tool.httpRequest()
        
        
        return tool
    }

    /// get请求
    @discardableResult static func get(url: String?, queryParams: Any?, classes: BaseModel.Type?, config: RequestConfigClosure?, finish: @escaping RequestFinishClosure) -> RequestTool {
        return requestWithURL(url, .get, queryParams, nil, classes, config, finish)
    }

    /// post请求
    @discardableResult static func post(url: String?, body: Any?, classes: BaseModel.Type?, config: RequestConfigClosure?, finish: @escaping RequestFinishClosure) -> RequestTool {
        return requestWithURL(url, .post, nil, body, classes, config, finish)
    }

    fileprivate func httpRequest() {
        let request = NSMutableURLRequest()

        request.httpBody = body as? Data
        request.httpMethod = method == .get ? "GET" : "POST"
        request.url = NSURL(string: getFullURL()) as URL?
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 15
        
        startRequest(request: request)
    }

//    fileprivate func uploadRequest(_ models: [UploadModel]?, _ params: [String: Any]?) {
//        let requestSerializer = AFHTTPRequestSerializer()
//        let uploadRequest = requestSerializer.multipartFormRequest(withMethod: "POST", urlString: getFullURL(), parameters: params, constructingBodyWith: { formData in
//            models?.forEach({ model in
//                model.add(to: formData)
//            })
//        }, error: nil)
//
//        startRequest(request: uploadRequest)
//    }

    fileprivate func startRequest(request: NSMutableURLRequest) {

        if encodeType == .json {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let header = getRequestHeader()
        header?.keys.forEach({ key in
            request.setValue(header?[key], forHTTPHeaderField: key)
        })

        manager.dataTask(with: request as URLRequest, uploadProgress: { progress in
            self.upProgress?(Int(progress.completedUnitCount / progress.totalUnitCount))
        }, downloadProgress: nil) { response, responseObj, error in

            // 请求失败
            if error != nil {
                self.isSuccess = false
                self.responseObject = responseObj

                DLog("\n********************************\n",
                     "请求失败",
                     "请求方式", self.method == .get ? "GET" : "POST",
                     "请求地址", response.url ?? "",
                     "请求头", self.getRequestHeader() ?? "",
                     "请求体", NSString(data: self.body as? Data ?? Data(), encoding: String.Encoding.utf8.rawValue) ?? "",
                     "错误Error", error as Any,
                     "\n********************************")

                self.finishClosure?(self, error, .failure)
                // 请求成功
            } else {
                // 字典转模型
                if self.classes != nil {
                    let obj = (self.classes ?? BaseModel.self).init()
                    self.netModel = obj.mj_setKeyValues(responseObj)
                }

                self.isSuccess = true
                self.responseObject = responseObj
                
                DLog("\n********************************\n",
                "请求成功",
                "请求方式", self.method == .get ? "GET" : "POST",
                "请求地址", response.url ?? "",
                "请求头", self.getRequestHeader() ?? "",
                "请求体", NSString(data: self.body as? Data ?? Data(), encoding: String.Encoding.utf8.rawValue) ?? "",
                "响应体", (self.responseObject as? NSObject)?.mj_JSONString() ?? "",
                "\n********************************")
                if self.netModel?.code.elementsEqual("4") ?? false {
                    DYTHUDTool.showWDToast(self.netModel?.message)
                    return
                }
                self.finishClosure?(self, nil, .success)
            }

        }.resume()
    }
}

extension RequestTool {
    /// 获取完整URL
    func getFullURL() -> String {
        var fullUrl = ""
        if url?.hasPrefix("http") ?? false {
            fullUrl = url ?? ""
        } else {
            let hostStr = (hostString != nil) ? hostString : RequestTool.shared.hostString
            fullUrl = (hostStr ?? "") + (url ?? "")
        }

        if queryParams is NSString || queryParams is String {
            fullUrl = fullUrl + "?" + (queryParams as? String ?? "")
        } else {
            if (queryParams as? Dictionary<AnyHashable, Any>)?.count ?? 0 > 0 {
                fullUrl = (fullUrl as NSString).addParameters(queryParams as? [AnyHashable: Any])
            }
        }
        return fullUrl
    }

    /// 获取header
    fileprivate func getRequestHeader() -> [String: String]? {
        if headerClosure != nil {
            return headerClosure?(self)
        } else if RequestTool.shared.headerClosure != nil {
            return RequestTool.shared.headerClosure?(self)
        }
        return nil
    }

    /// /// 获取格式化query后的参数, ?后的参数
    func formatQueryParams() -> String {
        if getFullURL().contains("?") {
            return getFullURL().components(separatedBy: "?").last ?? ""
        }
        return ""
    }
}
