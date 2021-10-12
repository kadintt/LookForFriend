//
// Created by maoge on 2020/3/23.
// Copyright (c) 2020 导医通. All rights reserved.
//

extension String {
    var unsafePointer: UnsafeRawPointer! {
        UnsafeRawPointer(bitPattern: hashValue)
    }

    /**
     * 计算字符串长度 UIFont必传, size可传可不传
     */
    public func sizeWithText(font: UIFont, _ limitSize: CGSize?) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect: CGRect = self.boundingRect(with: limitSize ?? self.size(withAttributes: attributes), options: option, attributes: attributes, context: nil)

        return CGSize(width: CGFloat(ceil(Float(rect.size.width))), height: CGFloat(ceil(Float(rect.size.height))))
    }
    
    public func sizeWithLimitHeight(font: UIFont, _ limitWidth: CGFloat) -> CGSize {
        self.sizeWithText(font: font, CGSize(width: limitWidth, height: CGFloat(MAXFLOAT)))
    }
}


extension String {
    var bool: Bool? {
        switch self.lowercased() {
        case "true", "t", "yes", "y", "1":
            return true
        case "false", "f", "no", "n", "0":
            return false
        default:
            return nil
        }
    }
    public func getDictionaryFromJSONString() ->NSDictionary{
     
        let jsonData:Data = self.data(using: .utf8)!
     
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
    
    func getArrayFromJSONString() ->NSArray{
         
        let jsonData:Data = self.data(using: .utf8)!
         
        let array = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if array != nil {
            return array as! NSArray
        }
        return array as! NSArray
         
    }
    
    //MARK: -时间戳转时间函数
    func timeStampToString(format:String)->String {
        //时间戳为毫秒级要 ／ 1000， 秒就不用除1000，参数带没带000
        let timeSta:TimeInterval = TimeInterval((Int(self) ?? 0) / 1000)
        let date = NSDate(timeIntervalSince1970: timeSta)
        let dfmatter = DateFormatter()
        //yyyy-MM-dd HH:mm:ss
        dfmatter.dateFormat  = format
        return dfmatter.string(from: date as Date)
    }
    
    func doublePrice() -> String {
        return String(format: "¥%.2f", (Double(self) ?? 0.0))
    }
}
