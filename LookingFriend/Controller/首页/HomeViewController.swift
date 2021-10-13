//
//  HomeViewController.swift
//  LookingFriend
//
//  Created by 曲超 on 2021/10/12.
//

import UIKit

class HomeViewController: BaseTableViewController {

    lazy var pageMenu:SPPageMenu = {
        let pageMenu = SPPageMenu(frame: CGRect(x: 5, y: KNav_Height + 28 - 40, width: KScreen_Width, height: 40), trackerStyle: .lineAttachment)
        pageMenu.itemTitleFont = APPFont.regular(size: 14)
        pageMenu.selectedItemTitleFont = APPFont.medium(size: 14)
        pageMenu.selectedItemTitleColor = UIColor.dyt_title
        pageMenu.unSelectedItemTitleColor = UIColor.dyt_title
        pageMenu.unSelectedItemTitleFont = APPFont.regular(size: 14)
        pageMenu.tracker.backgroundColor = UIColor.dyt_title
        pageMenu.trackerWidth = 10
        pageMenu.permutationWay = .scrollAdaptContent
        pageMenu.dividingLine.isHidden = true
        pageMenu.delegate = self
        pageMenu.setTrackerHeight(4, cornerRadius: 2)
        pageMenu.setItems(["推荐","同城"], selectedItemIndex: 0)
        pageMenu.trackerBottomMargin = 0.0
        pageMenu.itemPadding = 32
        pageMenu.backgroundColor = .clear
        pageMenu.selectedItemZoomScale = 1.6
        return pageMenu
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .dyt_background
        self.isHiddenNavigationBar = true
        print("首页")
        view.addSubview(pageMenu)
    }
    

}

extension HomeViewController:SPPageMenuDelegate {
    
}
