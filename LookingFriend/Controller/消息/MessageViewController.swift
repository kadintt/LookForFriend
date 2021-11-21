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
        titleL.sd.leftSpace(view, gScale(14.5)).topSpace(view, gScale(45) + XTopMargin()).heightIs(22).widthIs(44)
        tableView.sd.spaceToSuperView(UIEdgeInsets(top: gScale(45 + 22 + 10) + XTopMargin(), left: 0, bottom: 0, right: 0))
        tableView.reloadData()
        tableView.backgroundColor  = .white
        self.isHiddenNavigationBar = true
    }
}

extension MessageViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageCell(tableView: tableView, xib: false)!
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return gScale(65)
    }
}
