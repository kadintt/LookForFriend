//
//  DCControllerExtension.swift
//  pavodoctor
//
//  Created by maoge on 2020/4/14.
//  Copyright © 2020 导医通. All rights reserved.
//

import UIKit

extension UIViewController: SwizzleProtocol {
    
    static func awake() {
        swizzleMethod
    }

    private static let swizzleMethod: Void = {
        let originalSelector = #selector(present(_:animated:completion:))
        let swizzledSelector = #selector(swizzled_present(_:animated:completion:))

        swizzlingForClass(UIViewController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
    }()

    @objc func swizzled_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            viewControllerToPresent.modalPresentationStyle = .fullScreen
        }
        swizzled_present(viewControllerToPresent, animated: flag, completion: completion)
    }

}
