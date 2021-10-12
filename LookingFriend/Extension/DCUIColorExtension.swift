//
// Created by WhenYouBelieve on 2020/3/23.
// Copyright (c) 2020 导医通. All rights reserved.
//

extension UIColor {

    /// 导医通颜色遍历构造函数
    convenience init(hexString: String, alpha: CGFloat = 1) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIColor {

    /// 新背景
    @objc static let dyt_new_background = UIColor(hexString: "f4f5f6")

    @objc static let dyt_title = UIColor(hexString: "222222")
    /// 正文 494847
    @objc static let dyt_text = UIColor(hexString: "494847")
    /// 描述 83817F
    @objc static let dyt_description = UIColor(hexString: "83817F")
    /// placeholder E1E0DF
    @objc static let dyt_placeholder = UIColor(hexString: "E1E0DF")
    /// 价格#FF632B
    @objc static let dyt_price = UIColor(hexString: "FF632B")

    @objc static let dyt_card_lines = UIColor(hexString: "E8FAF6")
    /// line E1E0DF
    @objc static var dyt_line = dyt_placeholder
    /// 主要绿色 11C3C3
    @objc static let dyt_main = UIColor(hexString: "11C3C3")
    /// 蓝色 007AFF
    @objc static let dyt_blue = UIColor(hexString: "007AFF")
    /// 背景色 FAFAFA
    @objc static let dyt_background = UIColor(hexString: "FAFAFA")
    /// 搜索栏背景色 EDEDED
    @objc static let dyt_search_background = UIColor(hexString: "#EDEDED")
    /// 聊天背景色 EDEDED
    @objc static let dyt_chat_background = UIColor(hexString: "EDEDED")
    /// 提醒框背景红色 FFEDEC
    @objc static let dyt_red_background = UIColor(hexString: "FFEDEC")
    /// 按钮绿 2AD5D5
    @objc static let dyt_button = UIColor(hexString: "2AD5D5")
    /// 按钮灰 E1E0DF
    @objc static let dyt_button_disable = dyt_placeholder
    /// 加粗标题 深色文字颜色 242a29
    @objc static let dyt_bold_title = UIColor(hexString: "242a29")
    /// 个人中心cell 文字颜色 2A2827
     @objc static let dyt_cell_title = UIColor(hexString: "2A2827")
    /// 导医通阴影颜色 1F8888 alpha = 0.1
    @objc static let dyt_shadow = UIColor(hexString: "1F8888", alpha: 0.08)
    /// 价钱颜色 FD7038
    @objc static let dyt_cell_price = UIColor(hexString: "#FD7038")
    /// 导航栏颜色 423E3E
    @objc static let dyt_nav_title = UIColor(hexString: "#423E3E")
    /// 处方编号等背景颜色 F5F6F6
    @objc static let dyt_pres_back = UIColor(hexString: "#F5F6F6")
    /// 处方编号等 字体颜色 83899A
    @objc static let dyt_pres_title = UIColor(hexString: "#83899A")
    /// 处方&病历详情 等底边线颜色 eceeef
    @objc static let dyt_pres_bottomLine = UIColor(hexString: "#ECEEEF")
    /// 处方 药品使用说明描述颜色 C4C2C0
    @objc static let dyt_pres_desc = UIColor(hexString: "#C4C2C0")
    
    /// 待服务 FF4C4C
    @objc static let dyt_wait_service = UIColor(hexString: "FF4C4C")
    /// 服务中 2ECB47
    @objc static let dyt_during_service = UIColor(hexString: "2ECB47")
    /// 服务结束 FF8C80
    @objc static let dyt_end_service = UIColor(hexString: "FF8C80")
    /// 已取消 C4C2C0
    @objc static let dyt_cancel_service = UIColor(hexString: "C4C2C0")
}

