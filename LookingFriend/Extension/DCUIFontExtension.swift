//
// Created by WhenYouBelieve on 2020/3/23.
// Copyright (c) 2020 导医通. All rights reserved.
//


struct APPFont {
    static func regular(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Medium", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    static func light(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Light", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "PingFangSC-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}
