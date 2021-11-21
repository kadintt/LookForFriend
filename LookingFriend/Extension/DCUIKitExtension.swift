//
//  DCUIKitExtension.swift
//  pavodoctor
//
//  Created by maoge on 2020/4/9.
//  Copyright © 2020 导医通. All rights reserved.
//

import Foundation

extension UIView {
    public func gradientLayer() {
        let layer = CALayer()
        layer.frame = self.bounds
        layer.backgroundColor = UIColor(red: 0.29, green: 0.32, blue: 0.36, alpha: 1).cgColor
        self.layer.addSublayer(layer)
        // gradientCode
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.99, green: 0.13, blue: 0.26, alpha: 1).cgColor, UIColor(red: 1, green: 0.58, blue: 0.03, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = self.bounds
        self.layer.addSublayer(gradient1)
        self.layer.cornerRadius = self.size.height/2;
        
    }
}

extension UILabel {
    /// 快速创建lab
    ///
    /// - Parameters:
    ///   - text: text description
    ///   - font: font description
    ///   - textAlignment: textAlignment description
    ///   - color: color description
    ///   - backgroundColor: backgroundColor description
    ///   - circle: circle description
    /// - Returns: return value description
    @objc class func quickLabel(_ text: String? = nil,
                                font: UIFont = APPFont.regular(size: 16),
                                textAlignment: NSTextAlignment = .left,
                                color: UIColor = UIColor.dyt_title,
                                backgroundColor: UIColor = UIColor.clear,
                                circle: CGFloat = 0
    ) -> UILabel {
        let x = UILabel()
        x.text = text
        x.font = font
        x.textAlignment = textAlignment
        x.backgroundColor = backgroundColor
        x.textColor = color
        if circle > 0 {
            x.cornerRadius(circle)
        }
        return x
    }
}

extension UIButton {
    /// 快速创建UIButton
    @objc class func quickButton(_ title: String? = nil,
                                 titleColor: UIColor = UIColor.dyt_title,
                                 image: UIImage? = nil,
                                 selectImage: UIImage? = nil,
                                 font: UIFont = APPFont.regular(size: 16),
                                 backgroundColor: UIColor = UIColor.white,
                                 cornerRadius: CGFloat = 0,
                                 tag: NSInteger = 0,
                                 target: Any? = nil,
                                 action: Selector? = nil
    ) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font
        button.backgroundColor = backgroundColor
        if target != nil {
            button.addTarget(target, action: action!, for: .touchUpInside)
        }
        if image != nil {
            button.setImage(image, for: .normal)
        }
        if selectImage != nil {
            button.setImage(selectImage, for: .selected)
        }
        if cornerRadius > 0 {
            button.cornerRadius(cornerRadius)
        }
        button.tag = tag

        return button
    }
    
    public func addGradientLayer() {
        let layer = CALayer()
        layer.frame = self.bounds
        layer.backgroundColor = UIColor(red: 0.29, green: 0.32, blue: 0.36, alpha: 1).cgColor
        self.layer.addSublayer(layer)
        // gradientCode
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.99, green: 0.13, blue: 0.26, alpha: 1).cgColor, UIColor(red: 1, green: 0.58, blue: 0.03, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = self.bounds
        self.layer.addSublayer(gradient1)
        self.layer.cornerRadius = self.size.height/2;
        if let lab = self.titleLabel {
            self.bringSubviewToFront(lab)
        }
    }
}

extension UIImageView {
    @objc class func quickImageView(image: UIImage? = nil, highlightedImage: UIImage? = nil, cornerRadius: CGFloat = 0) -> UIImageView {
        let x = UIImageView()
        x.image = image
        x.highlightedImage = highlightedImage
        if cornerRadius > 0 {
            x.cornerRadius(cornerRadius)
        }
        return x
    }
}

extension NSMutableAttributedString {
    // 快速定义富文本样式
    @objc class func highLightText(_ normal: String? = nil,
                                   highLight: String? = nil,
                                   font: UIFont = APPFont.regular(size: 15),
                                   highLightFont:UIFont?,
                                   color: UIColor,
                                   highLightColor: UIColor) -> NSMutableAttributedString {
        // 判断内容是否存在
        guard let normalStr = normal else { return NSMutableAttributedString() }
        guard let hignLightStr = highLight else { return NSMutableAttributedString(attributedString: NSAttributedString(string: normalStr)) }

        let attributedStrM: NSMutableAttributedString = NSMutableAttributedString()

        let strings = normalStr.components(separatedBy: hignLightStr)

        for i in 0 ..< strings.count {
            let item = strings[i]
            let dict = [NSAttributedString.Key.font: font,
                        NSAttributedString.Key.foregroundColor: color]

            let content = NSAttributedString(string: item, attributes: dict)
            attributedStrM.append(content)

            if i != strings.count - 1 {
                let dict1 = [NSAttributedString.Key.font: highLightFont ?? font,
                             NSAttributedString.Key.foregroundColor: highLightColor]

                let content2 = NSAttributedString(string: hignLightStr,
                                                  attributes: dict1)
                attributedStrM.append(content2)
            }
        }
        return attributedStrM
    }
}

/// 快速获取当前类字符串, 可做唯一identifier使用
public extension NSObject {
    class var nameOfClass: String {
        return (NSStringFromClass(self).components(separatedBy: ".")).last!
    }

    var nameOfClass: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
    }
}

extension Date {
    /// 获取当前时间戳, 精确到毫秒
    static func getCurrentTimeString() -> String {
        return String(format: "%llu", UInt64(Date().timeIntervalSince1970 * 1000))
    }

    /// 获取传入日期的时间戳
    static func getDateTimeString(date: Date) -> String {
        return String(format: "%llu", UInt64(date.timeIntervalSince1970 * 1000))
    }

    /// 获取传入日期字符串的时间戳
    static func getDateTimeString(dateStr: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let date = formatter.date(from: dateStr) else {return "0"}
        return String(format: "%llu", UInt64(date.timeIntervalSince1970))
    }
}
extension NSMutableAttributedString {
    /// 计算文字尺寸
    public func sizeWithText(limitSize: CGSize) -> CGSize {
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect: CGRect = self.boundingRect(with: limitSize, options: option, context: nil)
        return CGSize(width: CGFloat(ceil(Float(rect.size.width))), height: CGFloat(ceil(Float(rect.size.height))))
    }
}
extension UILabel {
    
  @objc func touchAt(_ point: CGPoint) -> CFIndex {
        var idx = -1
        
        var p = point
        
        // 初始化framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(self.attributedText!)
        
        // 创建path
        let path = CGMutablePath()
        path.addRect(self.bounds)
        
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
            let style = self.attributedText?.attribute(NSAttributedString.Key.paragraphStyle, at: 0, effectiveRange: nil)
            
            var lineSpace : CGFloat = 0.0
            
            if (style != nil) {
                lineSpace = (style as! NSParagraphStyle).lineSpacing
            }
            let lineH = ascent + abs(descent) + leading
            let textH = lineH * CGFloat(numberOfLines) + lineSpace * CGFloat(numberOfLines - 1)
            let textY = (bounds.height - textH) * 0.5
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
