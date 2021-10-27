//
//  HomeViewController.swift
//  LookingFriend
//
//  Created by 曲超 on 2021/10/12.
//

import UIKit
import SnapKit

class HomeViewController: DCViewController {

    var childVCs:[DCViewController] = []
    
    var pageMenu:SPPageMenu = {
        let pageMenu = SPPageMenu(frame: CGRect(x: 5, y: XTopMargin() + gScale(41), width: KScreen_Width, height: gScale(40)), trackerStyle: .lineAttachment)
        pageMenu.itemTitleFont = APPFont.regular(size: 14)
        pageMenu.selectedItemTitleFont = APPFont.medium(size: 14)
        pageMenu.selectedItemTitleColor = UIColor.dyt_title
        pageMenu.unSelectedItemTitleColor = UIColor.dyt_title
        pageMenu.unSelectedItemTitleFont = APPFont.regular(size: 14)
        pageMenu.tracker.backgroundColor = UIColor.dyt_title
        pageMenu.trackerWidth = 10
        pageMenu.permutationWay = .scrollAdaptContent
        pageMenu.dividingLine.isHidden = true
        pageMenu.setTrackerHeight(4, cornerRadius: 2)
        pageMenu.setItems(["推荐","同城"], selectedItemIndex: 0)
        pageMenu.trackerBottomMargin = 0.0
        pageMenu.itemPadding = 32
        pageMenu.backgroundColor = .clear
        pageMenu.selectedItemZoomScale = 1.6
        return pageMenu
    }()
    
    let sendBtn = UIButton.quickButton("发布", titleColor: .white, image: gImage("camera_icon"), selectImage: gImage("camera_icon"), font: APPFont.regular(size: 12), backgroundColor: .white, tag: 10272140, target: self, action: #selector(sendClick))
    
    
    var reVC = RecommendController()
    
    var nearVc = NearPeopleViewController()
    
    lazy var scrollView: UIScrollView = {
        let s = UIScrollView(frame: CGRect(x: 0, y: pageMenu.bottom_sd, width: KScreen_Width, height: KScreen_Height - pageMenu.bottom_sd - XTabHeight()))
        s.contentSize = CGSize(width: 2*KScreen_Width, height: 0)
        s.isPagingEnabled = true
        s.showsVerticalScrollIndicator = false
        s.showsHorizontalScrollIndicator = false
        
        if #available(iOS 11.0, *) {
            s.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 13.0, *) {
            s.automaticallyAdjustsScrollIndicatorInsets = true
        } else {
            // Fallback on earlier versions
        }
    
        return s
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        print("首页")
        view.addSubview(pageMenu)
        view.addSubview(sendBtn)
        view.addSubview(scrollView)
        pageMenu.delegate = self
   
        sendBtn.sd.topSpace(view, XTopMargin() + gScale(41)).rightSpace(view, gScale(13.5)).heightIs(gScale(25)).widthIs(gScale(60))
        sendBtn.setBackgroundImage(gImage("action_btn_back"), for: .normal)
        sendBtn.setLayout(.ImageLeftTitleRightStyle, aSpacing: gScale(3.5))
        
        pageMenu.sd.centerYEqual(sendBtn).offset(-gScale(2))
        
        addChild(reVC)
        addChild(nearVc)
        
        childVCs.append(reVC)
        childVCs.append(nearVc)

        reVC.view.frame = CGRect(x: 0, y: 0, width: KScreen_Width, height: scrollView.height_sd)
        nearVc.view.frame = CGRect(x: KScreen_Width, y: 0, width: KScreen_Width, height: scrollView.height_sd)
        
        scrollView.sd_addSubviews([reVC.view!, nearVc.view!])
        pageMenu.bridgeScrollView = scrollView
        self.isHiddenNavigationBar = true
        
    }
    
    @objc func sendClick() {
        DYTHUDTool.showWDToast("点击发布")
    }
}

extension HomeViewController:SPPageMenuDelegate {
    func pageMenu(_ pageMenu: SPPageMenu, itemSelectedFrom fromIndex: Int, to toIndex: Int) {
        if !scrollView.isDragging {
            if (labs(toIndex - fromIndex) >= 2) {
                scrollView.setContentOffset(CGPoint(x: Int(KScreen_Width) * toIndex, y: 0), animated: false)
            }else {
                scrollView.setContentOffset(CGPoint(x: Int(KScreen_Width) * toIndex, y: 0), animated: true)
            }
        }
        if childVCs.count <= toIndex {return}
        let v = childVCs[toIndex]
        if v.isViewLoaded {return}
        v.view.frame = CGRect(x: KScreen_Width * CGFloat(toIndex), y: 0, width: KScreen_Width, height: scrollView.height)
        scrollView.addSubview(v.view)
    }
}
