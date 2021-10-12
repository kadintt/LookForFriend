//
//  SDLayoutExtention.swift
//  DaoyitongCode
//
//  Created by chenjg on 2019/10/11.
//  Copyright © 2019 爱康国宾. All rights reserved.
//

import SDAutoLayout

struct SDLayoutSwift {

    weak var view: UIView?

    fileprivate var layout: SDAutoLayoutModel

    init(_ layout: SDAutoLayoutModel) {
        self.layout = layout
    }

    @discardableResult func leftSpace(_ viewOrArray: Any?, _ space: CGFloat) -> SDLayoutSwift {
        guard let viewOrArray = viewOrArray else { return self }
        _ = layout.leftSpaceToView(viewOrArray, space)
        return self
    }

    @discardableResult func rightSpace(_ viewOrArray: Any?, _ space: CGFloat) -> SDLayoutSwift {
        guard let viewOrArray = viewOrArray else { return self }
        _ = layout.rightSpaceToView(viewOrArray, space)
        return self
    }

    @discardableResult func topSpace(_ viewOrArray: Any?, _ space: CGFloat) -> SDLayoutSwift {
        guard let viewOrArray = viewOrArray else { return self }
        _ = layout.topSpaceToView(viewOrArray, space)
        return self
    }

    @discardableResult func bottomSpace(_ viewOrArray: Any?, _ space: CGFloat) -> SDLayoutSwift {
        guard let viewOrArray = viewOrArray else { return self }
        _ = layout.bottomSpaceToView(viewOrArray, space)
        return self
    }

    @discardableResult func xIs(_ number: CGFloat) -> SDLayoutSwift {
        _ = layout.xIs(number)
        return self
    }

    @discardableResult func yIs(_ number: CGFloat) -> SDLayoutSwift {
        _ = layout.yIs(number)
        return self
    }

    @discardableResult func centerXIs(_ number: CGFloat) -> SDLayoutSwift {
        _ = layout.centerXIs(number)
        return self
    }

    @discardableResult func centerYIs(_ number: CGFloat) -> SDLayoutSwift {
        _ = layout.centerYIs(number)
        return self
    }

    @discardableResult func widthIs(_ number: CGFloat) -> SDLayoutSwift {
        _ = layout.widthIs(number)
        return self
    }

    @discardableResult func heightIs(_ number: CGFloat) -> SDLayoutSwift {
        _ = layout.heightIs(number)
        return self
    }

    @discardableResult func maxWidthIs(_ number: CGFloat) -> SDLayoutSwift {
        _ = layout.maxWidthIs(number)
        return self
    }

    @discardableResult func maxHeightIs(_ number: CGFloat) -> SDLayoutSwift {
        _ = layout.maxHeightIs(number)
        return self
    }

    @discardableResult func minWidthIs(_ number: CGFloat) -> SDLayoutSwift {
        _ = layout.minWidthIs(number)
        return self
    }

    @discardableResult func minHeightIs(_ number: CGFloat) -> SDLayoutSwift {
        _ = layout.minHeightIs(number)
        return self
    }

    @discardableResult func leftEqual(_ view: UIView) -> SDLayoutSwift {
        _ = layout.leftEqualToView(view)
        return self
    }

    @discardableResult func rightEqual(_ view: UIView) -> SDLayoutSwift {
        _ = layout.rightEqualToView(view)
        return self
    }

    @discardableResult func topEqual(_ view: UIView) -> SDLayoutSwift {
        _ = layout.topEqualToView(view)
        return self
    }

    @discardableResult func bottomEqual(_ view: UIView) -> SDLayoutSwift {
        _ = layout.bottomEqualToView(view)
        return self
    }

    @discardableResult func centerXEqual(_ view: UIView) -> SDLayoutSwift {
        _ = layout.centerXEqualToView(view)
        return self
    }

    @discardableResult func centerYEqual(_ view: UIView) -> SDLayoutSwift {
        _ = layout.centerYEqualToView(view)
        return self
    }

    /** 宽度是参照view宽度的多少倍，参数为“(View, CGFloat)” */
    @discardableResult func widthRatio(_ view: UIView, _ ratio: CGFloat) -> SDLayoutSwift {
        _ = layout.widthRatioToView(view, ratio)
        return self
    }

    /** 高度是参照view高度的多少倍，参数为“(View, CGFloat)” */
    @discardableResult func heightRatio(_ view: UIView, _ ratio: CGFloat) -> SDLayoutSwift {
        _ = layout.heightRatioToView(view, ratio)
        return self
    }

    /** 设置一个view的宽度和它的高度相同，参数为空“()” */
    @discardableResult func widthEqualToHeight() -> SDLayoutSwift {
        _ = layout.widthEqualToHeight()
        return self
    }

    /** 设置一个view的高度和它的宽度相同，参数为空“()” */
    @discardableResult func heightEqualToWidth() -> SDLayoutSwift {
        _ = layout.heightEqualToWidth()
        return self
    }

    /** 自适应高度，传入高宽比值，label可以传0实现文字高度自适应 */
    @discardableResult func autoHeight(_ ratio: CGFloat) -> SDLayoutSwift {
        _ = layout.autoHeightRatio(ratio)
        return self
    }

    /** 自适应宽度，参数为宽高比值 */
    @discardableResult func autoWidth(_ ratio: CGFloat) -> SDLayoutSwift {
        _ = layout.autoWidthRatio(ratio)
        return self
    }

    /** 传入UIEdgeInsetsMake(top, left, bottom, right)，可以快捷设置view到其父view上左下右的间距  */
    func spaceToSuperView(_ insets: UIEdgeInsets) {
        _ = layout.spaceToSuperView(insets)
    }

    /** 设置偏移量，参数为“(CGFloat value)，目前只有带有equalToView的方法可以设置offset” */
    @discardableResult func offset(_ number: CGFloat) -> SDLayoutSwift {
        _ = layout.offset(number)
        return self
    }

    /** 设置sd_maxWidth的属性， 一般用作Label */
    @discardableResult func maxWidthForLabel(_ number: CGFloat = UIScreen.main.bounds.size.width) -> SDLayoutSwift {
        view?.sd_maxWidth = NSNumber(value: Float(number))
        return self
    }
}


extension UIView {

    private static var layoutKey = "layoutKey"

    /** 开始自动布局  */
    var sd: SDLayoutSwift {
        get {
            if let rs = objc_getAssociatedObject(self, &UIView.layoutKey) as? SDLayoutSwift {
                return rs
            } else {
                self.sd = SDLayoutSwift(sd_layout()!)
                self.sd.view = self
                return self.sd
            }
        }
        set {
            objc_setAssociatedObject(self, &UIView.layoutKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /** 清空之前的自动布局设置，重新开始自动布局(重新生成布局约束并使其在父view的布局序列数组中位置保持不变)  */
    var sdReset: SDLayoutSwift {
        sd.layout = sd_resetLayout()
        return sd
    }

    /// 清空之前的自动布局设置，重新开始自动布局(重新生成布局约束并添加到父view布局序列数组中的最后一个位置)
    var sdNew: SDLayoutSwift {
        sd.layout = sd_resetNewLayout()
        return sd
    }
}
