//
//  SwizzleProtocol.swift
//  pavodoctor
//
//  Created by maoge on 2020/4/14.
//  Copyright © 2020 导医通. All rights reserved.
//
import UIKit

// MARK: - 方法交换协议
protocol SwizzleProtocol: AnyObject {
    static func awake()
    static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector)
}

extension SwizzleProtocol {
    
    static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        guard (originalMethod != nil && swizzledMethod != nil) else {
            return
        }
        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
}

// 创建代理执行单例 (Swift弃用了load和initialize()方法, 所以通过下面的方式获取继承方法交换协议的对象, 来实现类似load的效果)
class NothingToSeeHere {
    static func harmlessFunction() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount)) //获取所有的类
        for index in 0 ..< typeCount {
            (types[index] as? SwizzleProtocol.Type)?.awake() //如果该类实现了SwizzleProtocol协议，那么调用awake方法
        }
        types.deallocate()
    }
}

extension UIApplication {
    private static let runOnce: Void = {
        NothingToSeeHere.harmlessFunction()
    }()
    
    override open var next: UIResponder? {
        UIApplication.runOnce
        return super.next
    }
}
