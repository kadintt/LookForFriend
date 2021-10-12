//
//  DYTLoadingView.swift
//  DaoyitongCode
//
//  Created by maoge on 2020/8/13.
//  Copyright © 2020 爱康国宾. All rights reserved.
//

import Lottie
import UIKit

@objcMembers class DYTLoadingView: UIView {

    static func showLoading(in view: UIView) {
        hideLoading(in: view)
        let v = DYTLoadingView(frame: KWindow?.bounds ?? CGRect.zero)
        view.addSubview(v)
        v.startAnimation()
    }

    static func hideLoading(in view: UIView) {
        view.subviews.forEach { v in
            if v.isKind(of: DYTLoadingView.self) {
                let result = v as! DYTLoadingView
                result.stopAnimation()
                result.removeFromSuperview()
            }
        }
    }

    private func startAnimation() {
        animationView?.play()
    }

    private func stopAnimation() {
        animationView?.stop()
    }

    private lazy var animationView: LOTAnimationView? = {
        let v = LOTAnimationView(name: "dytLoading", bundle: .main)
        v.contentMode = .scaleAspectFit
        v.loopAnimation = true
        v.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        v.center = CGPoint(x: self.center.x, y: self.center.y - KNav_Height)
        addSubview(v)
        return v
    }()
}
