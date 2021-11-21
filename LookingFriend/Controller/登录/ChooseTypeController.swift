//
//  ChooseTypeController.swift
//  LookingFriend
//
//  Created by 曲超 on 2021/11/13.
//

import UIKit

class ChooseTypeController: DCViewController {
    
    let skipBtn = UIButton.quickButton("跳过", titleColor: .white, font: APPFont.regular(size: 12),backgroundColor: .clear,tag: 11132046, target: self, action: #selector(skipBtnClick))
    
    let titleL = UILabel.quickLabel("选择你交友的类型", font: APPFont.regular(size: 28), textAlignment: .left, color: .white)
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: gScale(90), height: gScale(30))
        layout.minimumLineSpacing = gScale(15)
        layout.minimumInteritemSpacing = gScale(15)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.showsVerticalScrollIndicator = false
        v.backgroundColor = .clear
        v.dataSource = self
        v.delegate = self
        return v
    }()
    
    
    var typeList:[ChooseTypeModel] = []
    
    let experienceBtn = UIButton.quickButton("开始体验", titleColor: .white, font: APPFont.regular(size: 16),backgroundColor: .clear,cornerRadius: gScale(44)/2,tag: 11132049, target: self, action: #selector(experienceBtnClick))
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.5)
        view.sd_addSubviews([titleL, skipBtn, collectionView, experienceBtn])
        skipBtn.sd.topSpace(view, gScale(32)).rightSpace(view, 0).heightIs(gScale(52)).widthIs(64)
        titleL.sd.leftSpace(view, gScale(30.5)).rightEqual(view).heightIs(gScale(26.5)).topSpace(view, gScale(79.5) + XTopMargin())
        
        let colW = gScale(90) * 3 + gScale(15) * 2
        
        let colH = gScale(30) * 7 + gScale(15) * 6
        
        let x = (KScreen_Width - colW)/2
        
        collectionView.sd.topSpace(titleL, gScale(58)).leftSpace(view, x).widthIs(colW).heightIs(colH)
        experienceBtn.sd.topSpace(collectionView, gScale(60)).centerXEqual(view).heightIs(gScale(44)).widthIs(gScale(264))
        
        gradientLayerBtn()
        
        for i in 0...20 {
            let model = ChooseTypeModel()
            model.typeStr = "类型-\(i+1)"
            typeList.append(model)
        }
        
        collectionView.reloadData()
        self.isHiddenNavigationBar = true
    }
    
    private func gradientLayerBtn() {
        let layer = CALayer()
        layer.frame = experienceBtn.bounds
        layer.backgroundColor = UIColor(red: 0.29, green: 0.32, blue: 0.36, alpha: 1).cgColor
        experienceBtn.layer.addSublayer(layer)
        // gradientCode
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.99, green: 0.13, blue: 0.26, alpha: 1).cgColor, UIColor(red: 1, green: 0.58, blue: 0.03, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = experienceBtn.bounds
        experienceBtn.layer.addSublayer(gradient1)
        experienceBtn.layer.cornerRadius = gScale(44)/2;
//        experienceBtn.layer.insertSublayer(, at: <#T##UInt32#>)
        experienceBtn.bringSubviewToFront(experienceBtn.titleLabel!)
        
    }
    
    @objc func experienceBtnClick() {
        
    }
    
    @objc func skipBtnClick() {
        pop()
    }
}
extension ChooseTypeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        typeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = ChooseTypeCell(collectionView: collectionView, indexPath: indexPath, xib: false)!
        let model = typeList[indexPath.item]
        cell.chooseL.text = model.typeStr
        cell.gradientView.isHidden = !model.isSelect
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = typeList[indexPath.item]
        model.isSelect = !model.isSelect
        typeList[indexPath.item] = model
        collectionView.reloadData()
    }
}

class ChooseTypeCell: UICollectionViewCell {
    
    let gradientView = UIView(frame: CGRect(x: 0, y: 0, width: gScale(90), height: gScale(30)))
    
    let chooseL = UILabel.quickLabel("滑雪", font: APPFont.regular(size: 13), textAlignment: .center, color: .white)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        
        contentView.addSubview(gradientView)
        
        contentView.backgroundColor = UIColor(hex: 0xFFFFFF, alpha: 0.3)
        contentView.cornerRadius = gScale(30)/2
        
        let layer = CALayer()
        layer.frame = gradientView.bounds
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        gradientView.layer.addSublayer(layer)
        // gradientCode
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0.99, green: 0.13, blue: 0.26, alpha: 1).cgColor, UIColor(red: 1, green: 0.58, blue: 0.03, alpha: 1).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient1.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient1.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradient1)
        gradientView.layer.cornerRadius = gScale(30)/2;
        
        contentView.insertSubview(gradientView, at: 0)
        gradientView.isHidden = false
        
        contentView.addSubview(chooseL)
        chooseL.sd.leftSpace(contentView, gScale(13)).rightSpace(contentView, gScale(13)).centerYEqual(contentView).heightIs(gScale(12.5))
    }
}
