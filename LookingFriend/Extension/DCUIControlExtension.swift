//
// Created by WhenYouBelieve on 2020/3/23.
// Copyright (c) 2020 导医通. All rights reserved.
//


private extension UIControl {

    static var touchUpInsideBlock_key = "touchUpInsideBlock_key"
    var touchUpInsideBlock: UIControlBlock? {
        get {
            objc_getAssociatedObject(self, &UIControl.touchUpInsideBlock_key) as? UIControlBlock
        }
        set {
            removeTarget(self, action: #selector(touchUpInsideEvent), for: .touchUpInside)
            addTarget(self, action: #selector(touchUpInsideEvent), for: .touchUpInside)
            objc_setAssociatedObject(self, &UIControl.touchUpInsideBlock_key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    @objc func touchUpInsideEvent() {
        touchUpInsideBlock?(self)
    }
}

extension UIControl {
    typealias UIControlBlock = (_ sender: UIControl) -> Void

    func addTouchUpInside(_ block: UIControlBlock?) {
        touchUpInsideBlock = block
    }
}
