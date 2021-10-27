//
// Created by chenjg on 2020/1/2.
// Copyright (c) 2020 导医通. All rights reserved.
//

@objc enum DCNavigationBarShadowStyle: NSInteger {
    case line
    case shadow
    case none
}
import SwifterSwift

class DCNavigationBar: UINavigationBar {

    private lazy var shadowImageView: UIImageView = {
        var shadowImageView: UIImageView = UIImageView()
        shadowImageView.backgroundColor = .clear
        return shadowImageView
    }()

    private lazy var contentView: UIImageView = {
        let x = UIImageView()
        x.backgroundColor = .clear
        return x
    }()

    private var color: UIColor = .white

    override var backgroundColor: UIColor? {
        get {
            color
        }
        set {
            super.backgroundColor = .clear
            color = newValue ?? .white
            contentView.image = UIImage(color: color, size: CGSize(width: KScreen_Width, height: XNavHeight()))
            sendSubviewToBack(contentView)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isTranslucent = false
        setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        shadowImage = UIImage()
        insertSubview(contentView, at: 0)
        contentView.sd.leftEqual(self).rightEqual(self).bottomEqual(self).heightIs(XNavHeight())
        sd_addSubviews([shadowImageView])
        shadowImageView.sd.leftEqual(self).rightEqual(self).heightIs(1).bottomEqual(self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        hideNavigationBackground()
        fixItemMargin()
        backgroundColor = color
    }

    private func hideNavigationBackground() {
        for item in subviews {
            if type(of: item).description().contains("_UIBarBackground") {
                item.backgroundColor = .clear
                item.subviews.forEach { view in
                    view.backgroundColor = .clear
                    view.subviews.forEach { view1 in
                        view1.backgroundColor = .clear
                    }
                }
            } else if type(of: item).description().contains("_UINavigationBarBackIndicatorView") {
                item.backgroundColor = .clear
            } else {
                continue
            }
        }
    }

    @objc func changeNavItemColor(_ color: UIColor?) {
        items?.forEach({ item in
            item.leftBarButtonItems?.forEach({ leftItem in
                leftItem.tintColor = color
                guard let btn = leftItem.customView as? UIButton else {
                    return
                }
                btn.setImage(btn.image(for: .normal)?.filled(withColor: color ?? .clear), for: .normal)
            })
            item.rightBarButtonItems?.forEach({ rightItem in
                rightItem.tintColor = color
                guard let btn = rightItem.customView as? UIButton else {
                    return
                }
                btn.setImage(btn.image(for: .normal)?.filled(withColor: color ?? .clear), for: .normal)
            })
        })
    }

    @objc func setTitle(_ title: String?) {
        topItem?.title = title
    }

    @objc func setTitleColor(_ color: UIColor?) {
        guard let color = color else {
            return
        }
        var atts: [NSAttributedString.Key: Any] = titleTextAttributes ?? [:]
        atts[NSAttributedString.Key.foregroundColor] = color
        titleTextAttributes = atts
    }

    typealias Block = () -> Void

    @objc func addLeftItemWithImage(_ image: UIImage?, block: Block?) {
        guard items?.isEmpty == false else {
            return
        }
        var leftItems = items?[0].leftBarButtonItems ?? []
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.addTouchUpInside { (_) in
            block?()
        }
        btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        btn.setImage(image, for: .normal)
        let item = UIBarButtonItem(customView: btn)
        leftItems.append(item)
        items?[0].leftBarButtonItems = leftItems
    }

    @objc func addRightItem(with button: UIButton, _ block: Block?) {
        guard items?.isEmpty == false else {
            return
        }
        var rightItems = items?[0].rightBarButtonItems ?? []
        let btn = button
        btn.addTouchUpInside { (_) in
            block?()
        }
        let item = UIBarButtonItem(customView: btn)
        rightItems.append(item)
        items?[0].rightBarButtonItems = rightItems
        DispatchQueue.main.async {
            self.layoutSubviews()
        }
    }

    private func fixItemMargin() {
        if #available(iOS 11.0, *) {
            let content = subviews.first { (item) -> Bool in
                type(of: item).description().contains("_UINavigationBarContentView")
            }
            content?.constraints.forEach({ lay in
                if lay.firstAttribute == NSLayoutConstraint.Attribute.trailing,
                   lay.secondAttribute == NSLayoutConstraint.Attribute.leading,
                   (lay.secondItem as? UIView) == content {
                    lay.constant = 4
                }

            })
        }
    }
}
