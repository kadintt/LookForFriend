//
// Created by WhenYouBelieve on 2020/3/23.
// Copyright (c) 2020 导医通. All rights reserved.
//

// MARK: - 私有属性，方法

private extension UIView {
    var tapBlock: UIGestureRecognizerBlock? {
        get {
            objc_getAssociatedObject(self, "tapBlock".unsafePointer) as? UIGestureRecognizerBlock
        }
        set {
            for item in gestureRecognizers ?? [] where item is UITapGestureRecognizer {
                removeGestureRecognizer(item)
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.tapAction))
            addGestureRecognizer(tap)
            objc_setAssociatedObject(self, "tapBlock".unsafePointer, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    @objc func tapAction(_ tap: UIGestureRecognizer) {
        tapBlock?(tap)
    }
}

// MARK: - 事件

extension UIView {
    typealias UIGestureRecognizerBlock = (_ sender: UIGestureRecognizer) -> Void

    @objc func addTap(_ block: UIGestureRecognizerBlock?) {
        isUserInteractionEnabled = true
        tapBlock = block
    }
}

// MARK: - 线条

extension UIView {
    @objc var bottomLine: UIView {
        guard let x = objc_getAssociatedObject(self, "bottomLine".unsafePointer) as? UIView else {
            let x = UIView()
            x.backgroundColor = .dyt_line
            addSubview(x)
            x.sd.leftEqual(self).rightEqual(self).heightIs(0.5).bottomEqual(self)
            objc_setAssociatedObject(self, "bottomLine".unsafePointer, x, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return x
        }
        return x
    }
}

// MARK: - 圆角

extension UIView {
    @objc func maskRoundedRect(_ rectCorner: UIRectCorner = .allCorners, radius: CGFloat = 16) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: rectCorner, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
    
    @objc func maskRoundedRect(_ rectCorner: UIRectCorner = .allCorners, radius: CGFloat = 16, bounds: CGRect) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: rectCorner, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }

    @objc func cornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}

// MARK: - 圆角加阴影

extension UIView {
    
    @objc func shadowRadius(color:UIColor = UIColor(white: 0, alpha: 0.05),
                            radius: CFloat = 8,
                            shadowRadius: CGFloat = 10,
                            shadowOpacity:Float = 1,
                            shadowOffset:CGSize = CGSize(width: 0, height: 0)) {
        self.layer.cornerRadius = CGFloat(radius)
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = CGFloat(shadowRadius)
    }
    
}

// MARK: - Bundle加载XIB

extension UIView {
    @objc class func loadFromXib(_ nibNmae: String? = nil) -> Self {
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
}
