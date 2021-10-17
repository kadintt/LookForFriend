//
//  NearPeopleCell.swift
//  LookingFriend
//
//  Created by 曲超 on 2021/10/17.
//

import UIKit

class NearPeopleCell: UITableViewCell {
    
    
    lazy var headImageV:UIImageView = {
        let v = UIImageView()
        v.cornerRadius = gScale(63)/2
        v.backgroundColor = .white
        return v
    }()
    
    let nickName = UILabel.quickLabel("", font: APPFont.regular(size: 15), textAlignment: .left, color: .dyt_title)
    
    let ageBtn = UIButton.quickButton("18", titleColor: .white, image: gImage("female_flag_icon"), selectImage: gImage("female_flag_icon"), font: APPFont.regular(size: 9))
    
    lazy var localImageV:UIImageView = {
        let v = UIImageView(image: gImage("localtion_icon"))
        return v
    }()
    
    let distanceNum = UILabel.quickLabel("你心里", font: APPFont.regular(size: 11), textAlignment: .right, color: UIColor(hex: 0x9DA4B3))
    
    let content = UILabel.quickLabel("你心里", font: APPFont.regular(size: 12), textAlignment: .left, color: UIColor(hex: 0x6D788E))

    let baseLine:UIView = {
        let v = UIView()
        v.backgroundColor = .dyt_line
        return v
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: gScale(74), height: gScale(74))
        layout.minimumLineSpacing = gScale(4)
        layout.minimumInteritemSpacing = gScale(4)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.showsVerticalScrollIndicator = false
        v.backgroundColor = .white
        v.dataSource = self
        v.delegate = self
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    private func setUpUI() {
        contentView.sd_addSubviews([headImageV,nickName,ageBtn,distanceNum,content,baseLine,collectionView])
        headImageV.sd.topSpace(contentView, gScale(13.5)).leftSpace(contentView, gScale(14)).heightIs(gScale(63)).widthIs(gScale(63))
                nickName.sd.topSpace(contentView, gScale(20)).leftSpace(headImageV, gScale(10.5)).heightIs(gScale(14.5)).rightSpace(contentView, gScale(100))
        distanceNum.sd.centerYEqual(nickName).rightSpace(contentView, gScale(14)).heightIs(gScale(9.5))
        localImageV.sd.centerYEqual(distanceNum).rightSpace(distanceNum, gScale(5.5)).heightIs(gScale(12.5)).widthIs(gScale(10))
        ageBtn.sd.leftSpace(headImageV, gScale(11)).topSpace(nickName, gScale(7.5)).widthIs(gScale(28.5)).heightIs(gScale(12))
        content.sd.leftSpace(headImageV, gScale(11.5)).topSpace(ageBtn, gScale(7.5)).rightSpace(contentView, gScale(14)).autoHeight(0)
        ageBtn.setBackgroundImage(gImage("male_back_icon"), for: .normal)
        baseLine.sd.bottomEqual(contentView).rightEqual(contentView).leftSpace(headImageV, gScale(11)).heightIs(gScale(0.5))
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension NearPeopleCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = NearPeopleColCell(collectionView: collectionView, indexPath: indexPath, xib: false)!
        
        return cell
    }
}


class NearPeopleColCell:UICollectionViewCell {
    
    lazy var coverImageView:UIImageView = {
        let v = UIImageView()
        v.backgroundColor = UIColor.white
        v.cornerRadius(gScale(5))
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        contentView.addSubview(coverImageView)
        coverImageView.sd.spaceToSuperView(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
}
