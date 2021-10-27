//
//  MessageViewController.swift
//  LookingFriend
//
//  Created by 曲超 on 2021/10/12.
//

import UIKit

class MessageViewController: BaseTableViewController {

    let  titleL = UILabel.quickLabel("消息", font: APPFont.medium(size: 22), textAlignment: .left, color: .dyt_title)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleL)
        titleL.sd.leftSpace(view, gScale(14.5)).topSpace(view, gScale(45)).heightIs(22).widthIs(44)
//        tableView.sd.spaceToSuperView(UIEdgeInsets(top: titleL.bottom_sd, left: 0, bottom: 0, right: 0))
//        tableView.reloadData()
    }
}
