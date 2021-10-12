//
// Created by 1chenjg on 2020/1/2.
// Copyright (c) 2020 导医通. All rights reserved.
//

// MARK: - API

@objc extension DCViewController {
    /// 是否开启手势返回
    var isPopGestureEnable: Bool {
        get {
            objc_getAssociatedObject(self, "isPopGestureEnable".unsafePointer) as? Bool ?? false
        }
        set {
            rt_disableInteractivePop = !newValue
            objc_setAssociatedObject(self, "isPopGestureEnable".unsafePointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 是否显示导航栏
    var isHiddenNavigationBar: Bool {
        get {
            objc_getAssociatedObject(self, "isHiddenNavigationBar".unsafePointer) as? Bool ?? false
        }
        set {
            navigationController?.setNavigationBarHidden(newValue, animated: false)
            objc_setAssociatedObject(self, "isHiddenNavigationBar".unsafePointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 导航栏
    var navigationBar: DCNavigationBar? {
        navigationController?.navigationBar as? DCNavigationBar
    }

    /// 返回Action
    func onBack() {
        if rt_navigationController?.viewControllers.count ?? 0 > 1 {
            pop()
        } else if presentationController != nil {
            dismiss(animated: true)
        } else if rt_navigationController.presentationController != nil {
            rt_navigationController?.dismiss(animated: true)
        }
    }

    /// 封装push
    func push(vc: UIViewController, animate: Bool = true, complete: ((Bool) -> Void)? = nil) {
        vc.hidesBottomBarWhenPushed = true
        rt_navigationController?.pushViewController(vc, animated: animate, complete: complete ?? { _ in
        })
    }

    /// 封装pop
    func pop(animate: Bool = true, complete: ((Bool) -> Void)? = nil) {
        rt_navigationController?.popViewController(animated: animate, complete: complete ?? { _ in
        })
    }

    /// 封装popTo
    func popTo(vc: UIViewController, animate: Bool = true, complete: ((Bool) -> Void)? = nil) {
        rt_navigationController?.pop(to: vc, animated: animate, complete: complete ?? { _ in
        })
    }

    /// 封装popToRoot
    func popToRoot(animate: Bool = true, complete: ((Bool) -> Void)? = nil) {
        rt_navigationController?.popToRootViewController(animated: animate, complete: complete ?? { _ in
        })
    }

    /// 添加导航Item
    @discardableResult func addNavigationItem(_ title: String?,selTitle:String? = nil, titleColor:UIColor? = .black, titleFont:UIFont? = APPFont.regular(size: 16), image: UIImage?, sel: Selector, isLeft: Bool = true) -> UIBarButtonItem {
         let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
         btn.setTitle(title, for: .normal)
         btn.setTitleColor(titleColor, for: .normal)
         if let selT = selTitle {
             btn.setTitle(selT, for: .selected)
         }
         btn.titleLabel?.font = titleFont
         btn.setImage(image, for: .normal)
         btn.addTarget(self, action: sel, for: .touchUpInside)
         let item = UIBarButtonItem(customView: btn)
         var items: [UIBarButtonItem] = (isLeft ? navigationItem.leftBarButtonItems : navigationItem.rightBarButtonItems) ?? []
         items.append(item)
         if isLeft {
             navigationItem.setLeftBarButtonItems(items, animated: false)
         } else {
             navigationItem.setRightBarButtonItems(items, animated: false)
         }
         return item
     }

    /// 设置导航栏alpha变化
    func setNavgationBarAlpha(alpha: CGFloat) {
        setNavgationBarColor(color: alpha >= 1 ? UIColor.white : UIColor.white.withAlphaComponent(alpha))
        navigationBar?.setTitleColor(alpha >= 1 ? UIColor.black : UIColor(red: Int(255 - 255 * alpha), green: Int(255 - 255 * alpha), blue: Int(255 - 255 * alpha)))
        navigationBar?.changeNavItemColor(alpha >= 1 ? UIColor.black : UIColor(red: Int(255 - 255 * alpha), green: Int(255 - 255 * alpha), blue: Int(255 - 255 * alpha)))
    }

    /// 设置导航栏颜色
    func setNavgationBarColor(color: UIColor) {
        navigationBar?.backgroundColor = color
    }
}

@objc extension DCBaseFormController {
    /// 是否开启手势返回
    var isPopGestureEnable: Bool {
        get {
            objc_getAssociatedObject(self, "isPopGestureEnable".unsafePointer) as? Bool ?? false
        }
        set {
            rt_disableInteractivePop = !newValue
            objc_setAssociatedObject(self, "isPopGestureEnable".unsafePointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 是否显示导航栏
    var isHiddenNavigationBar: Bool {
        get {
            objc_getAssociatedObject(self, "isHiddenNavigationBar".unsafePointer) as? Bool ?? false
        }
        set {
            navigationController?.setNavigationBarHidden(newValue, animated: false)
            objc_setAssociatedObject(self, "isHiddenNavigationBar".unsafePointer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 导航栏
    var navigationBar: DCNavigationBar? {
        navigationController?.navigationBar as? DCNavigationBar
    }

    /// 返回Action
    func onBack() {
        if rt_navigationController?.viewControllers.count ?? 0 > 1 {
            pop()
        } else if presentationController != nil {
            dismiss(animated: true)
        } else if rt_navigationController.presentationController != nil {
            rt_navigationController?.dismiss(animated: true)
        }
    }

    /// 封装push
    func push(vc: UIViewController, animate: Bool = true, complete: ((Bool) -> Void)? = nil) {
        vc.hidesBottomBarWhenPushed = true
        rt_navigationController?.pushViewController(vc, animated: animate, complete: complete ?? { _ in
        })
    }

    /// 封装pop
    func pop(animate: Bool = true, complete: ((Bool) -> Void)? = nil) {
        rt_navigationController?.popViewController(animated: animate, complete: complete ?? { _ in
        })
    }

    /// 封装popTo
    func popTo(vc: UIViewController, animate: Bool = true, complete: ((Bool) -> Void)? = nil) {
        rt_navigationController?.pop(to: vc, animated: animate, complete: complete ?? { _ in
        })
    }

    /// 封装popToRoot
    func popToRoot(animate: Bool = true, complete: ((Bool) -> Void)? = nil) {
        rt_navigationController?.popToRootViewController(animated: animate, complete: complete ?? { _ in
        })
    }

    /// 添加导航Item
    @discardableResult func addNavigationItem(_ title: String?, titleColor:UIColor? = .black, titleFont:UIFont? = APPFont.regular(size: 16), image: UIImage?, sel: Selector, isLeft: Bool = true) -> UIBarButtonItem {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.titleLabel?.font = titleFont
        btn.setImage(image, for: .normal)
        btn.addTarget(self, action: sel, for: .touchUpInside)
        let item = UIBarButtonItem(customView: btn)
        var items: [UIBarButtonItem] = (isLeft ? navigationItem.leftBarButtonItems : navigationItem.rightBarButtonItems) ?? []
        items.append(item)
        if isLeft {
            navigationItem.setLeftBarButtonItems(items, animated: false)
        } else {
            navigationItem.setRightBarButtonItems(items, animated: false)
        }
        return item
    }

    /// 设置导航栏alpha变化
    func setNavgationBarAlpha(alpha: CGFloat) {
        setNavgationBarColor(color: alpha >= 1 ? UIColor.white : UIColor.white.withAlphaComponent(alpha))
        navigationBar?.setTitleColor(alpha >= 1 ? UIColor.black : UIColor(red: Int(255 - 255 * alpha), green: Int(255 - 255 * alpha), blue: Int(255 - 255 * alpha)))
        navigationBar?.changeNavItemColor(alpha >= 1 ? UIColor.black : UIColor(red: Int(255 - 255 * alpha), green: Int(255 - 255 * alpha), blue: Int(255 - 255 * alpha)))
    }

    /// 设置导航栏颜色
    func setNavgationBarColor(color: UIColor) {
        navigationBar?.backgroundColor = color
    }
}
