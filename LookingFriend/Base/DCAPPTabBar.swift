//
// Created by WhenYouBelieve on 2020/3/23.
// Copyright (c) 2020 导医通. All rights reserved.
//

class DCAPPTabBar: UITabBar {

    @objc var centerBtnClick: (() -> Void)?

    private lazy var centerBtn: UIButton = {
        let x = UIButton(type: UIButton.ButtonType.custom)
        return x
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        sd_addSubviews([centerBtn])
        centerBtn.sd.centerXEqual(self).topEqual(self).offset(-12).widthIs(44).heightIs(44)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let newPoint = convert(point, to: centerBtn)
        if isHidden == false,
           centerBtn.point(inside: newPoint, with: event) {
            return centerBtn
        }
        return super.hitTest(point, with: event)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        hideLine()
    }

    /// 隐藏iOS13以后的分割线
    private func hideLine() {
        if #available(iOS 13.0, *) {
            subviews.forEach { (sub) in
                if type(of: sub).description() == "_UIBarBackground" {
                    sub.subviews.forEach { (imageV) in
                        if imageV is UIImageView {
                            imageV.backgroundColor = .clear
                        } else {
                            imageV.subviews.forEach { (item) in
                                item.backgroundColor = .clear
                            }
                        }
                    }
                }
            }
        }
    }
}

