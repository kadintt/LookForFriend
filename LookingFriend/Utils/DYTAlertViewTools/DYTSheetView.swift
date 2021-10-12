//
//  DCSheetView.swift
//  pavodoctor
//
//  Created by 曲超 on 2020/12/30.
//  Copyright © 2020 导医通. All rights reserved.
//

import UIKit

@objc protocol DYTSheetViewDelegate {
    func sheetViewDataSource(sheet: DYTSheetView, tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func sheetViewDidSelect(sheet: DYTSheetView, tableView: UITableView, indexPath: IndexPath)
}

class DYTSheetView: UIView {
    /// tableView行数
    @objc var numberOfRow: NSInteger = 0
    /// 标题
    @objc var title: NSAttributedString? {
        didSet {
            titleLabel.attributedText = title
        }
    }

    /// 底部取消
    @objc var isHaveCancle: Bool = true {
        didSet {
            cancleBtn.isHidden = !isHaveCancle
        }
    }
    /// 右上角取消
    @objc var isHaveTopRightCancle: Bool = false {
        didSet {
            topRightCancleBtn.isHidden = !isHaveTopRightCancle
        }
    }

    private weak var delegate: DYTSheetViewDelegate?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.separatorStyle = .none
        scrollFixForIOS11(scrollView: tableView)
        tableView.bounces = false
        return tableView
    }()

    private lazy var contentView: UIView = {
        let x = UIView()
        x.backgroundColor = UIColor.dyt_background
        x.frame = CGRect(x: 0, y: KScreen_Height, width: KScreen_Width, height: KScreen_Height)
        return x
    }()

    private lazy var titleLabel: UILabel = {
        let x = UILabel.quickLabel(font: APPFont.medium(size: 13), textAlignment: .center, color: UIColor.dyt_title, backgroundColor: .white, circle: 0)
        return x
    }()

    private lazy var cancleBtn: UIButton = {
        let x = UIButton.quickButton("取消", titleColor: UIColor.dyt_title, image: nil, selectImage: nil, font: APPFont.regular(size: 16), backgroundColor: UIColor.white)
        x.addTouchUpInside ({ [weak self] _ in
            self?.hide()
        })
        return x
    }()

    private lazy var topRightCancleBtn: UIButton = {
        let x = UIButton.quickButton(image: UIImage(named: "search_close_img"), backgroundColor: UIColor.white)
        x.isHidden = true
        x.addTouchUpInside({ [weak self] _ in
            self?.hide()
        })
        return x
    }()

    /// 构造方法
    /// - Parameter delegate: 代理
    @objc required init(delegate: DYTSheetViewDelegate) {
        super.init(frame: CGRect(x: 0, y: 0, width: KScreen_Width, height: KScreen_Height))
        self.delegate = delegate
        setup()
        addTap()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - API

extension DYTSheetView {
    @objc func show() {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.addSubview(self)
        reset()
    }

    @objc func hide(_ complet: CommonBlock? = nil) {
        animate(false) { [weak self] _ in
            complet?(nil)
            self?.removeFromSuperview()
        }
    }
}

// MARK: - 私有方法

extension DYTSheetView {
    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.0)
        sd_addSubviews([
            contentView,
        ])
        contentView.sd_addSubviews([
            tableView,
            titleLabel,
            cancleBtn,
            topRightCancleBtn,
        ])
        contentView.maskRoundedRect([.topLeft, .topRight])

        contentView.sd.leftEqual(self).rightEqual(self)

        titleLabel.sd.topEqual(contentView).leftEqual(contentView).rightEqual(contentView).heightIs(50)

        tableView.sd.topSpace(titleLabel, 0).leftEqual(contentView).rightEqual(contentView).heightIs(KScreen_Height)

        cancleBtn.sd.leftEqual(contentView).rightEqual(contentView).heightIs(50).topSpace(tableView, 10)
        topRightCancleBtn.sd.rightSpace(contentView, 20).topSpace(contentView, 20).widthIs(20).heightIs(20)
        contentView.setupAutoHeight(withBottomView: cancleBtn, bottomMargin: xBottomMargin)
    }

    /// 初始化界面
    private func reset() {
        if title == nil {
            titleLabel.sd.heightIs(0)
        }
        tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            _ = self.tableView.sd.heightIs(self.tableView.cellsTotalHeight())
            if !self.isHaveCancle {
                self.cancleBtn.sd.heightIs(0)
            }
            self.contentView.updateLayoutSubViews()
            self.animate(true)
        })
    }

    /// 动画
    private func animate(_ isShow: Bool, finish: CommonBlock? = nil) {
        if isShow {
            UIView.animate(withDuration: 0.3) {
                self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.contentView.bottom = self.height
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                self.contentView.top = self.height
            }) { _ in
                finish?(nil)
            }
        }
    }

    /// 添加手势
    private func addTap() {
        addTap { [weak self] _ in
            self?.hide({ _ in })
        }
        contentView.addTap { _ in }
    }
}

extension DYTSheetView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRow
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = delegate?.sheetViewDataSource(sheet: self, tableView: tableView, indexPath: indexPath) else { return UITableViewCell() }
        cell.addTap { [weak self] _ in
            if let this = self {
                this.delegate?.sheetViewDidSelect(sheet: this, tableView: tableView, indexPath: indexPath)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(for: indexPath, cellContentViewWidth: KScreen_Width, tableView: tableView)
    }
}
