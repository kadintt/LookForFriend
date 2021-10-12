//
//  DCDataManager.swift
//  pavodoctor
//
//  Created by maoge on 2020/4/1.
//  Copyright © 2020 导医通. All rights reserved.
//

import UIKit

let KDCDataManager = DCDataManager.shared

@objcMembers class DCDataManager: NSObject {
    @objc static let shared = DCDataManager()
    
    @objc var topBaseViewController:DCViewController = DCViewController()
    
    var user: BaseModel? {
        didSet {
            _ = saveCache(user, key: FileName.user)
        }
    }

    var sessionId: String? {
        didSet {
            UserDefaults.standard.set(sessionId, forKey: "sessionId")
        }
    }

    /// 快速获取手机号
//    var phoneNum: String { user?.docTel ?? "" }

    @objc let fileManager: APPFileManager = APPFileManager.sharedInstance()

    override init() {
        super.init()
        DLog("user------>\(String(describing: user))")
        sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
    }
}

// MARK: - API-Cache

extension DCDataManager {
    /// 存储数据
    open func saveCache(_ obj: Any?, key: DCDataManager.FileName) -> Bool {
        return fileManager.saveJson(obj, fileName: key.rawValue)
    }

    /// 获取数据
    open func getCache(_ key: DCDataManager.FileName) -> String {
        return fileManager.getJsonWithFileName(key.rawValue) ?? ""
    }
}

extension DCDataManager {
    var isLogin: Bool {
//        user?.isOnline ?? false
        false
    }

    /// 验证是否登陆
    @discardableResult open func checkLogin(_ success: @escaping () -> Void = {}) -> Bool {
        if isLogin {
            success()
        } else {
            oneLogin(success)
        }
        return false
//        return user?.isOnline ?? false
    }
    
    
    private func oneLogin(_ success: @escaping () -> Void = {}) {
        
    }
    
        
    func goNewLoginBlock(_ success: @escaping () -> Void = {}) {
//        let login = DCLoginController()
//        login.phoneShowType = .login
//        login.loginSuccessBlock = success
//        let loginNav = DCBaseNavController(rootViewController: login) as DCBaseNavController
//        loginNav.modalPresentationStyle = .fullScreen
//        KApp.window?.rootViewController?.present(loginNav, animated: false, completion: nil)
    }
    
    /// 判断是否是药师
    open func checkAccountType() -> Bool {
        if isLogin {
//            if DCDataManager.shared.user?.roleType.elementsEqual("2") ?? false {
//                let vc = DCPharmacistReviewController()
//                vc.modalPresentationStyle = .fullScreen
//                let loginNav = DCBaseNavController(rootViewController: vc) as DCBaseNavController
//                loginNav.modalPresentationStyle = .fullScreen
//                KApp.window?.rootViewController?.present(loginNav, animated: false)
//                return true
//            }
        }
        return false
    }

    /// 退出登陆
    open func logout() {
        // todo 本地接口登出操作
        user = nil
        sessionId = nil
        guard let tab = KApp.window?.rootViewController as? UITabBarController else { return }
        guard let nav = tab.selectedViewController as? UINavigationController else { return }
        nav.popToRootViewController(animated: false)
        tab.selectedIndex = 0
        DLog("topBaseViewController \(topBaseViewController)")
        
        oneLogin {
            
        }
    }
}

// MARK: - 文件名Key

extension DCDataManager {
    class FileName {
        var rawValue: String

        init(_ rawValue: String) {
            self.rawValue = rawValue
        }

        static let user = FileName("DCDataManager.FileName.user")
        static let host = FileName("host-environment")
        static let isSecret = FileName("isSecretAPI")
        static let voice = FileName("voiceReadDict")
    }
}
