//
//  DCBaseFormController.swift
//  pavodoctor
//
//  Created by maoge on 2020/4/9.
//  Copyright © 2020 导医通. All rights reserved.
//

import UIKit
import XLForm

class DCBaseFormController: XLFormViewController {
    lazy var formDescriptor: XLFormDescriptor = XLFormDescriptor()

    override func viewDidLoad() {
        super.viewDidLoad()

        rt_disableInteractivePop = false
        automaticallyAdjustsScrollViewInsets = false
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        navigationBar?.setTitleColor(.dyt_nav_title)
        navigationBar?.backgroundColor = .dyt_background
        if rt_navigationController.viewControllers.count > 1 {
            addNavigationItem(nil, image: UIImage(named: "nav_back"), sel: #selector(onBack), isLeft: true)
        }
    }

    deinit {
        print("控制器: \(self.nameOfClass.description)\n标题: \(self.navigationItem.title ?? "")\n----------------销毁了--------------")
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}

extension DCBaseFormController {
    // 将左侧label高亮状态颜色变为导医通绿
    override func beginEditing(_ rowDescriptor: XLFormRowDescriptor!) {
        let cell = rowDescriptor.cell(forForm: self)
        cell.textLabel?.textColor = UIColor.dyt_main
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func rt_navigationBarClass() -> AnyClass! {
        return DCNavigationBar.self
    }
}

// MARK: - TableView Delegate

extension DCBaseFormController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 设置分割线左右边线缩进15
        cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

        // 去除描述及图片的分割线
        if indexPath.section == tableView.numberOfSections - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: KScreen_Width - 15)
        }
    }
}

// MARK: - remind 顶部提示图

class DCFormRemindView: UIView {
    var textAlignment: NSTextAlignment? {
        didSet {
            remindLabel.textAlignment = textAlignment ?? .left
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = UIColor.dyt_red_background
        configUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func configUI() {
  
    }

    func setText(_ text: String?, view: UIView?) {
        if let textStr = text {
            remindLabel.text = textStr
            let size = textStr.sizeWithLimitHeight(font: APPFont.regular(size: 14), KScreen_Width - 54)
            frame = CGRect(x: 0, y: 0, width: KScreen_Width, height: size.height + 16)

            view?.addSubview(self)
        }
    }

    private lazy var remindLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.dyt_text
        label.numberOfLines = 0
        label.font = APPFont.regular(size: 14)
        label.text = "待写入"
        return label
    }()

    private lazy var remindImgView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "order_tag_tips_nor"))
        return imgView
    }()
}
