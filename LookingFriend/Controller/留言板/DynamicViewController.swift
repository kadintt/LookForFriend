//
//  DynamicViewController.swift
//  LookingFriend
//
//  Created by 曲超 on 2021/10/12.
//

import UIKit

class DynamicViewController: DCViewController {
    
    let commodities = FModel.loadData()

    
    let itemWidth = (KScreen_Width - 28 - gScale(7)) / 2
    
    let  titleL = UILabel.quickLabel("留言板", font: APPFont.medium(size: 22), textAlignment: .left, color: .dyt_title)

    let sendBtn = UIButton.quickButton("留言", titleColor: .white, image: gImage("message_icon"), selectImage: gImage("message_icon"), font: APPFont.regular(size: 12), backgroundColor: .white, tag: 10272140, target: self, action: #selector(sendClick))
    
    var botV:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: 0x0E0D12)
        v.cornerRadius = gScale(2)
        return v
    }()
    
    
    var collectionView:UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isHiddenNavigationBar = true
        view.backgroundColor = .white
        

        addTopViews()
        configColView()

        
       
        
        
    }
    
    private func addTopViews() {
        view.sd_addSubviews([titleL,botV,sendBtn])
        let w = "留言板".sizeWithText(font: APPFont.medium(size: 22), CGSize(width: 100, height: gScale(22))).width
        titleL.sd.leftSpace(view, gScale(16)).topSpace(view, gScale(44)).heightIs(22).widthIs(w)
        botV.sd.centerXEqual(titleL).heightIs(gScale(4)).widthIs((10)).topSpace(titleL,10)
    
        sendBtn.sd.topSpace(view, XTopMargin() + gScale(41.5)).rightSpace(view, gScale(14)).heightIs(gScale(25)).widthIs(gScale(60))
        sendBtn.setBackgroundImage(gImage("action_btn_back"), for: .normal)
        sendBtn.setLayout(.ImageLeftTitleRightStyle, aSpacing: gScale(3.5))
    }
    
    private func configColView() {
        
        let layout = WaterfallLayout()
        layout.itemSize = { [unowned self] indexPath in
            let model = self.commodities[indexPath.item]
            return CGSize(width: model.w, height: model.h)
        }
        layout.headerHeight = { _ in return 0 }
        layout.footerHeight = { _ in return 0 }
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        
        

        
        collectionView?.backgroundColor = .white
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView?.dataSource = self
        
        
        view.addSubview(collectionView!)
        collectionView?.sd.topSpace(botV,0).leftEqual(view).rightEqual(view).bottomEqual(view)
        collectionView?.reloadData()
    }
    
    @objc func sendClick() {
        DYTHUDTool.showWDToast("点击留言")
    }

}
extension DynamicViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        commodities.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = DynamicCell(collectionView: collectionView, indexPath: indexPath, xib: false)!
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let r = indexPath.item % 3
//
//        switch r {
//
//        case 0:
//            return CGSize(width: itemWidth, height: gScale(182.5))
//        case 1:
//            return CGSize(width: itemWidth, height: gScale(150))
//        case 2:
//            return CGSize(width: itemWidth, height: gScale(135))
//        default:
//            return CGSize(width: itemWidth, height: gScale(182.5))
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        gScale(10)
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        gScale(7)
//    }
//

    
}
