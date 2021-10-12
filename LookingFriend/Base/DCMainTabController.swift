//
// Created by chenjg on 2020/1/2.
// Copyright (c) 2020 导医通. All rights reserved.
//

import UIKit

class DCMainTabController: UITabBarController {

    private var controllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()        
        let v = UIView(frame: CGRect(x: 0, y: 0, width: KScreen_Width, height: 0.5))
        v.backgroundColor = UIColor(hex: 0xEEEEF2)
        tabBar.addSubview(v)
        
        print(tabBar.subviews)
    }

    private func setup() {

        addItems(vc: HomeViewController(), title: "", image: UIImage(named: "home_nomal"), selectedImage: UIImage(named: "home_sel"))
        addItems(vc: DynamicViewController(), title: "", image: UIImage(named: "dynamic_nomal"), selectedImage: UIImage(named: "dynamic_sel"))
        addItems(vc: MessageViewController(), title: "", image: UIImage(named: "message_nomal"), selectedImage: UIImage(named: "message_sel"))
        addItems(vc: MineViewController(), title: "", image: UIImage(named: "mine_nomal"), selectedImage: UIImage(named: "mine_sel"))
        setViewControllers(controllers, animated: true)

    }

    private func addItems(vc: UIViewController, title: String?, image: UIImage?, selectedImage: UIImage?) {
        let item = UITabBarItem.init(title: title, image: image?.withRenderingMode(.alwaysOriginal), selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        item.setTitleTextAttributes([.foregroundColor: UIColor.dyt_title], for: .normal)
        item.setTitleTextAttributes([.foregroundColor: UIColor.dyt_bold_title], for: .selected)
        item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 0)
        item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let nav = DCBaseNavController(rootViewController: vc)
        nav.tabBarItem = item
        controllers.append(nav)
    }
    
    private func addTabBarShadow() {
        // 移除顶部线条
        tabBar.backgroundImage =  UIImage(color: .white)
        tabBar.shadowImage =  UIImage()
        // 添加阴影
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowOpacity = 0.8
    }
}

extension DCMainTabController: UITabBarControllerDelegate {

    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        
//        if (viewController as? DCBaseNavController)?.rt_viewControllers.first is DCPersonCenterController, !KDCDataManager.isLogin {
//            
//            KDCDataManager.checkLogin { [weak self] in
//                self?.selectedViewController = viewController
//            }
//          
//            return false
//        }
        return true
    }

}
