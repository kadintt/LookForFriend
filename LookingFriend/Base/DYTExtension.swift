//
//  DYTExtension.swift
//  pavodoctor
//
//  Created by 曲超 on 2020/12/4.
//  Copyright © 2020 导医通. All rights reserved.
//

import UIKit


protocol DYTCompatible {}
typealias pwdSuccess = (()->())
extension DYTCompatible {
    static var dyt:DYT<Self>.Type {
        get {DYT<Self>.self}
        set {}
    }
    var dyt:DYT<Self> {
        get {DYT(self)}
        set {}
    }
    
}

/// 利用协议 实现前缀效果
struct DYT<Base> {
    let base:Base
    init(_ base:Base) {
        self.base = base
    }
}

/// 如果想给某些类 增加一些方法 那么 只需要让那个类 遵守dyt 前缀协议 然后 在 DYT 的分类里 进行处理
/// 例：给string 类型 增加一个 方法 查看字符串中的 数字个数
extension String: DYTCompatible{}
extension NSString: DYTCompatible{}

/// 只有遵守 ExpressibleByStringLiteral 协议的 才能调用该分类中的方法
extension DYT where Base: ExpressibleByStringLiteral {
    func numberCount() -> Int {
        let string = base as! String
        var count = 0
        for c in string where ("0"..."9").contains(c)  {
            count += 1
        }
        return count
    }

//    func test() {
//        ///示例
//        let str = "123_sdjakj_2133"
//        print(str.dyt.numberCount())
//    }
    // 1, 截取规定下标之后的字符串
    // "Hello World".subStringFrom(index: 3)      // "lo World"
    func subStringFrom(index: Int) -> String {
        let temporaryString: String = base as! String
        let temporaryIndex = temporaryString.index(temporaryString.startIndex, offsetBy: 3)
        return String(temporaryString[temporaryIndex...])
    }

    // 2, 截取规定下标之前的字符串
    // "Hello World".subStringTo(index: 3)            //"Hell"
    func subStringTo(index: Int) -> String {
        let temporaryString = base as! String
        let temporaryIndex = temporaryString.index(temporaryString.startIndex, offsetBy: index)
        return String(temporaryString[...temporaryIndex])
    }
    
    /// json 转字典
    func getDictionaryFromJSONString() ->NSDictionary{
        let baseStr = base as! String
        let jsonData:Data = baseStr.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    /// 计算文字尺寸
    func sizeWithText(font: UIFont, _ limitSize: CGSize?) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let baseStr = base as! String
        let rect: CGRect = baseStr.boundingRect(with: limitSize ?? baseStr.size(withAttributes: attributes), options: option, attributes: attributes, context: nil)

        return CGSize(width: CGFloat(ceil(Float(rect.size.width))), height: CGFloat(ceil(Float(rect.size.height))))
    }
    
    /// 将 新子串 插入到指定的子串前后  默认为指定的子串后
    func insert(keyStr:String?, byTail:Bool = true, needInsertStr:String?) -> String{
        let baseStr = base as! String
        /// 如果指定子串为空 则 直接将子串插入到最后
        guard let keyS:String =  keyStr else {return baseStr + (needInsertStr ?? "")}
        var tempStr = baseStr
        /// 如果指定子串不在 当前字符串中 则直接将子串插入到最后
        guard let range = tempStr.range(of: keyS) else { return tempStr + (needInsertStr ?? "") }
        /// 获取到指定子串的location
        let location = tempStr.distance(from: baseStr.startIndex, to:range.lowerBound)
        /// 获取插入新子串的 index
        let index = tempStr.index(tempStr.startIndex, offsetBy: (location + (byTail ? keyS.count : 0)))
        tempStr.insert(contentsOf: (needInsertStr ?? ""), at: index)
        return tempStr
    }
    
    /// 拆分url 场景：后台返回全路径 请求时 参数多加密的情况 该方法 返回元组 0：url 1：参数
    func breakUrl() -> (String?,[String : String]){
        let tempStr = base as! String
        if !tempStr.contains("?"){return (tempStr,[:])}
        var dic:[String:String] = [:]
        let str = NSString(format: "%@", tempStr)
        let urlArr = str.components(separatedBy: "?")
        let keyValueStr = urlArr.last ?? ""
        let urlHeadStr = urlArr.first
        for keyV in keyValueStr.components(separatedBy: "&") {
            let arr = keyV.components(separatedBy: "=")
            let key = arr.first ?? ""
            let value = arr.last ?? ""
            dic[key] = value
        }
        return (urlHeadStr,dic)
    }
    /// 组合参数
    static func combinationParam(params:[String:String]) -> String{
        var result = ""
        var arr:[String] = []
        for key in params.keys {
            let str = key + "=" + (params[key] ?? "")
            arr.append(str)
        }
        result = arr.joined(separator: "&")
        return result
    }
    
    static func timeIntervalChangeToTimeStr(timeInterval:Double, _ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
        let date:Date = Date.init(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter.init()
        if dateFormat == nil {
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            formatter.dateFormat = dateFormat
        }
        return formatter.string(from: date as Date)
    }
    //MARK:- 字符串转时间戳
    func timeStrChangeTotimeInterval(_ dateFormat:String? = "yyyy-MM-dd HH:mm:ss") -> String {
        
        let str = base as! String
        
        if str.isEmpty {
            return ""
        }
        let format = DateFormatter.init()
        format.dateStyle = .medium
        format.timeStyle = .short
        if dateFormat == nil {
            format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else{
            format.dateFormat = dateFormat
        }
        let date = format.date(from: str)
        return String(date!.timeIntervalSince1970)
    }
}

extension UILabel:DYTCompatible{}

extension DYT where Base:UILabel {
    func touchAt(_ point: CGPoint) -> CFIndex {
        
        let lab = base as UILabel

        var idx = -1
        
        var p = point
        
        // 初始化framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(lab.attributedText!)
        
        // 创建path
        let path = CGMutablePath()
        path.addRect(lab.bounds)
        
        // 绘制frame
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        // 获得CTLine数组
        let lines = CTFrameGetLines(frame)
        
        // 获得CTLine数组
        let numberOfLines = CFArrayGetCount(lines)
        
        // 获取每一行的origin
        var origins = [CGPoint](repeating: CGPoint(x: 0, y: 0), count: numberOfLines)
        CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), &origins)
        
        for i in 0..<numberOfLines {
            // 获取对应行的origin
            let origin = origins[i]
            // 获取每一行
            let line = CFArrayGetValueAtIndex(lines, i)
            let lineRef = unsafeBitCast(line, to: CTLine.self)
            
            
            // 获取每行的rect
            var ascent: CGFloat = 0.0, descent: CGFloat = 0.0, leading: CGFloat = 0.0
            let w = CGFloat(CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading))
            
            
            // 计算每行相对于label的y和maxy
            let style = lab.attributedText?.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: nil)
            
            var lineSpace : CGFloat = 0.0
            
            if (style != nil) {
                lineSpace = (style as! NSParagraphStyle).lineSpacing
            }
            let lineH = ascent + abs(descent) + leading
            let textH = lineH * CGFloat(numberOfLines) + lineSpace * CGFloat(numberOfLines - 1)
            let textY = (lab.bounds.height - textH) * 0.5
            let lineY = textY + CGFloat(i) * (lineH + lineSpace)
            let maxY: CGFloat = lineY + lineH
            
            if p.y > maxY {
                break // 点击位置不在行中
            }
            
            if p.y >= lineY {
                p = CGPoint(x: p.x, y: maxY - p.y)
                if p.x >= origin.x && point.x < w + origin.x {
                    // 点击点相对行origin的位置
                    let relativePoint = CGPoint(x: p.x - origin.x, y: 0)
                    idx = CTLineGetStringIndexForPosition(lineRef, relativePoint)
                    
                    break
                }
            }
            
        }
        return idx
    }
}


extension UIViewController:DYTCompatible{}

extension DYT where Base:UIViewController {
    /// 获取医生信息
    func getDocInfo(userName:String,roleType:String) {
        let vc = base as UIViewController
        
        
    }
    
    func getPharmacistReviewDocInfo(userName:String,roleType:String) {
        let vc = base as UIViewController

    }
    
    func logout() {
  
    }
    

}

