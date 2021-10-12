//
//  AppDelegate.swift
//  LookingFriend
//
//  Created by 曲超 on 2021/9/15.
//

import UIKit


let KApp: AppDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static let shared: AppDelegate = UIApplication.shared.delegate as! AppDelegate

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let tab = DCMainTabController()
        window?.rootViewController = tab
        window?.makeKeyAndVisible()

//        configHost()
//        configKeyBoard()
//        configIM()
//        configNotificaiton()
//        checkAppUpdate()
//        configAutoLogin()
        
        return true
    }
}

extension AppDelegate {
    /// 配置网络
    fileprivate func configHost() {
//        RequestTool.configGlobalHost(NetConstant.host, { (_) -> Dictionary<String, String> in
//            [
//                "deviceType": "IOS",
//                "version": APPConfig.sharedInstance().dyt_ProductVersion,
//                "userId": DCDataManager.shared.user?.docId ?? "",
//                "sessionId": DCDataManager.shared.sessionId ?? "",
//            ]
//        }, { tool in
//            if APPConfig.sharedInstance().isSecretAPI,
//                tool.encodeType != .form,
//                tool.getFullURL().contains(NetConstant.host) == true {
//                let paramStr = tool.formatQueryParams()
//                if paramStr.count > 0 {
//                    tool.queryParams = DES3Util.encryptHex(paramStr)
//                }
//
//                if let bodyStr = String(data: tool.body as? Data ?? Data(), encoding: .utf8), bodyStr.count > 0 {
//                    tool.body = DES3Util.encryptHex(bodyStr)
//                }
//            }
//
//        }, DYTHTTPResponseSerializer())
    }

    /// 配置键盘`
    fileprivate func configKeyBoard() {
//        IQKeyboardManager.shared().isEnabled = true
//
//        func disables(vc: UIViewController.Type) {
//            IQKeyboardManager.shared().disabledToolbarClasses.add(vc)
//            IQKeyboardManager.shared().disabledDistanceHandlingClasses.add(vc)
//            IQKeyboardManager.shared().disabledTouchResignedClasses.add(vc)
//        }
//
//        disables(vc: BaseChatViewController.self)
//        disables(vc: BaseGroupChatController.self)
//        disables(vc: DCPersonCenterController.self)
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    

    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    // iOS10 App位于后台, 点击推送消息时处理推送消息
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    /// 获取到deviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
    
    /// 失败回调
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error);
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0;
    }
}
