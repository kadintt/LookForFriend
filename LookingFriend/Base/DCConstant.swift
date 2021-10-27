//
// Created by chenjg on 2020/1/3.
// Copyright (c) 2020 导医通. All rights reserved.
//
import UIKit
import Foundation


typealias CommonBlock = (_ param: Any?) -> Void

typealias BackBlock = () -> Void

var KWindow: UIWindow? {
    UIApplication.shared.keyWindow
}

let KScreen_Bounds = UIScreen.main.bounds
let KScreen_Size = KScreen_Bounds.size
let KScreen_Width = KScreen_Size.width
let KScreen_Height = KScreen_Size.height

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

func gScale(_ number: CGFloat?) -> CGFloat {
    let n: CGFloat = number ?? 0
    return floor(KScreen_Width / 375.0 * n)
}

func gImage(_ imageStr: String?) -> UIImage {
    guard let imageS = imageStr else { return UIImage() }
    guard let image = UIImage(named: imageS) else { return UIImage() }
    return image
}


func scrollFixForIOS11(scrollView: UIScrollView?) {
    if #available(iOS 11.0, *) {
        scrollView?.contentInsetAdjustmentBehavior = .never
    }
}

func XNavHeight() -> CGFloat{
    return UIDevice.current.isiPhoneXMore() ? 88 : 64
}

func XTabHeight() -> CGFloat{
    return UIDevice.current.isiPhoneXMore() ? (49 + 34) : 49
}

func XTopMargin() -> CGFloat{
    return UIDevice.current.isiPhoneXMore() ? 24 : 0
}

func XBottomMargin() -> CGFloat{
    return UIDevice.current.isiPhoneXMore() ? 34 : 0
}


extension CGFloat {

    static func deviceFit(_ number: CGFloat?) -> CGFloat {
        let n: CGFloat = number ?? 0
        return KScreen_Width / 375.0 * n
    }

}
extension UIDevice {
    public func isiPhoneXMore() -> Bool {
        var isMore:Bool = false
        if #available(iOS 11.0, *) {
            isMore = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0 > 0.0
        }
        return isMore
    }
}
