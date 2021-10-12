//
// Created by chenjg on 2020/1/3.
// Copyright (c) 2020 导医通. All rights reserved.
//

typealias CommonBlock = (_ param: Any?) -> Void

typealias BackBlock = () -> Void

var KWindow: UIWindow? {
    UIApplication.shared.keyWindow
}

var isX: Bool = {
    var x = false
    if #available(iOS 11.0, *), UIDevice.current.userInterfaceIdiom == .phone, KWindow?.safeAreaInsets.bottom ?? 0 > CGFloat(0.0) {
        x = true
    }
    return x
}()

let KScreen_Bounds = UIScreen.main.bounds
let KScreen_Size = KScreen_Bounds.size
let KScreen_Width = KScreen_Size.width
let KScreen_Height = KScreen_Size.height

let xTopMargin: CGFloat = isX ? 24 : 0
let xBottomMargin: CGFloat = isX ? 34 : 0
let KNav_Height = 64 + xTopMargin
let KTab_Height = 44 + xBottomMargin
let APPHost: String = APPConfig.sharedInstance().host.hosturl

func DLog(_ messages: Any..., file: String = #file, funcName: String = #function, lineNum: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\n文件:\(fileName) - 函数:\(funcName) - 行数:\(lineNum) - 输出:")
    for message in messages {
        if message is String, (message as! String).count > 50000 {
            print("🚫字符串过大不想输出🚫")
        } else {
            print(message)
        }
    }
    #endif
}

func getURL(_ urlStr: Any?) -> URL? {
    if let urlStr = urlStr as? String {
        return (urlStr as NSString).mj_url()
    }
    return nil
}

func scrollFixForIOS11(scrollView: UIScrollView?) {
    if #available(iOS 11.0, *) {
        scrollView?.contentInsetAdjustmentBehavior = .never
    }
}

extension CGFloat {

    static func deviceFit(_ number: CGFloat?) -> CGFloat {
        let n: CGFloat = number ?? 0
        return KScreen_Width / 375.0 * n
    }

}
