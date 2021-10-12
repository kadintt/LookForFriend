//
// Created by chenjg on 2020/1/2.
// Copyright (c) 2020 导医通. All rights reserved.
//

import RTRootNavigationController

class DCBaseNavController: RTRootNavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    
}
