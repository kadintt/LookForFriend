//
//  RecommendPeopleCell.swift
//  LookingFriend
//
//  Created by 曲超 on 2021/10/17.
//

import UIKit


class RecommendPeopleCell: UICollectionViewCell {
    
    lazy var coverImageView:UIImageView = {
        let v = UIImageView()
        v.backgroundColor = UIColor.white
        v.cornerRadius(gScale(14))
        return v
    }()
    
    lazy var headImageView:UIImageView = {
        let v = UIImageView()
        v.backgroundColor = UIColor.white
        v.cornerRadius(gScale(15))
        return v
    }()
    
    lazy var nickName:UILabel = UILabel.quickLabel("测试", font: APPFont.regular(size: 13), textAlignment: .left, color: .white)
    
    lazy var lookForIcon:UIImageView = UIImageView(image: UIImage(named: "watch_icon"))
    
    lazy var watchNum:UILabel = UILabel.quickLabel("98k", font: APPFont.regular(size: 10), textAlignment: .left, color: .white)
    
    lazy var maskCoverView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        contentView.backgroundColor = UIColor.white
        contentView.sd_addSubviews([coverImageView, maskCoverView, headImageView, nickName, lookForIcon, watchNum])
        coverImageView.snp.makeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
        maskCoverView.frame = CGRect(x: 0, y: 0, width: (KScreen_Width - gScale(35))/2, height: gScale(250))
        gradient()
        
        headImageView.sd.heightIs(gScale(30)).widthIs(gScale(30)).leftSpace(contentView, gScale(7.5)).bottomEqual(contentView).offset(-gScale(12.5))
        nickName.sd.leftSpace(headImageView, gScale(8)).heightIs(12.5).rightSpace(contentView, gScale(14)).topEqual(headImageView).offset(gScale(1))
        
        lookForIcon.sd.topSpace(nickName, gScale(5.5)).heightIs(gScale(8.5)).widthIs(gScale(13)).leftEqual(nickName).offset(-gScale(1))
        
        watchNum.sd.centerYEqual(lookForIcon).leftSpace(lookForIcon, gScale(4)).heightIs(gScale(8)).rightEqual(nickName)
        

    }
    
    func gradient() {
        let gradient1 = CAGradientLayer()
        gradient1.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor, UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor]
        gradient1.locations = [0, 1]
        gradient1.startPoint = CGPoint(x: 0.5, y: 1)
        gradient1.endPoint = CGPoint(x: 0.5, y: 0)
        gradient1.frame = maskCoverView.bounds
        maskCoverView.layer.addSublayer(gradient1)
        maskCoverView.layer.cornerRadius = 15;
        maskCoverView.layer.masksToBounds = true
    }
}
